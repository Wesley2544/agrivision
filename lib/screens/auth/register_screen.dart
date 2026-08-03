import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../utils/network_utils.dart'; // ★ CHANGED — added

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl            = TextEditingController();
  final _emailCtrl           = TextEditingController();
  final _passwordCtrl        = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  final _nameFocus     = FocusNode();
  final _emailFocus    = FocusNode();
  final _passFocus     = FocusNode();
  final _confirmFocus  = FocusNode();
  final _formKey        = GlobalKey<FormState>();

  bool _obscurePass        = true;
  bool _obscureConfirm     = true;
  bool _isOffline          = false;
  bool _agreedToTerms      = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

    // ★ CHANGED — was: Connectivity().onConnectivityChanged.listen(...)
    // checking results.first == ConnectivityResult.none directly.
    // Now routes through NetworkUtils, which does a real DNS lookup
    // instead of trusting the raw interface-type reading (unreliable
    // on emulators).
    NetworkUtils.onRealConnectivityChanged.listen((isOnline) {
      if (mounted) {
        setState(() => _isOffline = !isOnline);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // ★ CHANGED — was: Connectivity().checkConnectivity() + comparing
  // to ConnectivityResult.none. Now uses NetworkUtils.hasRealInternet().
  Future<void> _checkConnectivity() async {
    final isOnline = await NetworkUtils.hasRealInternet();
    if (mounted) {
      setState(() => _isOffline = !isOnline);
    }
  }

  // ── Form validation ───────────────────────────────────
  String? _validateName(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Full name is required';
    }
    if (val.trim().length < 2) {
      return 'Enter your full name';
    }
    return null;
  }

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

  String? _validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please confirm your password';
    }
    if (val != _passwordCtrl.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ── Submit ────────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    context.read<AuthProvider>().clearError();

    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _showSnack(
          'Please agree to the Terms & Privacy Policy to continue.',
          isError: true);
      return;
    }

    if (_isOffline) {
      _showSnack(
          'No internet connection. Connect to create an account.',
          isError: true);
      return;
    }

    final auth    = context.read<AuthProvider>();
    final success = await auth.signUp(
      email:    _emailCtrl.text,
      password: _passwordCtrl.text,
      fullName: _nameCtrl.text,
    );

    // Firebase caches the session on-device once signUp succeeds —
    // AuthProvider's authStateChanges listener picks it up automatically,
    // so the user stays logged in on future app launches without
    // anything extra needed here.
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
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
                Text('No internet — sign-up unavailable',
                    style: TextStyle(
                        color:    Colors.white,
                        fontSize: 11)),
              ]),
            ),

          // ── Green header ──────────────────────────────
          Container(
            height: MediaQuery.of(context).size.height * 0.24,
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
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: const Icon(Icons.eco_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 8),
                        const Text('CREATE ACCOUNT',
                            style: TextStyle(
                                color:       Colors.white,
                                fontSize:    18,
                                fontWeight:  FontWeight.w800,
                                letterSpacing: 1.5)),
                        const SizedBox(height: 4),
                        Text('Join AGIVISION',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 11)),
                      ],
                    ),
                  ),
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

                    const Text('Get Started',
                        style: TextStyle(
                            fontSize:   22,
                            fontWeight: FontWeight.w800,
                            color:      AppColors.greenDeep)),
                    const SizedBox(height: 4),
                    const Text('Create an account to diagnose crops',
                        style: TextStyle(
                            fontSize: 12,
                            color:    AppColors.textDim)),
                    const SizedBox(height: 24),

                    // Full name
                    TextFormField(
                      controller:      _nameCtrl,
                      focusNode:       _nameFocus,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      autocorrect:     false,
                      validator:       _validateName,
                      onChanged: (_) =>
                          context.read<AuthProvider>().clearError(),
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_emailFocus),
                      decoration: _fieldDecoration(
                        label: 'Full Name',
                        hint:  'Wisley Otieno',
                        icon:  Icons.badge_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),

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
                      textInputAction: TextInputAction.next,
                      validator:       _validatePassword,
                      onChanged: (_) =>
                          context.read<AuthProvider>().clearError(),
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_confirmFocus),
                      decoration: _fieldDecoration(
                        label:  'Password',
                        hint:   'At least 8 characters',
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
                    const SizedBox(height: 14),

                    // Confirm password
                    TextFormField(
                      controller:      _confirmPasswordCtrl,
                      focusNode:       _confirmFocus,
                      obscureText:     _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      validator:       _validateConfirmPassword,
                      onChanged: (_) =>
                          context.read<AuthProvider>().clearError(),
                      onFieldSubmitted: (_) => _submit(),
                      decoration: _fieldDecoration(
                        label:  'Confirm Password',
                        hint:   '••••••••',
                        icon:   Icons.lock_outline_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textDim,
                            size: 18,
                          ),
                          onPressed: () => setState(() =>
                              _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Terms checkbox ──────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 22, height: 22,
                          child: Checkbox(
                            value: _agreedToTerms,
                            activeColor: AppColors.greenMid,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(4)),
                            onChanged: (val) => setState(
                                () => _agreedToTerms = val ?? false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                                () => _agreedToTerms = !_agreedToTerms),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textDim,
                                      height: 1.4),
                                  children: [
                                    const TextSpan(
                                        text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: const TextStyle(
                                          color: AppColors.greenMid,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(
                                          color: AppColors.greenMid,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

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

                    // ── Create Account button ──────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
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
                            : const Text('CREATE ACCOUNT',
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

                    // ── Google Sign-Up button ──────────────────
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

                    // ── Login link ──────────────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 12,
                                color:    AppColors.textDim),
                            children: [
                              TextSpan(
                                  text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
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