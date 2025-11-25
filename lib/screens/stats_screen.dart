import 'package:control_cash/data/transactions.dart';
import 'package:control_cash/widgets/flow_chart.dart';
import 'package:control_cash/widgets/period_selector.dart';
import 'package:control_cash/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String selectedPeriod = "Month";
  List<Transaction> allTransactions = transactions;

  double getIncome(List<Transaction> transactions) {
    double income = 0;
    for (var t in transactions) {
      if (t.amount > 0) income += t.amount;
    }
    return income;
  }

  double getExpense(List<Transaction> transactions) {
    double expense = 0;
    for (var t in transactions) {
        if (t.amount < 0) expense += t.amount;
      }
    return expense;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PERIOD SELECTOR
            const Text(
              "Select period",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            PeriodSelector(
              selected: selectedPeriod,
              onSelect: (p) => setState(() => selectedPeriod = p),
            ),

            const SizedBox(height: 25),

            // SUMMARY CARDS
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "Income",
                    value: getIncome(transactions).toString(),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: "Expense",
                    value: getExpense(transactions).toString(),
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SummaryCard(
              title: "Balance",
              value: (getIncome(transactions) + getExpense(transactions))
                  .toString(),
              color: Colors.blue,
              fullWidth: true,
            ),

            const SizedBox(height: 30),

            const Text(
              "Flow Chart",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),

            const FlowChart(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
