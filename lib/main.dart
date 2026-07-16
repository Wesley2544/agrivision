import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';
import 'modules/ai/model_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load AI model before the app UI renders
  try {
    await ModelService.instance.initialize();
    print(' AI model ready');
  } catch (e) {
    print('  AI model failed to load: $e');
    // App still starts — model will show as not ready on scan screen
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