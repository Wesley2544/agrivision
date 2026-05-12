import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/result/result_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/history/history_screen.dart';

class AppRoutes {
  static const String splash   = '/splash';
  static const String login    = '/login';
  static const String register = '/register';
  static const String home     = '/home';
  static const String scan     = '/scan';
  static const String result   = '/result';
  static const String map      = '/map';
  static const String history  = '/history';

  static Map<String, WidgetBuilder> routes = {
    splash:   (_) => const SplashScreen(),
    login:    (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home:     (_) => const HomeScreen(),
    scan:     (_) => const ScanScreen(),
    result:   (_) => const ResultScreen(),
    map:      (_) => const MapScreen(),
    history:  (_) => const HistoryScreen(),
  };
}