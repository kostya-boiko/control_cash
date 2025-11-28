import 'package:cloud_firestore/cloud_firestore.dart';

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
  final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection("transactions");

  Future<void> addTransaction(TransactionModel transaction) async {
    final docRef = _collection.doc();
    await docRef.set(transaction.toMap(docRef.id));
  }

  Future<void> updateTransaction(TransactionModel t) async {
    await _collection.doc(t.id).update(t.toMap(null));
  }

  Future<void> deleteTransaction(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<TransactionModel>> listenTransactions({
    DateTime? start,
    DateTime? end,
    String orderBy = "date",
    bool descending = true,
  }) {
    Query<Map<String, dynamic>> query = _collection;

    if (start != null && end != null) {
      final startDay = DateTime(start.year, start.month, start.day, 0, 0, 0);
      final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);

      query = query
          .where("date", isGreaterThanOrEqualTo: startDay)
          .where("date", isLessThanOrEqualTo: endDay);
    }

    query = query.orderBy(orderBy, descending: descending);

    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => TransactionModel.fromDoc(doc.data())).toList());
  }
}
