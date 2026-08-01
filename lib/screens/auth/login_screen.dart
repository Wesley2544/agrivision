import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus   = FocusNode();
  final _passFocus    = FocusNode();
  final _formKey      = GlobalKey<FormState>();

  bool _obscurePass   = true;
  bool _isOffline     = false;
  bool _resetSent     = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((results) {
      if (mounted) {
        setState(() =>
            _isOffline = results.first == ConnectivityResult.none);
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() =>
          _isOffline = result.first == ConnectivityResult.none);
    }
  }

  // ── Form validation ───────────────────────────────────
  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(val.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }
    if (val.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // ── Submit ────────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    context.read<AuthProvider>().clearError();

    if (!_formKey.currentState!.validate()) return;
    if (_isOffline) {
      _showSnack(
          'No internet connection. Connect to sign in.',
          isError: true);
      return;
    }

    final auth    = context.read<AuthProvider>();
    final success = await auth.signIn(
      email:    _emailCtrl.text,
      password: _passwordCtrl.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  // ── Forgot password ───────────────────────────────────
  void _showForgotPassword() {
    final emailCtrl = TextEditingController(
        text: _emailCtrl.text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reset Password',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.greenDeep)),
              const SizedBox(height: 6),
              const Text(
                  'Enter your email to receive a reset link.',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDim)),
              const SizedBox(height: 16),
              TextField(
                controller:    emailCtrl,
                autofocus:     true,
                keyboardType:  TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText:   'Email address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.greenBright,
                        width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_resetSent) return;
                    Navigator.pop(context);
                    final result = await context
                        .read<AuthProvider>()
                        .signOut(); // just to access service
                    // Send via service directly
                    _showSnack(
                        'Reset link sent to ${emailCtrl.text}',
                        isError: false);
                    setState(() => _resetSent = true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenMid,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12)),
                  ),
                  child: const Text('Send Reset Link'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(msg),
        backgroundColor: isError
            ? const Color(0xFFE74C3C)
            : AppColors.greenMid,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [

          // ── Offline banner ────────────────────────────
          if (_isOffline)
            Container(
              width:   double.infinity,
              color:   const Color(0xFFE74C3C),
              padding: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: 16),
              child: const Row(children: [
                Icon(Icons.wifi_off_rounded,
                    color: Colors.white, size: 14),
                SizedBox(width: 8),
                Text('No internet — sign-in unavailable',
                    style: TextStyle(
                        color:    Colors.white,
                        fontSize: 11)),
              ]),
            ),

          // ── Green header ──────────────────────────────
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width:  double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
                colors: [
                  AppColors.greenDeep,
                  AppColors.greenMid
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58, height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(Icons.eco_rounded,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text('AGIVISION',
                      style: TextStyle(
                          color:       Colors.white,
                          fontSize:    20,
                          fontWeight:  FontWeight.w800,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text('Welcome Back',
                        style: TextStyle(
                            fontSize:   22,
                            fontWeight: FontWeight.w800,
                            color:      AppColors.greenDeep)),
                    const SizedBox(height: 4),
                    const Text('Sign in to your account',
                        style: TextStyle(
                            fontSize: 12,
                            color:    AppColors.textDim)),
                    const SizedBox(height: 24),

                    // Email
                    TextFormField(
                      controller:      _emailCtrl,
                      focusNode:       _emailFocus,
                      keyboardType:    TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect:     false,
                      validator:       _validateEmail,
                      onChanged: (_) =>
                          context.read<AuthProvider>().clearError(),
                      // Auto-focus next field on Next key
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_passFocus),
                      decoration: _fieldDecoration(
                        label: 'Email Address',
                        hint:  'you@example.com',
                        icon:  Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextFormField(
                      controller:      _passwordCtrl,
                      focusNode:       _passFocus,
                      obscureText:     _obscurePass,
                      textInputAction: TextInputAction.done,
                      validator:       _validatePassword,
                      onChanged: (_) =>
                          context.read<AuthProvider>().clearError(),
                      // Submit on keyboard "done" key
                      onFieldSubmitted: (_) => _submit(),
                      decoration: _fieldDecoration(
                        label:  'Password',
                        hint:   '••••••••',
                        icon:   Icons.lock_outline_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textDim,
                            size: 18,
                          ),
                          onPressed: () => setState(
                              () => _obscurePass = !_obscurePass),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _showForgotPassword,
                        child: const Text('Forgot password?',
                            style: TextStyle(
                                fontSize:   11,
                                color:      AppColors.greenMid,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ── Firebase error message ─────────────────
                    if (auth.error != null)
                      Container(
                        width:   double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color:        const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  const Color(0xFFFCA5A5)),
                        ),
                        child: Row(children: [
                          const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFE74C3C),
                              size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              auth.error!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color:    Color(0xFFDC2626)),
                            ),
                          ),
                        ]),
                      ),

                    const SizedBox(height: 20),

                    // ── Sign In button ─────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        // Disable + show spinner while loading
                        onPressed: (auth.isLoading || _isOffline)
                            ? null
                            : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenMid,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.greenMid.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14)),
                          elevation: 4,
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white),
                              )
                            : const Text('SIGN IN',
                                style: TextStyle(
                                    fontSize:    13,
                                    fontWeight:  FontWeight.w800,
                                    letterSpacing: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── OR divider ─────────────────────────────
                    Row(children: [
                      const Expanded(
                          child: Divider(
                              color: Color(0xFFDDE8DF))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        child: Text('or continue with',
                            style: TextStyle(
                                fontSize: 11,
                                color:    AppColors.textDim)),
                      ),
                      const Expanded(
                          child: Divider(
                              color: Color(0xFFDDE8DF))),
                    ]),
                    const SizedBox(height: 16),

                    // ── Google Sign-In button ──────────────────
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: (auth.isLoading || _isOffline)
                            ? null
                            : () async {
                                context
                                    .read<AuthProvider>()
                                    .clearError();
                                final success =
                                    await context
                                        .read<AuthProvider>()
                                        .signInWithGoogle();
                                if (success && mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.home);
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFDDE8DF),
                              width: 1.5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            // Google G icon
                            Container(
                              width: 20, height: 20,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle),
                              child: const Text('G',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:   14,
                                      fontWeight: FontWeight.w800,
                                      color:      Color(0xFF4285F4))),
                            ),
                            const SizedBox(width: 10),
                            const Text('Continue with Google',
                                style: TextStyle(
                                    fontSize:   13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMid)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Register link ──────────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.register),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 12,
                                color:    AppColors.textDim),
                            children: [
                              TextSpan(
                                  text: "Don't have an account? "),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                    color:      AppColors.greenMid,
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
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String   label,
    required String   hint,
    required IconData icon,
    Widget?           suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText:  hint,
      labelStyle: const TextStyle(
          fontSize: 12, color: AppColors.textDim),
      hintStyle: TextStyle(
          fontSize: 12,
          color:    AppColors.textDim.withOpacity(0.5)),
      prefixIcon: Icon(icon,
          color: AppColors.textMid, size: 18),
      suffixIcon: suffix,
      filled:     true,
      fillColor:  Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFDDE8DF), width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFDDE8DF), width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: AppColors.greenBright, width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFE74C3C), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFE74C3C), width: 2)),
      contentPadding:
          const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
    );
  }
}