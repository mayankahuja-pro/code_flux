import 'package:flutter/foundation.dart';

import '../models/coding_session.dart';
import '../models/task.dart';

class ProductivityProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Fix login API',
      isCompleted: true,
      createdAt: DateTime.now(),
    ),
    Task(
      id: '2',
      title: 'Create profile screen',
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
    Task(
      id: '3',
      title: 'Write unit tests',
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
  ];

  final List<CodingSession> _codingSessions = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<CodingSession> get codingSessions =>
      List.unmodifiable(_codingSessions);

  int get completedSessionCount => _codingSessions.length;

  int get totalCodingMinutes {
    return _codingSessions.fold(
      0,
      (total, session) => total + session.durationMinutes,
    );
  }

  int get todayCodingMinutes {
    final now = DateTime.now();

    return _codingSessions
        .where(
          (session) =>
              session.startTime.year == now.year &&
              session.startTime.month == now.month &&
              session.startTime.day == now.day,
        )
        .fold(
          0,
          (total, session) => total + session.durationMinutes,
        );
  }

  int get weeklyCodingMinutes {
    final now = DateTime.now();

    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      const Duration(days: 6),
    );

    return _codingSessions
        .where(
          (session) => !session.startTime.isBefore(weekStart),
        )
        .fold(
          0,
          (total, session) => total + session.durationMinutes,
        );
  }

  double get averageDailyCodingMinutes {
    if (_codingSessions.isEmpty) {
      return 0;
    }

    return weeklyCodingMinutes / 7;
  }

  int get currentStreak {
    if (_codingSessions.isEmpty) {
      return 0;
    }

    final uniqueDays = <DateTime>{};

    for (final session in _codingSessions) {
      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      uniqueDays.add(date);
    }

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    int streak = 0;
    DateTime currentDay = today;

    while (uniqueDays.contains(currentDay)) {
      streak++;
      currentDay = currentDay.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  int getCodingMinutesForDay(DateTime day) {
    return _codingSessions
        .where(
          (session) =>
              session.startTime.year == day.year &&
              session.startTime.month == day.month &&
              session.startTime.day == day.day,
        )
        .fold(
          0,
          (total, session) => total + session.durationMinutes,
        );
  }

  void addTask(String title) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      return;
    }

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);

    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere(
      (task) => task.id == id,
    );

    if (index == -1) {
      return;
    }

    final task = _tasks[index];

    _tasks[index] = Task(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted,
      createdAt: task.createdAt,
    );

    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere(
      (task) => task.id == id,
    );

    notifyListeners();
  }

  void addCodingSession({
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
  }) {
    final session = CodingSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
    );

    _codingSessions.add(session);

    notifyListeners();
  }
}