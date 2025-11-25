import 'package:control_cash/controllers/transactions_controller.dart';
import 'package:control_cash/widgets/period_selector_button.dart';
import 'package:control_cash/widgets/sort_button.dart';
import 'package:control_cash/widgets/transaction_group.dart';
import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final controller = TransactionsController();

  @override
  Widget build(BuildContext context) {
    final grouped = controller.groupByDate(controller.filteredTransactions);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  controller.periodLabel,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              PeriodSelectorButton(
                onSelect: (period) async {
                  await controller.selectPeriod(period, context);
                  setState(() {});
                },
              ),

              SortButton(
                onChanged: (mode) {
                  setState(() => controller.sortMode = mode);
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 200) {
                setState(() => controller.loadMore());
              }
              return false;
            },
            child: ListView(
              children: grouped.entries.map((group) {
                return TransactionGroup(
                  date: DateTime.parse(group.key),
                  transactions: group.value,
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
