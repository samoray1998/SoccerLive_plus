import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  
  bool _isAuthenticated = false;
  bool _isAuthenticating = true;
  String? _userId;
  String? _errorMessage;

  AuthProvider(this._authService, this._firestoreService);

  bool get isAuthenticated => _isAuthenticated;
  bool get isAuthenticating => _isAuthenticating;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;

  Future<void> initializeAuth() async {
    try {
      _isAuthenticating = true;
      notifyListeners();
      
      // Check if user is already signed in
      final currentUser = _authService.getCurrentUser();
      
      if (currentUser != null) {
        _isAuthenticated = true;
        _userId = currentUser.uid;
      } else {
        // If not, perform anonymous sign in
        await signInAnonymously();
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      _isAuthenticating = true;
      _errorMessage = null;
      notifyListeners();
      
      final user = await _authService.signInAnonymously();
      
      if (user != null) {
        _isAuthenticated = true;
        _userId = user.uid;
        
        // Create user document in Firestore if it doesn't exist
        await _firestoreService.createUserIfNotExists(user.uid);
        
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Anonymous sign in failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error during anonymous sign in: ${e.toString()}';
      print(_errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _isAuthenticated = false;
      _userId = null;
    } catch (e) {
      _errorMessage = 'Error signing out: ${e.toString()}';
      print(_errorMessage);
    } finally {
      notifyListeners();
    }
  }

  // Method to clear error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
