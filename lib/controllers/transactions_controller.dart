import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/transactions.dart';

class TransactionsController {
  List<Transaction> allTransactions = transactions;
  DateTimeRange? dateRange;

  int pageSize = 20;
  int loaded = 20;
  String sortMode = "date_desc";

  // FILTER + SORT + PAGINATION
  List<Transaction> get filteredTransactions {
    List<Transaction> list = dateRange == null
        ? allTransactions
        : allTransactions.where((t) =>
    t.date.isAfter(dateRange!.start) &&
        t.date.isBefore(dateRange!.end.add(Duration(days: 1)))
    ).toList();

    list.sort((a, b) {
      switch (sortMode) {
        case "amount_asc":
          return a.amount.compareTo(b.amount);
        case "amount_desc":
          return b.amount.compareTo(a.amount);
        case "date_asc":
          return a.date.compareTo(b.date);
        default:
          return b.date.compareTo(a.date);
      }
    });

    return list.take(loaded).toList();
  }

  // GROUP BY DATE
  Map<String, List<Transaction>> groupByDate(List<Transaction> list) {
    Map<String, List<Transaction>> map = {};
    for (var t in list) {
      String key = DateFormat('yyyy-MM-dd').format(t.date);
      map.putIfAbsent(key, () => []);
      map[key]!.add(t);
    }
    return map;
  }

  // LOAD MORE
  void loadMore() => loaded += pageSize;

  // PERIODS
  Future<void> selectPeriod(String value, BuildContext context) async {
    final now = DateTime.now();
    switch (value) {
      case "all":
        dateRange = null;
        break;

      case "today":
        dateRange = DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: DateTime(now.year, now.month, now.day),
        );
        break;

      case "week":
        dateRange = DateTimeRange(
          start: now.subtract(Duration(days: 7)),
          end: now,
        );
        print(dateRange);
        break;

      case "month":
        dateRange = DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
        break;

      case "custom":
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) dateRange = picked;
        break;
    }

    loaded = pageSize;
  }

  // LABEL
  String get periodLabel {
    if (dateRange == null) return "All time";
    final f = DateFormat("dd.MM.yyyy");
    return "${f.format(dateRange!.start)} — ${f.format(dateRange!.end)}";
  }
}
