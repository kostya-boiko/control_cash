import 'package:control_cash/services/transactions_service.dart';
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
  String selectedPeriod = "Today";
  DateTimeRange selectRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  final TransactionService _transactionService = TransactionService();

  double getIncome(List<TransactionModel> transactions) {
    return transactions.fold(
      0.0,
          (sum, t) => t.amount > 0 ? sum + t.amount : sum,
    );
  }

  double getExpense(List<TransactionModel> transactions) {
    return transactions.fold(
      0.0,
          (sum, t) => t.amount < 0 ? sum + t.amount : sum,
    );
  }

  (Map<DateTime, double>, bool) getTransactionsForChart(
      List<TransactionModel> transactions) {
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

  void _onPeriodChange(String period, DateTimeRange range) {
    setState(() {
      selectedPeriod = period;
      selectRange = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              selectedPeriod: selectedPeriod,
              selectedRange: selectRange,
              onSelect: _onPeriodChange,
            ),
            const SizedBox(height: 10),
            Text(
              "${selectRange.start.day}.${selectRange.start.month}.${selectRange.start.year} - "
                  "${selectRange.end.day}.${selectRange.end.month}.${selectRange.end.year}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 25),

            StreamBuilder<List<TransactionModel>>(
              stream: _transactionService.listenTransactions(
                start: selectRange.start,
                end: selectRange.end,
              ),
              builder: (context, snapshot) {
                final allTransactions = snapshot.data ?? [];

                final chartData = getTransactionsForChart(allTransactions);
                final transactionsForChart = chartData.$1;
                final isDayMode = chartData.$2;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: "Income",
                            value: getIncome(allTransactions)
                                .toStringAsFixed(2),
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SummaryCard(
                            title: "Expense",
                            value: getExpense(allTransactions)
                                .toStringAsFixed(2),
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SummaryCard(
                      title: "Balance",
                      value: (getIncome(allTransactions) +
                          getExpense(allTransactions))
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
                        transactions: transactionsForChart, period: selectedPeriod.toLowerCase(), periodDateRange: selectRange),
                    const SizedBox(height: 60),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
