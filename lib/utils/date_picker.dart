import 'package:flutter/material.dart';

Future<void> pickCustomRange(context, void Function(DateTimeRange?) onRangeSelected) async {
  final now = DateTime.now();

  DateTimeRange? result = await showDateRangePicker(
    context: context,
    firstDate: DateTime(now.year - 3),
    lastDate: DateTime(now.year + 1),
  );

  if (result != null) {
    onRangeSelected(result);
  }
}
