import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FlowChart extends StatelessWidget {
  const FlowChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(show: true),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 1.8),
                FlSpot(2, 1.2),
                FlSpot(3, 2.5),
                FlSpot(4, 2.2),
                FlSpot(5, 3),
              ],
              barWidth: 3,
              color: Colors.blue,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
