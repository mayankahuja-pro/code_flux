class CodingSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  const CodingSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });
}