import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> allTransactions = [];
  DateTimeRange? selectedRange;

  final int pageSize = 20;
  int currentLoaded = 20;

  String sortMode = "date_desc";

  @override
  void initState() {
    super.initState();

    allTransactions = List.generate(200, (i) {
      return Transaction(
        title: "Transaction $i",
        amount: (i % 2 == 0 ? 100 : 50),
        date: DateTime.now().subtract(Duration(days: i)),
        isIncome: i % 2 == 0,
      );
    });
  }

  // ░░░░░░░░░░░░░░░░░░░░░  FILTER + SORT + PAGINATION  ░░░░░░░░░░░░░░░░░░░░░
  List<Transaction> get filteredTransactions {
    List<Transaction> base = selectedRange == null
        ? allTransactions
        : allTransactions.where((t) {
      return t.date.isAfter(
          selectedRange!.start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(
              selectedRange!.end.add(const Duration(days: 1)));
    }).toList();

    // SORT
    base.sort((a, b) {
      switch (sortMode) {
        case "amount_asc":
          return a.amount.compareTo(b.amount);
        case "amount_desc":
          return b.amount.compareTo(a.amount);
        case "date_asc":
          return a.date.compareTo(b.date);
        case "date_desc":
        default:
          return b.date.compareTo(a.date);
      }
    });

    return base.take(currentLoaded).toList();
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

  Future<void> loadMore() async {
    setState(() {
      currentLoaded += pageSize;
    });
  }

  // ░░░░░░░░░░░░░░░░░░░░░  PERIOD PICKING  ░░░░░░░░░░░░░░░░░░░░░
  Future<void> pickCustomRange() async {
    final now = DateTime.now();

    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );

    if (result != null) {
      setState(() {
        selectedRange = result;
        currentLoaded = pageSize;
      });
    }
  }

  void selectPeriod(String period) {
    final now = DateTime.now();

    switch (period) {
      case "all":
        setState(() {
          selectedRange = null;
          currentLoaded = pageSize;
        });
        break;

      case "today":
        setState(() {
          selectedRange = DateTimeRange(
            start: DateTime(now.year, now.month, now.day),
            end: DateTime(now.year, now.month, now.day),
          );
          currentLoaded = pageSize;
        });
        break;

      case "week":
        setState(() {
          selectedRange = DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          );
          currentLoaded = pageSize;
        });
        break;

      case "month":
        setState(() {
          selectedRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          );
          currentLoaded = pageSize;
        });
        break;

      case "custom":
        pickCustomRange();
        break;
    }
  }

  String getPeriodLabel() {
    if (selectedRange == null) return "All time";

    final formatter = DateFormat('dd.MM.yyyy');
    return "${formatter.format(selectedRange!.start)} — ${formatter.format(selectedRange!.end)}";
  }

  // ░░░░░░░░░░░░░░░░░░░░░  BUILD  ░░░░░░░░░░░░░░░░░░░░░

  @override
  Widget build(BuildContext context) {
    final grouped = groupByDate(filteredTransactions);

    return Scaffold(
      body: Column(
        children: [
          // ░░░░░░░░░░░░ PERIOD BLOCK  ░░░░░░░░░░░░
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getPeriodLabel(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Calendar dropdown button
                PopupMenuButton<String>(
                  icon: Icon(Icons.calendar_month),
                  onSelected: selectPeriod,
                  itemBuilder: (_) => [
                    PopupMenuItem(value: "all", child: Text("All time")),
                    PopupMenuItem(value: "today", child: Text("Today")),
                    PopupMenuItem(value: "week", child: Text("Last 7 days")),
                    PopupMenuItem(value: "month", child: Text("This month")),
                    PopupMenuItem(value: "custom", child: Text("Custom range")),
                  ],
                ),

                // Sort button
                PopupMenuButton<String>(
                  icon: Icon(Icons.sort),
                  onSelected: (value) {
                    setState(() => sortMode = value);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: "date_desc", child: Text("Newest first")),
                    PopupMenuItem(value: "date_asc", child: Text("Oldest first")),
                    PopupMenuItem(value: "amount_desc", child: Text("Amount ↓")),
                    PopupMenuItem(value: "amount_asc", child: Text("Amount ↑")),
                  ],
                ),
              ],
            ),
          ),

          // ░░░░░░░░░░░░ LIST  ░░░░░░░░░░░░
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 200) {
                  loadMore();
                }
                return false;
              },
              child: ListView(
                children: grouped.entries.map((group) {
                  DateTime d = DateTime.parse(group.key);
                  String title;

                  DateTime now = DateTime.now();
                  DateTime yesterday = now.subtract(Duration(days: 1));

                  if (DateFormat('yyyy-MM-dd').format(d) ==
                      DateFormat('yyyy-MM-dd').format(now)) {
                    title = "Today";
                  } else if (DateFormat('yyyy-MM-dd').format(d) ==
                      DateFormat('yyyy-MM-dd').format(yesterday)) {
                    title = "Yesterday";
                  } else {
                    title = DateFormat('dd MMM yyyy').format(d);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),

                      ...group.value.map((t) {
                        return ListTile(
                          leading: Icon(
                            t.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                            color: t.isIncome ? Colors.green : Colors.red,
                          ),
                          title: Text(t.title),
                          subtitle: Text(DateFormat('HH:mm').format(t.date)),
                          trailing: Text(
                            "${t.isIncome ? "+" : "-"}${t.amount} \$",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: t.isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
