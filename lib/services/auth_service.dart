import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Result returned from every auth operation
class AuthResult {
  final bool    success;
  final String? error;
  final User?   user;

  const AuthResult({
    required this.success,
    this.error,
    this.user,
  });
}

/// Wraps Firebase Auth — single source of truth for
/// all authentication operations in the app
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth  _auth         = FirebaseAuth.instance;
  final GoogleSignIn  _googleSignIn = GoogleSignIn();

  User? get currentUser     => _auth.currentUser;
  bool  get isAuthenticated => _auth.currentUser != null;

  /// Stream that emits whenever auth state changes
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  // ── Connectivity check ───────────────────────────────
  Future<bool> _isConnected() async {
    final result =
        await Connectivity().checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  // ── Firebase error → readable message ────────────────
  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few minutes.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      case 'operation-not-allowed':
        return 'Sign-in method not enabled.';
      default:
        return 'Authentication failed (${e.code}). '
            'Please try again.';
    }
  }

  // ── Email + password sign in ──────────────────────────
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    if (!await _isConnected()) {
      return const AuthResult(
        success: false,
        error: 'No internet connection. '
            'Connect to sign in.',
      );
    }

    try {
      final cred =
          await _auth.signInWithEmailAndPassword(
        email:    email.trim().toLowerCase(),
        password: password,
      );
      return AuthResult(success: true, user: cred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: _mapError(e));
    } catch (_) {
      return const AuthResult(
        success: false,
        error: 'An unexpected error occurred.',
      );
    }
  }

  // ── Email + password sign up ──────────────────────────
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (!await _isConnected()) {
      return const AuthResult(
        success: false,
        error: 'No internet connection. '
            'Connect to create an account.',
      );
    }

    try {
      final cred =
          await _auth.createUserWithEmailAndPassword(
        email:    email.trim().toLowerCase(),
        password: password,
      );

      // Store display name
      await cred.user?.updateDisplayName(fullName.trim());

      return AuthResult(success: true, user: cred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: _mapError(e));
    } catch (_) {
      return const AuthResult(
        success: false,
        error: 'Account creation failed. Try again.',
      );
    }
  }

  // ── Google Sign-In ────────────────────────────────────
  Future<AuthResult> signInWithGoogle() async {
    if (!await _isConnected()) {
      return const AuthResult(
        success: false,
        error: 'No internet connection for Google sign-in.',
      );
    }

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const AuthResult(
          success: false,
          error: 'Google sign-in was cancelled.',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );

      final cred =
          await _auth.signInWithCredential(credential);
      return AuthResult(success: true, user: cred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: _mapError(e));
    } catch (_) {
      return const AuthResult(
        success: false,
        error: 'Google sign-in failed. Please try again.',
      );
    }
  }

  // ── Password reset ────────────────────────────────────
  Future<AuthResult> sendPasswordReset(String email) async {
    if (!await _isConnected()) {
      return const AuthResult(
        success: false,
        error: 'No internet connection.',
      );
    }

    try {
      await _auth.sendPasswordResetEmail(
          email: email.trim().toLowerCase());
      return const AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: _mapError(e));
    }
  }

  // ── Get fresh ID token (auto-refreshes if expired) ───
  Future<String?> getIdToken() async {
    try {
      // force: false — Firebase refreshes automatically
      // when token is within 5 minutes of expiry
      return await _auth.currentUser?.getIdToken();
    } catch (_) {
      return null;
    }
  }

  // ── Sign out ──────────────────────────────────────────
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}