import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword     = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [

          // ── Top green header ──────────────────────────
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.greenDeep, AppColors.greenMid],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58, height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.25), width: 1),
                    ),
                    child: const Icon(Icons.eco_rounded,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text('AGRIVISION',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text('Offline Crop Diagnostics',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 11)),
                ],
              ),
            ),
          ),

          // ── Form ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text('Welcome Back',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.greenDeep)),
                  const SizedBox(height: 4),
                  const Text('Sign in to your account',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textDim)),
                  const SizedBox(height: 24),

                  // Email field
                  _buildField(
                    controller: _emailController,
                    label: 'PHONE / EMAIL',
                    hint: 'farmer@example.com',
                    icon: Icons.person_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // Password field
                  _buildField(
                    controller: _passwordController,
                    label: 'PASSWORD',
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textDim,
                        size: 18,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot password?',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.greenMid,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 22),

                  // Sign In button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.home),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenMid,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                        shadowColor:
                            AppColors.greenBright.withOpacity(0.4),
                      ),
                      child: const Text('SIGN IN',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // OR divider
                  Row(children: [
                    const Expanded(child: Divider(color: Color(0xFFDDE8DF))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or continue with',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textDim)),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFDDE8DF))),
                  ]),
                  const SizedBox(height: 16),

                  // Social buttons
                  Row(children: [
                    _socialBtn(Icons.phone_outlined),
                    const SizedBox(width: 12),
                    _socialBtn(Icons.mail_outline_rounded),
                  ]),
                  const SizedBox(height: 20),

                  // Register link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.register),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textDim),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                  color: AppColors.greenMid,
                                  fontWeight: FontWeight.w700),
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
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE8DF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenDeep.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
              fontSize: 9, color: AppColors.textDim, letterSpacing: 0.5),
          hintStyle: TextStyle(
              fontSize: 12, color: AppColors.textDim.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: AppColors.textMid, size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _socialBtn(IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDDE8DF), width: 1.5),
        ),
        child: Icon(icon, color: AppColors.textMid, size: 20),
      ),
    );
  }
}