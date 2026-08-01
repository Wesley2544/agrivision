class AppConstants {
  AppConstants._();

  // ── Backend connection ──────────────────────────────────

  static const String _backendHost = '192.168.50.141';
  static const int    _backendPort = 8000;

  static String get backendUrl =>
      'http://$_backendHost:$_backendPort';

  // ── API key (must match backend/main.py) ───────────────
  static const String apiKey = 'agivision-app-key-2025';

  // ── Sync settings ──────────────────────────────────────
  static const Duration syncTimeout    = Duration(seconds: 15);
  static const Duration connectTimeout = Duration(seconds: 5);
  static const int      maxBatchSize   = 50;
}