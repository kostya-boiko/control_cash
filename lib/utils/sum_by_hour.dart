import 'package:control_cash/data/transactions.dart';
import 'package:control_cash/services/transactions_service.dart';

Map<DateTime, double> sumByHour(List<TransactionModel> list) {
  final Map<DateTime, double> map = {};

  for (var t in list) {
    final hourKey = DateTime(
      t.date.year,
      t.date.month,
      t.date.day,
      t.date.hour,
    );

    map[hourKey] = (map[hourKey] ?? 0) + t.amount.abs();
  }

  return map;
}
