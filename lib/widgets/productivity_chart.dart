import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductivityChart extends StatelessWidget {
  final List<double> dailyMinutes;

  const ProductivityChart({
    super.key,
    required this.dailyMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = dailyMinutes.isEmpty
        ? 60.0
        : dailyMinutes.reduce(
              (a, b) => a > b ? a : b,
            );

    final chartMaxY = maxValue < 60 ? 60.0 : maxValue + 30;

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: chartMaxY,
          gridData: const FlGridData(
            show: true,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}m',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const labels = [
                    'M',
                    'T',
                    'W',
                    'T',
                    'F',
                    'S',
                    'S',
                  ];

                  final index = value.toInt();

                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    labels[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                dailyMinutes.length,
                (index) => FlSpot(
                  index.toDouble(),
                  dailyMinutes[index],
                ),
              ),
              isCurved: true,
              barWidth: 3,
              dotData: const FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(
                show: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}