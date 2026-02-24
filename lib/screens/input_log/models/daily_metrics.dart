/// Immutable value object for daily metric inputs.
class DailyMetrics {
  final double sleepHours;
  final int energy;
  final double socialHours;

  const DailyMetrics({
    required this.sleepHours,
    required this.energy,
    required this.socialHours,
  });

  /// Serializes this instance into a map suitable for JSON/Firestore.
  Map<String, dynamic> toMap() {
    return {
      'sleepHours': sleepHours,
      'energy': energy,
      'socialHours': socialHours,
    };
  }

  /// Creates an instance from a map, tolerating `int`/`double` numeric variants.
  static DailyMetrics fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const DailyMetrics(sleepHours: 0, energy: 0, socialHours: 0);
    }

    double toDouble(dynamic v) {
      if (v is int) {
        return v.toDouble();
      }
      if (v is double) {
        return v;
      }
      return 0.0;
    }

    int toInt(dynamic v) {
      if (v is int) {
        return v;
      }
      if (v is double) {
        return v.toInt();
      }
      return 0;
    }

    return DailyMetrics(
      sleepHours: toDouble(map['sleepHours']),
      energy: toInt(map['energy']),
      socialHours: toDouble(map['socialHours']),
    );
  }
}
