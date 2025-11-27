import 'package:control_cash/data/transactions.dart';
import 'package:control_cash/utils/sum_by_date.dart';
import 'package:control_cash/utils/sum_by_hour.dart';
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
    return transactions.fold(
        0.0, (sum, t) => t.amount > 0 ? sum + t.amount : sum);
  }

  double getExpense(List<Transaction> transactions) {
    return transactions.fold(
        0.0, (sum, t) => t.amount < 0 ? sum + t.amount : sum);
  }

  (Map<DateTime, double>, bool) getTransactionsForChart(
      List<Transaction> transactions) {
    if (selectedPeriod == 'Today') {
      return (sumByHour(transactions), true);
    } else {
      final byDate = sumByDate(transactions);
      if (byDate.length == 1) {
        return (sumByHour(transactions), true);
      } else {
        return (byDate, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartData = getTransactionsForChart(allTransactions);
    final transactionsForChart = chartData.$1;
    final isDayMode = chartData.$2;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select period",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            PeriodSelector(
              selected: selectedPeriod,
              onSelect: (p) => setState(() => selectedPeriod = p),
            ),
            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "Income",
                    value: getIncome(allTransactions).toStringAsFixed(2),
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: "Expense",
                    value: getExpense(allTransactions).toStringAsFixed(2),
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SummaryCard(
              title: "Balance",
              value: (getIncome(allTransactions) + getExpense(allTransactions))
                  .toStringAsFixed(2),
              color: theme.colorScheme.primary,
              fullWidth: true,
            ),
            const SizedBox(height: 30),

            Text(
              "Expense Chart",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 15),
            FlowChart(
              transactions: transactionsForChart,
              dayMode: isDayMode,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
