import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productivity_provider.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int _initialSeconds = 25 * 60;
  // static const int _initialSeconds = 10;

  Timer? _timer;

  int _remainingSeconds = _initialSeconds;

  bool _isRunning = false;

  DateTime? _sessionStartTime;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) {
      return;
    }

    _sessionStartTime ??= DateTime.now();

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_remainingSeconds <= 1) {
          _finishSession();
          return;
        }

        setState(() {
          _remainingSeconds--;
        });
      },
    );
  }

  void _pauseTimer() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = _initialSeconds;
      _isRunning = false;
      _sessionStartTime = null;
    });
  }

  void _finishSession() {
    _timer?.cancel();

    final startTime = _sessionStartTime ?? DateTime.now();
    final endTime = DateTime.now();

    context.read<ProductivityProvider>().addCodingSession(
          startTime: startTime,
          endTime: endTime,
          durationMinutes: 25,
        );

    setState(() {
      _remainingSeconds = _initialSeconds;
      _isRunning = false;
      _sessionStartTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Focus session completed! 🎉',
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductivityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Focus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                'Deep Work',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                'Stay focused. One session at a time.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const Spacer(),

              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                ),
                child: Center(
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    icon: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(
                      _isRunning ? 'Pause' : 'Start',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Sessions",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${provider.completedSessionCount} completed',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}