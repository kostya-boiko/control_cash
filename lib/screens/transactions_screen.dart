import 'package:control_cash/services/transactions_service.dart';

import 'package:control_cash/widgets/period_selector_button.dart';
import 'package:control_cash/widgets/sort_button.dart';
import 'package:control_cash/widgets/transaction_group.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionService _service = TransactionService();

  DateTime? _startDate;
  DateTime? _endDate;
  String _sortMode = "date_desc";

  Map<String, List<TransactionModel>> _groupByDate(List<TransactionModel> list) {
    Map<String, List<TransactionModel>> map = {};
    for (var t in list) {
      String key = DateFormat('yyyy-MM-dd').format(t.date);
      map.putIfAbsent(key, () => []);
      map[key]!.add(t);
    }
    return map;
  }

  Future<void> _selectPeriod(String value) async {
    final now = DateTime.now();
    switch (value) {
      case "all":
        _startDate = null;
        _endDate = null;
        break;
      case "today":
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day);
        break;
      case "week":
        _startDate = now.subtract(const Duration(days: 7));
        _endDate = now;
        break;
      case "month":
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
        break;
      case "custom":
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          _startDate = picked.start;
          _endDate = picked.end;
        }
        break;
    }
    setState(() {});
  }

  String get _periodLabel {
    if (_startDate == null || _endDate == null) return "All time";
    final f = DateFormat("dd.MM.yyyy");
    return "${f.format(_startDate!)} — ${f.format(_endDate!)}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _periodLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              PeriodSelectorButton(
                onSelect: (period) async => _selectPeriod(period),
              ),
              SortButton(
                onChanged: (mode) => setState(() => _sortMode = mode),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<TransactionModel>>(
            stream: _service.listenTransactions(
              start: _startDate,
              end: _endDate,
              orderBy: _sortMode.contains("amount") ? "amount" : "date",
              descending: _sortMode.endsWith("desc"),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              final transactions = snapshot.data ?? [];
              final grouped = _groupByDate(transactions);

              if (transactions.isEmpty) {
                return const Center(child: Text("No transactions found"));
              }

              return ListView(
                children: grouped.entries.map((group) {
                  return TransactionGroup(
                    date: DateTime.parse(group.key),
                    transactions: group.value,
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
