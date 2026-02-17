import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habit_control/screens/input_log/models/daily_metrics.dart';

class DailyMetricsStore extends ChangeNotifier {
  static const _pendingKey = 'daily_metrics_pending_days_v1';
  final Set<String> _pendingDays = <String>{};

  DailyMetricsStore({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const _prefsKey = 'daily_metrics_by_day_v1';

  final Map<String, DailyMetrics> _byDay = {};

  DailyMetrics metricsForDay(String dayKey) =>
      _byDay[dayKey] ??
      const DailyMetrics(sleepHours: 0, energy: 0, socialHours: 0);

  Future<void> loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return;

    final Map<String, dynamic> decoded = jsonDecode(raw);
    _byDay
      ..clear()
      ..addAll(
        decoded.map(
          (k, v) => MapEntry(
            k,
            DailyMetrics.fromMap((v as Map).cast<String, dynamic>()),
          ),
        ),
      );

    final pendingRaw = prefs.getString(_pendingKey);
    if (pendingRaw != null && pendingRaw.isNotEmpty) {
      final List<dynamic> decodedPending = jsonDecode(pendingRaw);
      _pendingDays
        ..clear()
        ..addAll(decodedPending.cast<String>());
    }

    notifyListeners();
  }

  Future<void> _savePending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingKey, jsonEncode(_pendingDays.toList()));
  }

  Future<void> setMetrics(String dayKey, DailyMetrics value) async {
    _byDay[dayKey] = value;

    notifyListeners();
    await _saveLocal();

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('metrics')
          .doc(dayKey)
          .set({
            ...value.toMap(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      _pendingDays.remove(dayKey);
      await _savePending();
    } on FirebaseException catch (e) {
      debugPrint('Firestore setMetrics failed: ${e.code}');
      _pendingDays.add(dayKey);
      await _savePending();
    } catch (e) {
      debugPrint('setMetrics failed: $e');
      _pendingDays.add(dayKey);
      await _savePending();
    }
  }

  Future<void> syncDayFromCloud(String dayKey) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await _db
          .collection('users')
          .doc(uid)
          .collection('metrics')
          .doc(dayKey)
          .get();
      if (!doc.exists) return;

      _byDay[dayKey] = DailyMetrics.fromMap(doc.data());

      notifyListeners();
      await _saveLocal();
    } on FirebaseException catch (e) {
      debugPrint('Firestore sync metrics failed: ${e.code}');
    } catch (e) {
      debugPrint('sync metrics failed: $e');
    }
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _byDay.map((k, v) => MapEntry(k, v.toMap()));
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  Future<void> trySyncPending() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    if (_pendingDays.isEmpty) return;

    final List<String> days = _pendingDays.toList();

    for (final dayKey in days) {
      final DailyMetrics value =
          _byDay[dayKey] ??
          const DailyMetrics(sleepHours: 0, energy: 0, socialHours: 0);

      try {
        await _db
            .collection('users')
            .doc(uid)
            .collection('metrics')
            .doc(dayKey)
            .set({
              ...value.toMap(),
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        _pendingDays.remove(dayKey);
        await _savePending();
      } on FirebaseException catch (e) {
        debugPrint('trySyncPending metrics failed: ${e.code}');
        // Si sigue fallando, lo dejamos pendiente.
      } catch (e) {
        debugPrint('trySyncPending metrics failed: $e');
      }
    }
  }
}
