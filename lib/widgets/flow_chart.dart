import 'package:control_cash/utils/getDateTimeRangeFromName.dart';
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
    List<FlSpot> spots = [];
    List<DateTime> dates = transactions.keys.toList();

    int totalSpots;
    switch (period) {
      case "today":
        totalSpots = 24;
        break;
      case "year":
        totalSpots = 12;
        break;
      default:
        totalSpots =
            periodDateRange.end.difference(periodDateRange.start).inDays + 1;
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
        if (dates.length <= 5) {
          shownIndexes = List.generate(dates.length, (i) => i);
        }
        double step = (dates.length - 1) / 4;
        shownIndexes = List.generate(5, (i) => (i * step).round());
    }

    List<double> spotsValues = List.filled(totalSpots, 0);
    for (var entry in transactions.entries) {
      int index;
      if (period == 'today') {
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
      if (period == 'today') {
        return "${periodDateRange.start.year}.${periodDateRange.start.month}.${periodDateRange.start.day}";
      } else {
        return "${periodDateRange.start.year}.${periodDateRange.start.month}.${periodDateRange.start.day} - ${periodDateRange.end.year}.${periodDateRange.end.month}.${periodDateRange.end.day}";
      }
    }

    ///макс по сумам
    double getDynamicMaxY(List<double> values) {
      if (values.isEmpty) return 100;
      final maxValue = values.reduce((a, b) => a > b ? a : b);
      double padded = maxValue + (maxValue * 0.1);
      if (padded - maxValue < 20) padded = maxValue + 20;
      return (padded / 10).ceil() * 10;
    }

    ///підказки при наведені на точку
    String getTooltipText(int index) {
      final value = spotsValues[index].toStringAsFixed(2);

      if (period == "today") {
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
      if (period == "today") {
        return "$index:00";
      }

      if (period == "week") {
        const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "The", "Fri", "Sat"];
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

      return "${index + 1}.${periodDateRange.start.month}";
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
