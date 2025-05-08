import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Error during anonymous sign-in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('Error signing out: $e');
    }
  }

  // Get user ID
  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  // Listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
