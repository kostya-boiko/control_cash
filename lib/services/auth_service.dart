import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });


    final docRef = _firestore.collection('users').doc(uid)
        .collection('transactions').doc();
    final firstTransaction = {
      'id': docRef.id,
      'title': 'Hello, World!',
      'amount': 100.0,
      'comment': 'This is your first example transaction!',
      'date': FieldValue.serverTimestamp(),
    };
    await docRef.set(firstTransaction);

    return credential;
  }


  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> removeUser() async {
    final user = _auth.currentUser;
    if (user != null) {

      final transactions = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .get();

      for (var doc in transactions.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('users').doc(user.uid).delete();

      await user.delete();
    }
  }

  Future<void> reAuth(String email, String password) {
    final user = _auth.currentUser;
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    return user!.reauthenticateWithCredential(credential);
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  User? get currentUser => _auth.currentUser;
}
