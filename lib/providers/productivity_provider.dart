import 'package:flutter/foundation.dart';

import '../models/coding_session.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class ProductivityProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  final List<Task> _tasks = [];
  final List<CodingSession> _codingSessions = [];

  bool _isLoading = true;

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<CodingSession> get codingSessions =>
      List.unmodifiable(_codingSessions);

  bool get isLoading => _isLoading;

  int get completedSessionCount => _codingSessions.length;

  int get completedTaskCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

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
      uniqueDays.add(
        DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        ),
      );
    }

    DateTime currentDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    int streak = 0;

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

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedTasks = await _storageService.loadTasks();
      final savedSessions =
          await _storageService.loadCodingSessions();

      _tasks
        ..clear()
        ..addAll(savedTasks);

      _codingSessions
        ..clear()
        ..addAll(savedSessions);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
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

    await _storageService.saveTasks(_tasks);
  }

  Future<void> toggleTask(String id) async {
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

    await _storageService.saveTasks(_tasks);
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere(
      (task) => task.id == id,
    );

    notifyListeners();

    await _storageService.saveTasks(_tasks);
  }

  Future<void> addCodingSession({
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
  }) async {
    final session = CodingSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
    );

    _codingSessions.add(session);

    notifyListeners();

    await _storageService.saveCodingSessions(
      _codingSessions,
    );
  }
}