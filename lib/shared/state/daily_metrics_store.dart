import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habit_control/screens/input_log/models/daily_metrics.dart';

/// Stores per-day "daily metrics" and synchronizes them with Firestore.
///
/// Visible persistence:
/// - Local cache in [SharedPreferences] under [_prefsKey]
/// - Pending day keys under [_pendingKey] (used for best-effort retry sync)
///
/// Visible Firestore paths:
/// - `users/{uid}/metrics/{dayKey}`
class DailyMetricsStore extends ChangeNotifier {
  static const _pendingKey = 'daily_metrics_pending_days_v1';
  final Set<String> _pendingDays = <String>{};

  /// Creates the store.
  ///
  /// Optional [auth] and [firestore] parameters are used for dependency
  /// injection in tests or previews.
  DailyMetricsStore({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const _prefsKey = 'daily_metrics_by_day_v1';

  final Map<String, DailyMetrics> _byDay = {};

  /// Returns stored metrics for [dayKey] or a zero-value default.
  DailyMetrics metricsForDay(String dayKey) {
    return _byDay[dayKey] ??
        const DailyMetrics(sleepHours: 0, energy: 0, socialHours: 0);
  }

  /// Loads cached metrics and pending sync markers from [SharedPreferences].
  Future<void> loadLocal() async {
    final prefs = await SharedPreferences.getInstance();

    // Loads the metrics map if present.
    final raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      _byDay
        ..clear()
        ..addAll(
          decoded.map((k, v) {
            return MapEntry(
              k,
              DailyMetrics.fromMap((v as Map).cast<String, dynamic>()),
            );
          }),
        );
    }

    // Loads pending days independently of whether metrics are present.
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

  /// Updates metrics for [dayKey], persists locally, and writes to Firestore when
  /// a Firebase user is available.
  ///
  /// On Firestore write failure, [dayKey] is added to the pending set so it can
  /// be retried via [trySyncPending].
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
          .set(_withUpdatedAt(value), SetOptions(merge: true));

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

  Map<String, dynamic> _withUpdatedAt(DailyMetrics value) {
    final map = value.toMap();
    map['updatedAt'] = FieldValue.serverTimestamp();
    return map;
  }

  /// Reads metrics for [dayKey] from Firestore and overwrites the local cache.
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
    final map = _byDay.map((k, v) {
      return MapEntry(k, v.toMap());
    });
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  /// Attempts to flush any pending days to Firestore.
  ///
  /// The method iterates over a snapshot of pending day keys and, on successful
  /// write, removes each day from the pending set.
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
            .set(_withUpdatedAt(value), SetOptions(merge: true));

        _pendingDays.remove(dayKey);
        await _savePending();
      } on FirebaseException catch (e) {
        debugPrint('trySyncPending metrics failed: ${e.code}');
      } catch (e) {
        debugPrint('trySyncPending metrics failed: $e');
      }
    }
  }

  /// Clears local caches (metrics + pending markers) from memory and storage.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await prefs.remove(_pendingKey);

    _byDay.clear();
    _pendingDays.clear();

    notifyListeners();
  }
}
