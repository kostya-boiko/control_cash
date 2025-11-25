import 'package:flutter/material.dart';
import '../../../data/transactions.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.amount > 0
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: transaction.amount > 0 ? Colors.green : Colors.red,
      ),
      title: Text(transaction.title),
      subtitle: Text(DateFormat('HH:mm').format(transaction.date)),
      trailing: Text(
        "${transaction.amount > 0 ? "+" : "-"}${transaction.amount} \$",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: transaction.amount > 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
