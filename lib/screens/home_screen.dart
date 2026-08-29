import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../utils/constants.dart';
import '../widgets/coding_streak.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());

    final tasks = [
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
      Task(
        id: '4',
        title: 'Review Flutter architecture',
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
    ];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    today,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Your coding momentum',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(height: 12),

                  CodingStreak(
                    streak: AppConstants.mockStreak,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Today's Coding",
                          value: _formatMinutes(
                            AppConstants.mockTodayMinutes,
                          ),
                          icon: Icons.code,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Weekly',
                          value: _formatMinutes(
                            AppConstants.mockWeeklyMinutes,
                          ),
                          icon: Icons.calendar_month,
                        ),
                      ),
                      // const SizedBox(width: 12),
                      // Expanded(
                      //   child: StatCard(
                      //     title: 'done Sessions',
                      //     value:  12.toString(),
                      //     icon: Icons.checklist_rounded,
                      //   ),
                      // ),

                    ],
                  ),

                  const SizedBox(height: 12),

                  StatCard(
                    title: 'Productivity Score',
                    value: '${AppConstants.mockProductivityScore}%',
                    icon: Icons.trending_up,
                    subtitle: 'Great work! Keep it up.',
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Tasks",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View all'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  ...tasks.map(
                    (task) => TaskTile(task: task),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.timer),
                      label: const Text(
                        'Start Focus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning 👋';
    }

    if (hour < 17) {
      return 'Good afternoon 👋';
    }

    return 'Good evening 👋';
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '${remainingMinutes}m';
    }

    return '${hours}h ${remainingMinutes}m';
  }
}