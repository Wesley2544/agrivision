import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Auto-navigate to login after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.greenDeep,
              AppColors.greenMid,
              AppColors.greenBright,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Logo box
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App name
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  'AGIVISION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tagline
              FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'AI-Powered Crop Disease Diagnosis\nWorks Completely Offline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 13,
                    height: 1.6,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Get Started button
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.login),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: AppColors.greenMid,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Sign in link
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.login),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 12,
                      ),
                      children: const [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: AppColors.greenBright,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}