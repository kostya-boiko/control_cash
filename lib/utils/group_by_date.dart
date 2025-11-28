
import 'package:control_cash/data/transactions.dart';
import 'package:intl/intl.dart';

Map<String, List<Transaction>> groupByDate(List<Transaction> list) {
  Map<String, List<Transaction>> map = {};
  for (var t in list) {
    String key = DateFormat('yyyy-MM-dd').format(t.date);
    map.putIfAbsent(key, () => []);
    map[key]!.add(t);
  }
  return map;
}