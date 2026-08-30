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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
    };
  }

  factory CodingSession.fromJson(Map<String, dynamic> json) {
    return CodingSession(
      id: json['id'] as String,
      startTime: DateTime.parse(
        json['startTime'] as String,
      ),
      endTime: DateTime.parse(
        json['endTime'] as String,
      ),
      durationMinutes: json['durationMinutes'] as int,
    );
  }
}