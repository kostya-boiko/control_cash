import 'package:control_cash/data/transactions.dart';
import 'package:control_cash/services/transactions_service.dart';

Map<DateTime, double> sumByDate(List<TransactionModel> list) {
  final Map<DateTime, double> map = {};

  for (var t in list) {
    final dateKey = DateTime(t.date.year, t.date.month, t.date.day);

    map[dateKey] = (map[dateKey] ?? 0) + t.amount.abs();
  }

  return map;
}
