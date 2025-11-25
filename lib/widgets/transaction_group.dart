import 'package:control_cash/widgets/transaction_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/transactions.dart';

class TransactionGroup extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;

  const TransactionGroup({super.key, required this.date, required this.transactions});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    String title;
    final f = DateFormat('yyyy-MM-dd');

    if (f.format(date) == f.format(now)) {
      title = "Today";
    } else if (f.format(date) == f.format(yesterday)) {
      title = "Yesterday";
    } else {
      title = DateFormat('dd MMM yyyy').format(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        ...transactions.map((t) => TransactionTile(t)),
      ],
    );
  }
}
