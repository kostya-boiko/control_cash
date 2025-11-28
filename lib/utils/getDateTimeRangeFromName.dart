import 'package:flutter/material.dart';

Future<DateTimeRange?> getDateTimeRangeFromName(BuildContext context, String period) async {
  final now = DateTime.now();

  switch (period.toLowerCase()) {
    case "today":
      return DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 0, 0, 0),
        end: DateTime(now.year, now.month, now.day, 23, 59, 59),
      );

    case "week":
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return DateTimeRange(
        start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0),
        end: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
      );

    case "month":
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      return DateTimeRange(start: startOfMonth, end: endOfMonth);

    case "year":
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);
      return DateTimeRange(start: startOfYear, end: endOfYear);

    case "custom":
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        return picked;
      }
      return null;

    default:
      return DateTimeRange(start: now, end: now);
  }
}
