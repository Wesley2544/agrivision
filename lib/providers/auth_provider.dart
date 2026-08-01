import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status    = AuthStatus.unknown;
  User?      _user;
  String?    _error;
  bool       _isLoading = false;

  AuthStatus get status    => _status;
  User?      get user      => _user;
  String?    get error     => _error;
  bool       get isLoading => _isLoading;
  bool       get isLoggedIn =>
      _status == AuthStatus.authenticated;

  String get displayName =>
      _user?.displayName ??
      _user?.email?.split('@').first ??
      'Farmer';

  String get email => _user?.email ?? '';

  AuthProvider() {
    // Listen to Firebase auth state
    // This fires immediately with the cached user on launch
    // — handles auto-login (requirement 11 + 12)
    AuthService.instance.authStateChanges
        .listen(_onAuthChanged);
  }

  void _onAuthChanged(User? user) {
    _user   = user;
    _status = user != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    _error     = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Sign In ───────────────────────────────────────────
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final result = await AuthService.instance.signIn(
        email: email, password: password);
    _isLoading = false;
    if (!result.success) _error = result.error;
    notifyListeners();
    return result.success;
  }

  // ── Sign Up ───────────────────────────────────────────
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    final result = await AuthService.instance.signUp(
        email: email, password: password, fullName: fullName);
    _isLoading = false;
    if (!result.success) _error = result.error;
    notifyListeners();
    return result.success;
  }

  // ── Google Sign-In ────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    final result = await AuthService.instance.signInWithGoogle();
    _isLoading = false;
    if (!result.success) _error = result.error;
    notifyListeners();
    return result.success;
  }

  // ── Sign Out ──────────────────────────────────────────
  Future<void> signOut() async {
    await AuthService.instance.signOut();
    // Firebase stream fires → _onAuthChanged sets unauthenticated
  }
}