import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';
import 'database/db_provider.dart';
import 'modules/ai/model_service.dart';
import 'modules/sync/sync_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load AI model
  try {
    await ModelService.instance.initialize();
    print(' AI model loaded');
  } catch (e) {
    print('  AI model: $e');
  }

  // 2. Seed treatment database
  try {
    await DBProvider.db.treatmentDao.seedIfEmpty();
  } catch (e) {
    print('  Treatments: $e');
  }

  runApp(const AgivisionApp());
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

    // Attempt sync shortly after app starts
    Future.delayed(
      const Duration(seconds: 3),
      _triggerSync,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-attempt sync every time app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _triggerSync();
    }
  }

  void _triggerSync() {
    Future.microtask(() async {
      final result = await SyncEngine.instance.syncNow();
      if (result.hadActivity) {
        print('🔄 Sync: ${result.message}');
      }
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