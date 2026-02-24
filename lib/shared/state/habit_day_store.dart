import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitDayStore extends ChangeNotifier {
  HabitDayStore({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance;

  static const _pendingKey = 'habit_pending_days_v1';
  final Set<String> _pendingDays = <String>{};

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const _prefsKey = 'habit_done_by_day_v1';

  final Map<String, Set<String>> _doneByDay = {};
  bool _loadedLocal = false;

  bool get loadedLocal {
    return _loadedLocal;
  }

  Set<String> doneForDay(String dayKey) {
    return _doneByDay[dayKey] ?? <String>{};
  }

  Future<void> _savePending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingKey, jsonEncode(_pendingDays.toList()));
  }

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
    } else {
      _doneByDay.clear();
    }

    final pendingRaw = prefs.getString(_pendingKey);
    if (pendingRaw != null && pendingRaw.isNotEmpty) {
      final List<dynamic> decodedPending = jsonDecode(pendingRaw);
      _pendingDays
        ..clear()
        ..addAll(decodedPending.cast<String>());
    } else {
      _pendingDays.clear();
    }

    _loadedLocal = true;
    notifyListeners();
  }

  Future<void> syncDayFromCloud(String dayKey) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final resolved = await _db
          .collection('users')
          .doc(uid)
          .collection('days')
          .doc(dayKey)
          .get();

      if (!resolved.exists) return;

      final data = resolved.data();
      final list =
          (data?['doneHabitIds'] as List?)?.cast<String>() ?? <String>[];
      _doneByDay[dayKey] = list.toSet();

      notifyListeners();
      await _saveLocal();
    } on FirebaseException catch (e) {
      debugPrint('Firestore syncDayFromCloud failed: ${e.code}');
    } catch (e) {
      debugPrint('syncDayFromCloud failed: $e');
    }
  }

  Future<void> toggleHabitForDay({
    required String dayKey,
    required String habitId,
  }) async {
    final set = _doneByDay.putIfAbsent(dayKey, _newEmptySet);

    if (set.contains(habitId)) {
      set.remove(habitId);
    } else {
      set.add(habitId);
    }

    notifyListeners();
    await _saveLocal();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _db.collection('users').doc(uid).collection('days').doc(dayKey).set(
        {
          'doneHabitIds': set.toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      _pendingDays.remove(dayKey);
      await _savePending();
    } on FirebaseException catch (e) {
      debugPrint('Firestore toggle save failed: ${e.code}');
      _pendingDays.add(dayKey);
      await _savePending();
    } catch (e) {
      debugPrint('toggle save failed: $e');
      _pendingDays.add(dayKey);
      await _savePending();
    }
  }

  Set<String> _newEmptySet() {
    return <String>{};
  }

  Future<void> trySyncPending() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    if (_pendingDays.isEmpty) return;

    final List<String> days = _pendingDays.toList();

    for (final dayKey in days) {
      final set = _doneByDay[dayKey] ?? <String>{};
      try {
        await _db
            .collection('users')
            .doc(uid)
            .collection('days')
            .doc(dayKey)
            .set({
              'doneHabitIds': set.toList(),
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        _pendingDays.remove(dayKey);
        await _savePending();
      } on FirebaseException catch (e) {
        debugPrint('trySyncPending habits failed: ${e.code}');
      } catch (e) {
        debugPrint('trySyncPending habits failed: $e');
      }
    }
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _doneByDay.map((day, ids) {
      return MapEntry(day, ids.toList());
    });
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await prefs.remove(_pendingKey);

    _doneByDay.clear();
    _pendingDays.clear();
    _loadedLocal = false;

    notifyListeners();
  }
}
