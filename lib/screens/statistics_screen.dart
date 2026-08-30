import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/productivity_provider.dart';
import '../widgets/productivity_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductivityProvider>();

    final dailyMinutes = List.generate(
      7,
      (index) {
        final day = DateTime.now().subtract(
          Duration(days: 6 - index),
        );

        return provider.getCodingMinutesForDay(day).toDouble();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your productivity',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 6),

            Text(
              'Last 7 days',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ProductivityChart(
                  dailyMinutes: dailyMinutes,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    title: 'Total Time',
                    value: _formatMinutes(
                      provider.totalCodingMinutes,
                    ),
                    icon: Icons.timer_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatisticCard(
                    title: 'Sessions',
                    value: '${provider.completedSessionCount}',
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    title: 'Daily Average',
                    value: _formatMinutes(
                      provider.averageDailyCodingMinutes.round(),
                    ),
                    icon: Icons.analytics_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatisticCard(
                    title: 'Streak',
                    value: '${provider.currentStreak} days',
                    icon: Icons.local_fire_department,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              'Daily Breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            ...List.generate(
              7,
              (index) {
                final day = DateTime.now().subtract(
                  Duration(days: 6 - index),
                );

                final minutes =
                    provider.getCodingMinutesForDay(day);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text(
                      DateFormat('E')
                          .format(day)
                          .substring(0, 1),
                    ),
                  ),
                  title: Text(
                    DateFormat('EEEE').format(day),
                  ),
                  subtitle: Text(
                    DateFormat('d MMM').format(day),
                  ),
                  trailing: Text(
                    _formatMinutes(minutes),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '${remainingMinutes}m';
    }

    return '${hours}h ${remainingMinutes}m';
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}