import 'package:control_cash/data/transactions.dart';

Map<DateTime, double> sumByDate(List<Transaction> list) {
  final Map<DateTime, double> map = {};

  for (var t in list) {
    final dateKey = DateTime(t.date.year, t.date.month, t.date.day);

    map[dateKey] = (map[dateKey] ?? 0) + t.amount.abs();
  }

  return map;
}
