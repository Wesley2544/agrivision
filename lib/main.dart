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

  // 1. Initialize Firebase first

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized');
  } catch (e) {
    // Print the actual error so you can see it in terminal
    print('❌ Firebase init failed: $e');
    print('   Check that google-services.json is in android/app/');
  }


  // 2. Load AI model
  try {
    await ModelService.instance.initialize();
    print('✅ AI model loaded');
  } catch (e) {
    print('⚠️  AI model: $e');
  }

  // 3. Seed treatment database
  try {
    await DBProvider.db.treatmentDao.seedIfEmpty();
  } catch (e) {
    print('⚠️  Treatments: $e');
  }

  runApp(
    // Wrap the entire app with Provider
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const AgivisionApp(),
    ),
  );
}

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
    Future.delayed(
        const Duration(seconds: 3), _triggerSync);
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
          seedColor:   AppColors.greenDeep,
          brightness:  Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes:       AppRoutes.routes,
    );
  }
}