import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';
import 'database/db_provider.dart';
import 'modules/ai/model_service.dart';
import 'modules/sync/sync_engine.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase MUST initialize before anything else.
  // If this fails the app shows an error screen
  // instead of crashing with a red screen.
  bool firebaseReady = false;
  String? firebaseError;

  try {
    await Firebase.initializeApp();
    firebaseReady = true;
    print('✅ Firebase initialized');
  } catch (e) {
    firebaseError = e.toString();
    print('❌ Firebase failed: $firebaseError');
  }

  // If Firebase failed, show a clear error screen
  if (!firebaseReady) {
    runApp(_FirebaseErrorApp(error: firebaseError ?? 'Unknown'));
    return;
  }

  // AI model
  try {
    await ModelService.instance.initialize();
    print('✅ AI model loaded');
  } catch (e) {
    print('⚠️  AI model: $e');
  }

  // Seed treatments
  try {
    await DBProvider.db.treatmentDao.seedIfEmpty();
    print('✅ Treatments seeded');
  } catch (e) {
    print('⚠️  Treatments: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const AgivisionApp(),
    ),
  );
}

// ── Shows when Firebase fails to init ─────────────────────
class _FirebaseErrorApp extends StatelessWidget {
  final String error;
  const _FirebaseErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0A3D1F),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.white, size: 64),
              const SizedBox(height: 24),
              const Text('Firebase Setup Required',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  error,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Fix:\n'
                '1. Download google-services.json\n'
                '   from Firebase Console\n'
                '2. Place it in android/app/\n'
                '3. Run flutter clean && flutter run',
                style: TextStyle(
                    color: Colors.white60, fontSize: 13,
                    height: 1.8),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Main app ──────────────────────────────────────────────
class AgivisionApp extends StatefulWidget {
  const AgivisionApp({super.key});

  @override
  State<AgivisionApp> createState() => _AgivisionAppState();
}

class _AgivisionAppState extends State<AgivisionApp>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 3), _triggerSync);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _triggerSync();
  }

  void _triggerSync() {
    Future.microtask(() async {
      final result = await SyncEngine.instance.syncNow();
      if (result.hadActivity) print('🔄 ${result.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGIVISION',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.greenDeep,
        fontFamily: 'DM Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.greenDeep,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}