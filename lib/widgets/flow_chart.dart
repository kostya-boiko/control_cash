import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FlowChart extends StatelessWidget {
  final Map<DateTime, double> transactions;
  final String period;
  final DateTimeRange periodDateRange;

  const FlowChart({
    super.key,
    required this.transactions,
    required this.period,
    required this.periodDateRange,
  });

  @override
  Widget build(BuildContext context) {
    bool isOneDay = false;
    if (period == 'custom' &&
        periodDateRange.end.difference(periodDateRange.start).inDays == 0) {
      isOneDay = true;
    }
    int totalSpots;
    switch (period) {
      case "today":
        totalSpots = 24;
        break;
      case "year":
        totalSpots = 12;
        break;
      default:
        if (isOneDay) {
          totalSpots = 24;
          break;
        }
        totalSpots =
            periodDateRange.end.difference(periodDateRange.start).inDays + 1;
        break;
    }

    List<int> shownIndexes;
    switch (period) {
      case "today":
        shownIndexes = [0, 6, 12, 18, 23];
        break;
      case "week":
        shownIndexes = [0, 2, 4, 6];
        break;
      case "month":
        shownIndexes = [
          0,
          10,
          20,
          periodDateRange.end.difference(periodDateRange.start).inDays,
        ];
        break;
      case "year":
        shownIndexes = [0, 3, 6, 9, 11];
        break;
      default:
        if (isOneDay) {
          shownIndexes = [0, 6, 12, 18, 23];
          break;
        }
        final totalDays =
            periodDateRange.end.difference(periodDateRange.start).inDays + 1;

        if (totalDays <= 5) {
          shownIndexes = List.generate(totalDays, (i) => i);
        } else {
          final step = (totalDays - 1) / 4;
          shownIndexes = List.generate(5, (i) => (i * step).round());
        }
    }

    List<double> spotsValues = List.filled(totalSpots, 0);
    for (var entry in transactions.entries) {
      int index;
      if (period == 'today' || isOneDay) {
        index = entry.key.hour;
      } else if (period == 'year') {
        index = entry.key.month - 1;
      } else {
        index = entry.key.difference(periodDateRange.start).inDays;
      }
      spotsValues[index] += entry.value.abs();
    }

    /// дата зверху справа
    String getShownDate() {
      if (period == 'today' || isOneDay) {
        return "${periodDateRange.start.year}.${periodDateRange.start.month}.${periodDateRange.start.day}";
      } else {
        return "${periodDateRange.start.year}.${periodDateRange.start.month}.${periodDateRange.start.day} - ${periodDateRange.end.year}.${periodDateRange.end.month}.${periodDateRange.end.day}";
      }
    }

    ///макс по сумам

    double getDynamicMaxY(List<double> values) {
      if (values.isEmpty) return 100;

      double maxValue = values.reduce((a, b) => a > b ? a : b);

      if (maxValue == 0) return 10;

      // визначаємо порядок числа
      final magnitude = pow(10, maxValue.toStringAsFixed(0).length - 1);

      // можливі множники: 1, 2, 5
      final steps = [1, 2, 5]
          .map((m) => m * magnitude)
          .toList();

      // вибираємо найближчий крок
      double chosenStep = steps.firstWhere(
            (s) => maxValue / s <= 5,
        orElse: () => 10 * magnitude,
      ).toDouble();

      // округлюємо maxValue до обраного кроку
      return (maxValue / chosenStep).ceil() * chosenStep;
    }


    ///підказки при наведені на точку
    String getTooltipText(int index) {
      final value = spotsValues[index].toStringAsFixed(2);

      if (period == "today" || isOneDay) {
        return "${index.toString().padLeft(2, '0')}:00\n₴$value";
      }

      if (period == "year") {
        const m = [
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        ];
        return "${m[index]}\n₴$value";
      }

      final date = periodDateRange.start.add(Duration(days: index));
      return "${date.day}.${date.month}.${date.year}\n₴$value";
    }

    String getBottomLabel(int index) {
      if (period == "today" || isOneDay) {
        return "$index:00";
      }

      if (period == "week") {
        const daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        return daysOfWeek[index];
      }

      if (period == "year") {
        const months = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec",
        ];
        return months[index];
      }

      if (period == "month") {
        return "${index + 1}.${periodDateRange.start.month}";
      }

      final totalDays =
          periodDateRange.end.difference(periodDateRange.start).inDays + 1;

      if (totalDays <= 5) {
        final d = periodDateRange.start.add(Duration(days: index));
        return "${d.day}.${d.month}";
      }

      final step = (totalDays - 1) / 4;

      final targetDay = periodDateRange.start.add(Duration(days: (index)));

      return "${targetDay.day}.${targetDay.month}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                getShownDate(),
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
                      return LineTooltipItem(
                        getTooltipText(index),
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
                      if (!shownIndexes.contains(index)) {
                        return const SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            getBottomLabel(index),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              minY: 0,
              maxY: getDynamicMaxY(transactions.values.toList()),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    totalSpots,
                    (i) => FlSpot(i.toDouble(), spotsValues[i]),
                  ),
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
