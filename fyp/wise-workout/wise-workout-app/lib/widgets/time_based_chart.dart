import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TimeBasedChart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String currentValue;
  final String avgValue;
  final Color barColor;
  final double maxY;
  final List<int> data;
  final double? maxYOverride;

  const TimeBasedChart({
    super.key,
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.avgValue,
    required this.barColor,
    required this.maxY,
    required this.data,
    this.maxYOverride,
  });

  double _calculateAdaptiveMaxY(List<int> data, {double minY = 10000, double headroom = 1.1, double step = 2000, double maxCap = 50000}) {
    if (data.isEmpty) return minY;
    final highest = data.reduce((a, b) => a > b ? a : b);
    if (highest < minY) return minY;
    // Add headroom and round up to step
    final roundedUp = (((highest * headroom) / step).ceil()) * step;
    return roundedUp > maxCap ? maxCap : roundedUp;
  }

  String _formatYAxis(double value) {
    if (value >= 10000) {
      return '${(value ~/ 1000)}k';
    }
    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = maxYOverride ?? _calculateAdaptiveMaxY(data);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: barColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: barColor),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(currentValue, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Current", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                ],
              ),
              Column(
                children: [
                  Text(avgValue, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Daily avg", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        // Show label every 2nd bar: "0", "2", "4", ..., or adjust as needed
                        if (value.toInt() % 2 == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text("${value.toInt()}", style: const TextStyle(fontSize: 10)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 20,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 3,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(_formatYAxis(value), style: const TextStyle(fontSize: 10)),
                      ),
                      reservedSize: 34,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].toDouble(),
                        color: barColor,
                        width: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
                maxY: maxY,
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
