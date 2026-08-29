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