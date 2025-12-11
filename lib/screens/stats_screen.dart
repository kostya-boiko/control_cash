import 'package:control_cash/services/transactions_service.dart';
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
            const SizedBox(height: 25),

            StreamBuilder<List<TransactionModel>>(
              stream: _transactionService.listenTransactions(
                start: selectRange.start,
                end: selectRange.end,
              ),
              builder: (context, snapshot) {
                final allTransactions = snapshot.data ?? [];
                final income = _transactionService.getIncome(allTransactions);
                final expense = _transactionService.getExpense(allTransactions);


                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: "Income",
                            value: income
                                .toStringAsFixed(2),
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SummaryCard(
                            title: "Expense",
                            value: expense
                                .toStringAsFixed(2),
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SummaryCard(
                      title: "Balance",
                      value: (income + expense)
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
                        transactions: _transactionService.getExpenseTransactions(allTransactions),
                        period: selectedPeriod.toLowerCase(),
                        periodDateRange: selectRange),
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
