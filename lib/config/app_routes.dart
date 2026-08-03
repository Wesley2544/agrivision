import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/result/result_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/history/history_screen.dart';

class AppRoutes {
  static const String splash   = '/';
  static const String login    = '/login';
  static const String register = '/register';
  static const String home     = '/home';
  static const String scan     = '/scan';
  static const String result   = '/result';
  static const String map      = '/map';
  static const String history  = '/history';

  static Map<String, WidgetBuilder> get routes => {
    splash:   (_) => const SplashScreen(),
    login:    (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),

    // Protected routes — redirect to login if not authed
    home: (ctx) => _guard(ctx, const HomeScreen()),
    scan: (ctx) => _guard(ctx, const ScanScreen()),
    result: (ctx) => _guard(ctx, const ResultScreen()),
    map:  (ctx) => _guard(ctx, const MapScreen()),
    history: (ctx) => _guard(ctx, const HistoryScreen()),
  };

  /// Redirects unauthenticated users to login
  static Widget _guard(BuildContext ctx, Widget screen) {
    // ★★★ TEMP FOR DEMO — REMOVE THIS LINE AFTER PRESENTING ★★★
    // Bypasses the auth check entirely so protected routes render
    // immediately without needing a signed-in Firebase user.
    return screen;

    // ── Original auth-guard logic — restore by deleting the
    // "return screen;" line above and un-commenting this block ──
    // final isLoggedIn =
    //     ctx.read<AuthProvider>().isLoggedIn;
    // if (!isLoggedIn) {
    //   // Push login and remove all previous routes
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushNamedAndRemoveUntil(
    //       ctx, login, (_) => false);
    //   });
    //   return const SizedBox.shrink();
    // }
    // return screen;
  }
}