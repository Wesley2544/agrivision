import 'package:flutter/material.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';

void main() {
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
        fontFamily: 'Syne',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.greenDeep,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}