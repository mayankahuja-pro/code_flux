import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/coding_session.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _sessionsKey = 'coding_sessions';

  Future<void> saveTasks(List<Task> tasks) async {
    final preferences = await SharedPreferences.getInstance();

    final data = tasks
        .map((task) => task.toJson())
        .toList();

    await preferences.setString(
      _tasksKey,
      jsonEncode(data),
    );
  }

  Future<List<Task>> loadTasks() async {
    final preferences = await SharedPreferences.getInstance();

    final jsonString = preferences.getString(_tasksKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> data = jsonDecode(jsonString);

      return data
          .map(
            (item) => Task.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCodingSessions(
    List<CodingSession> sessions,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    final data = sessions
        .map((session) => session.toJson())
        .toList();

    await preferences.setString(
      _sessionsKey,
      jsonEncode(data),
    );
  }

  Future<List<CodingSession>> loadCodingSessions() async {
    final preferences = await SharedPreferences.getInstance();

    final jsonString = preferences.getString(_sessionsKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> data = jsonDecode(jsonString);

      return data
          .map(
            (item) => CodingSession.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}