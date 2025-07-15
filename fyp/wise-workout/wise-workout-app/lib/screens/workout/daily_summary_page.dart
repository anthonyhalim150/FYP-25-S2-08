import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wise_workout_app/widgets/exercise_stats_card.dart';

class DailySummaryPage extends StatelessWidget {
  const DailySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F0EB),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Daily Activity", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: const [Icon(Icons.calendar_today, color: Colors.black)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "${currentDate.day} ${_monthName(currentDate.month)} ${currentDate.year}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              /// Exercise Stats
              const ExerciseStatsCard(
                currentSteps: 4300,
                maxSteps: 10000,
                caloriesBurned: 234,
                xpEarned: 98,
              ),

              const SizedBox(height: 20),

              /// Steps Chart
              const _TimeBasedChart(
                icon: Icons.directions_walk,
                title: "Steps",
                currentValue: "4,300",
                avgValue: "9,121",
                barColor: Colors.blue,
                maxY: 10000,
                data: [
                  0, 0, 0, 0, 0, 1000, 2300, 0, 0, 0, 500, 0, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200
                ],
              ),

              const SizedBox(height: 20),

              /// Calories Chart
              const _TimeBasedChart(
                icon: Icons.local_fire_department,
                title: "Calories",
                currentValue: "321",
                avgValue: "234",
                barColor: Colors.red,
                maxY: 300,
                data: [
                  0, 0, 0, 0, 0, 50, 120, 0, 0, 0, 30, 0, 0, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}

class _TimeBasedChart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String currentValue;
  final String avgValue;
  final Color barColor;
  final double maxY;
  final List<int> data;

  const _TimeBasedChart({
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.avgValue,
    required this.barColor,
    required this.maxY,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  Text("Current", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Column(
                children: [
                  Text(avgValue, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Daily avg last week", style: TextStyle(color: Colors.grey[600])),
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
                        if (value.toInt() % 6 == 0) {
                          return Text("${value.toInt()}h", style: const TextStyle(fontSize: 10));
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 3,
                      getTitlesWidget: (value, _) => Text("${value.toInt()}", style: const TextStyle(fontSize: 10)),
                      reservedSize: 30,
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
                      )
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
