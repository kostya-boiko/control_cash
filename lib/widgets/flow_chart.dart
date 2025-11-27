import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FlowChart extends StatelessWidget {
  final Map<DateTime, double> transactions;
  final bool dayMode;
  final DateTime? displayDate;

  const FlowChart({
    super.key,
    required this.transactions,
    this.dayMode = false,
    this.displayDate,
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    List<DateTime> dates = transactions.keys.toList()..sort();

    double getDynamicMaxY(List<double> values) {
      if (values.isEmpty) return 100;
      final maxValue = values.reduce((a, b) => a > b ? a : b);
      double padded = maxValue + (maxValue * 0.1);
      if (padded - maxValue < 20) padded = maxValue + 20;
      return (padded / 10).ceil() * 10;
    }

    DateTime shownDate =
        displayDate ??
        (dayMode && dates.isNotEmpty ? dates.first : DateTime.now());

    if (dayMode) {
      List<double> hourly = List.filled(24, 0);
      for (var entry in transactions.entries) {
        final hour = entry.key.hour;
        hourly[hour] += entry.value.abs();
      }
      spots = List.generate(24, (i) => FlSpot(i.toDouble(), hourly[i]));
    } else {
      for (int i = 0; i < transactions.length; i++) {
        spots.add(FlSpot(i.toDouble(), transactions[dates[i]]!.abs()));
      }
    }

    final dayIndexes = [0, 6, 12, 18, 23];

    List<int> getLabelIndexes(int length) {
      if (length <= 5) return List.generate(length, (i) => i);
      double step = (length - 1) / 4;
      return List.generate(5, (i) => (i * step).round());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dayMode)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Date: ${shownDate.day}.${shownDate.month}.${shownDate.year}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final index = spot.x.toInt();
                      if (dayMode) {
                        return LineTooltipItem(
                          "${index.toString().padLeft(2, '0')}:00\n₴${spots[index].y.toStringAsFixed(2)}",
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      final t = dates[index];
                      return LineTooltipItem(
                        "${t.day}.${t.month}.${t.year}\n₴${transactions[t]!.abs().toStringAsFixed(2)}",
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: false,
                drawVerticalLine: true,
              ),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (dayMode) {
                        if (!dayIndexes.contains(index))
                          return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "$index:00",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      if (getLabelIndexes(spots.length).contains(index)) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "${dates[index].day}.${dates[index].month}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: dayMode ? 23 : (transactions.length - 1).toDouble(),
              minY: 0,
              maxY: getDynamicMaxY(transactions.values.toList()),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: Colors.redAccent,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.redAccent.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
