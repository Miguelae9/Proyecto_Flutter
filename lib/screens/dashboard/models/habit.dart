class Habit {
  final String title;
  final String streakText;
  bool active;

  Habit({required this.title, required this.streakText, bool? active})
    : active = active ?? false;
}
