import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>   _fade;
  late Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade  = CurvedAnimation(
        parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(
            parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    Future.delayed(const Duration(seconds: 6), () {
     if (mounted) {
       Navigator.pushReplacementNamed(context, AppRoutes.login);
     }
    });

    // Check auth state after animation
    Future.delayed(const Duration(milliseconds: 2200), _checkAuth);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAuth() {
    if (!mounted) return;

    final auth  = context.read<AuthProvider>();
    final status = auth.status;

    if (status == AuthStatus.unknown) {
      // Still loading — wait a bit more
      Future.delayed(
          const Duration(milliseconds: 500), _checkAuth);
      return;
    }

    if (status == AuthStatus.authenticated) {
      // ── Requirement 11 + 12: auto-login ──────────────
      // Firebase already has a valid cached session
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:  double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin:  Alignment.topLeft,
            end:    Alignment.bottomRight,
            colors: [
              AppColors.greenDeep,
              AppColors.greenMid,
              AppColors.greenBright,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5),
                    ),
                    child: const Icon(Icons.eco_rounded,
                        color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 24),

                  // App name
                  const Text('AGIVISION',
                      style: TextStyle(
                          color:      Colors.white,
                          fontSize:   32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3)),
                  const SizedBox(height: 10),

                  // Tagline
                  Text(
                    'AI-Powered Crop Disease Diagnosis\n'
                    'Works Completely Offline',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color:  Colors.white.withOpacity(0.65),
                        fontSize: 13,
                        height: 1.6,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 48),

                  // Loading indicator
                  SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}