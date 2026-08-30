import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/productivity_provider.dart';
import '../utils/constants.dart';
import '../widgets/coding_streak.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductivityProvider>();

    if (provider.isLoading) {
    return const Center(
    child: CircularProgressIndicator(),
  );
}
    final tasks = provider.tasks;

    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());

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
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  const SizedBox(height: 12),
                  CodingStreak(
                    streak: provider.currentStreak,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Today's Coding",
                          value: _formatMinutes(
                            provider.todayCodingMinutes,
                          ),
                          icon: Icons.code,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Weekly',
                          value: _formatMinutes(
                            provider.weeklyCodingMinutes,
                          ),
                          icon: Icons.calendar_month,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const StatCard(
                    title: 'Productivity Score',
                    value: '87%',
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
                        onPressed: () {
                          // Navigation will be improved later.
                        },
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (tasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('No tasks for today.'),
                    )
                  else
                    ...tasks.take(3).map(
                          (task) => TaskTile(task: task),
                        ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        // Focus functionality comes in Phase 4.
                      },
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