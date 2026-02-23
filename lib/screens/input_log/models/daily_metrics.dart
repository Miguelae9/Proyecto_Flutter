class DailyMetrics {
  final double sleepHours;
  final int energy;
  final double socialHours;

  const DailyMetrics({
    required this.sleepHours,
    required this.energy,
    required this.socialHours,
  });

  Map<String, dynamic> toMap() => {
    'sleepHours': sleepHours,
    'energy': energy,
    'socialHours': socialHours,
  };

  static DailyMetrics fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const DailyMetrics(sleepHours: 0, energy: 0, socialHours: 0);
    }

    double toDouble(dynamic v) =>
        (v is int) ? v.toDouble() : (v is double ? v : 0.0);

    int toInt(dynamic v) => (v is int) ? v : (v is double ? v.toInt() : 0);

    return DailyMetrics(
      sleepHours: toDouble(map['sleepHours']),
      energy: toInt(map['energy']),
      socialHours: toDouble(map['socialHours']),
    );
  }
}
