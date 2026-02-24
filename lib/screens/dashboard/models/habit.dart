/// Static habit metadata used by the dashboard UI.
///
/// Needs clarification from author: Habit "streak" values are provided as static
/// strings in code; no data source is visible for calculating streaks.
class Habit {
  final String id;
  final String title;
  final String streakText;

  const Habit({
    required this.id,
    required this.title,
    required this.streakText,
  });
}
