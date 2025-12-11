import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_cash/services/auth_service.dart';

final authService = AuthService();

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String comment;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.comment,
    required this.date,
  });

  factory TransactionModel.fromDoc(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap(String? newId) {
    return {
      "id": newId ?? id,
      "title": title,
      "amount": amount,
      "comment": comment,
      "date": Timestamp.fromDate(date),
    };
  }
}

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userTransactions() {
    return _firestore
        .collection("users")
        .doc(authService.currentUser?.uid)
        .collection("transactions");
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final docRef = _userTransactions().doc();
    await docRef.set(transaction.toMap(docRef.id));
  }

  Future<void> updateTransaction(TransactionModel t) async {
    await _userTransactions().doc(t.id).update(t.toMap(null));
  }

  Future<void> deleteTransaction(String id) async {
    await _userTransactions().doc(id).delete();
  }

  Stream<List<TransactionModel>> listenTransactions({
    DateTime? start,
    DateTime? end,
    String orderBy = "date",
    bool descending = true,
  }) {
    Query<Map<String, dynamic>> query = _userTransactions();

    if (start != null && end != null) {
      final startDay = DateTime(start.year, start.month, start.day, 0, 0, 0);
      final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);

      query = query
          .where("date", isGreaterThanOrEqualTo: startDay)
          .where("date", isLessThanOrEqualTo: endDay);
    }

    query = query.orderBy(orderBy, descending: descending);

    return query.snapshots().map(
      (snap) =>
          snap.docs.map((doc) => TransactionModel.fromDoc(doc.data())).toList(),
    );
  }

  double getIncome(transactions) {
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

  List<TransactionModel> getExpenseTransactions(List<TransactionModel> transactions) {
    return transactions.where((t) => t.amount <= 0).toList();
  }
}
