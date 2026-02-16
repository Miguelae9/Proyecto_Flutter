import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitDayStore extends ChangeNotifier {
  HabitDayStore({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const _prefsKey = 'habit_done_by_day_v1';

  final Map<String, Set<String>> _doneByDay = {};
  bool _loadedLocal = false;

  bool get loadedLocal => _loadedLocal;

  Set<String> doneForDay(String dayKey) => _doneByDay[dayKey] ?? <String>{};

  Future<void> loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      _doneByDay
        ..clear()
        ..addAll(
          decoded.map((day, list) {
            final ids = (list as List).cast<String>().toSet();
            return MapEntry(day, ids);
          }),
        );
    }
    _loadedLocal = true;
    notifyListeners();
  }

  Future<void> syncDayFromCloud(String dayKey) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('days')
          .doc(dayKey)
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      final list =
          (data?['doneHabitIds'] as List?)?.cast<String>() ?? <String>[];
      _doneByDay[dayKey] = list.toSet();

      notifyListeners();
      await _saveLocal();
    } on FirebaseException catch (e) {
      debugPrint('Firestore syncDayFromCloud failed: ${e.code}');
      // Nos quedamos con SharedPreferences.
    } catch (e) {
      debugPrint('syncDayFromCloud failed: $e');
    }
  }

  Future<void> toggleHabitForDay({
    required String dayKey,
    required String habitId,
  }) async {
    final set = _doneByDay.putIfAbsent(dayKey, () => <String>{});

    if (set.contains(habitId)) {
      set.remove(habitId);
    } else {
      set.add(habitId);
    }

    notifyListeners(); // UI instantánea
    await _saveLocal(); // persistencia local

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final ref = _db
          .collection('users')
          .doc(uid)
          .collection('days')
          .doc(dayKey);
      await ref.set({
        'doneHabitIds': set.toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      debugPrint('Firestore toggle save failed: ${e.code}');
      // No crashear: local ya está guardado.
    } catch (e) {
      debugPrint('toggle save failed: $e');
    }
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _doneByDay.map((day, ids) => MapEntry(day, ids.toList()));
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  Future<void> clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    _doneByDay.clear();
    _loadedLocal = false;
    notifyListeners();
  }
}
