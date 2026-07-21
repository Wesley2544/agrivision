import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';
import 'database/db_provider.dart';
import 'modules/ai/model_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize AI model
  try {
    await ModelService.instance.initialize();
    print(' AI model loaded');
  } catch (e) {
    print('  AI model failed: $e');
  }

  // 2. Seed treatment database (safe — skips if already seeded)
  try {
    await DBProvider.db.treatmentDao.seedIfEmpty();
  } catch (e) {
    print('  Treatment seed failed: $e');
  }

  runApp(const AgivisionApp());
}

class AgivisionApp extends StatelessWidget {
  const AgivisionApp({super.key});

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