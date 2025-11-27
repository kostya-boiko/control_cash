import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in
  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Sign up
  Future<UserCredential> signUp(String email, String password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> removeUser() {
    return _auth.currentUser!.delete();
  }

  Future<void> reAuth(String email, String password) {
    final user = _auth.currentUser;
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    return user!.reauthenticateWithCredential(credential);
  }

  // Reset password
  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  // Current user
  User? get currentUser => _auth.currentUser;
}
