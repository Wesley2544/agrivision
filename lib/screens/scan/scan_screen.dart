import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/result_args.dart';
import '../../modules/ai/model_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  bool _flashOn    = false;
  bool _isAnalyzing = false;
  String _statusText = 'AI Ready';

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_scanController);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // ── Request camera permission ─────────────────────────
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  // ── Get current GPS location ──────────────────────────
  Future<String> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return 'Location unavailable';

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          return 'Location permission denied';
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
      return '${pos.latitude.toStringAsFixed(4)}, '
          '${pos.longitude.toStringAsFixed(4)}';
    } catch (_) {
      return 'Location unavailable';
    }
  }

  // ── Core: capture image and run AI ───────────────────
  Future<void> _captureAndDiagnose(ImageSource source) async {
    // 1. Request permission
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final granted = await _requestPermission(permission);
    if (!granted) {
      _showError('Permission denied — please enable it in Settings');
      return;
    }

    // 2. Pick image
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked == null) return; // user cancelled

    // 3. Show loading state
    setState(() {
      _isAnalyzing  = true;
      _statusText   = 'Analysing crop...';
    });
    _scanController.repeat(reverse: true);

    try {
      // 4. Get GPS location (runs in parallel with inference)
      final locationFuture = _getLocation();

      // 5. Run AI inference
      if (!ModelService.instance.isReady) {
        throw Exception('AI model is not loaded yet — restart the app');
      }

      final result = await ModelService.instance.engine
          .diagnose(File(picked.path));

      final location = await locationFuture;

      if (!mounted) return;

      // 6. Navigate to result screen with real data
      Navigator.pushNamed(
        context,
        AppRoutes.result,
        arguments: ResultArgs(
          diagnosis:  result,
          imagePath:  picked.path,
          location:   location,
        ),
      );
    } catch (e) {
      _showError('Diagnosis failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _statusText  = 'AI Ready';
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C0E),
      body: SafeArea(
        child: Column(
          children: [

            // ── Top bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _iconBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text('Scan Crop',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  _iconBtn(
                    icon: _flashOn
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    iconColor: _flashOn
                        ? AppColors.greenBright
                        : Colors.white,
                    onTap: () =>
                        setState(() => _flashOn = !_flashOn),
                  ),
                ],
              ),
            ),

            Text(
              _isAnalyzing
                  ? 'Running AI diagnosis...'
                  : 'Point camera at the affected plant area',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11),
            ),
            const SizedBox(height: 10),

            // ── Camera viewfinder ─────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24),
                child: Stack(
                  children: [
                    // Background
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF162E18),
                            Color(0xFF1A3D1C),
                            Color(0xFF0C1C0E),
                          ],
                        ),
                      ),
                      child: _isAnalyzing
                          ? _analyzingOverlay()
                          : Center(
                              child: Icon(
                                Icons.eco_rounded,
                                size: 80,
                                color: Colors.white
                                    .withOpacity(0.1),
                              ),
                            ),
                    ),

                    // Corner brackets
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CornerPainter(
                          color: _isAnalyzing
                              ? AppColors.amber
                              : AppColors.greenBright,
                        ),
                      ),
                    ),

                    // Scan line animation
                    if (!_isAnalyzing)
                      AnimatedBuilder(
                        animation: _scanAnimation,
                        builder: (context, _) {
                          return Positioned(
                            top: _scanAnimation.value *
                                (MediaQuery.of(context)
                                        .size
                                        .height *
                                    0.32),
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.greenBright,
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors
                                        .greenBright
                                        .withOpacity(0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    // Bottom hint
                    if (!_isAnalyzing)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Text(
                          'Align leaf within frame',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Colors.white.withOpacity(0.5),
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Status tags ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _statusTag(
                    icon: Icons.wifi_off_rounded,
                    label: 'Offline Mode',
                    bgColor:
                        Colors.white.withOpacity(0.08),
                    textColor:
                        Colors.white.withOpacity(0.55),
                  ),
                  _statusTag(
                    icon: _isAnalyzing
                        ? Icons.hourglass_top_rounded
                        : Icons.check_circle_outline_rounded,
                    label: _statusText,
                    bgColor: _isAnalyzing
                        ? AppColors.amber.withOpacity(0.15)
                        : AppColors.greenBright
                            .withOpacity(0.13),
                    textColor: _isAnalyzing
                        ? AppColors.amber
                        : AppColors.greenBright,
                    borderColor: _isAnalyzing
                        ? AppColors.amber.withOpacity(0.3)
                        : AppColors.greenBright
                            .withOpacity(0.3),
                  ),
                ],
              ),
            ),

            // ── Controls ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  24, 4, 24, 20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [

                  // Gallery button
                  GestureDetector(
                    onTap: _isAnalyzing
                        ? null
                        : () => _captureAndDiagnose(
                            ImageSource.gallery),
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white
                            .withOpacity(0.8),
                        size: 22,
                      ),
                    ),
                  ),

                  // Shutter
                  GestureDetector(
                    onTap: _isAnalyzing
                        ? null
                        : () => _captureAndDiagnose(
                            ImageSource.camera),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 200),
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isAnalyzing
                            ? Colors.grey.shade600
                            : Colors.white,
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.3),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isAnalyzing
                                    ? Colors.grey
                                    : Colors.white)
                                .withOpacity(0.15),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: _isAnalyzing
                          ? const Padding(
                              padding: EdgeInsets.all(18),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                    ),
                  ),

                  // Settings
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color:
                          Colors.white.withOpacity(0.8),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _analyzingOverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60, height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.greenBright,
              backgroundColor:
                  Colors.white.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Running AI Model...',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text('This runs fully offline',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11)),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _statusTag({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: borderColor != null
            ? Border.all(color: borderColor)
            : null,
      ),
      child: Row(children: [
        Icon(icon, color: textColor, size: 12),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: textColor,
                fontSize: 9,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ── Corner painter (unchanged from before) ────────────────
class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color      = color
      ..strokeWidth = 2.5
      ..style      = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;

    const length  = 24.0;
    const padding = 12.0;

    final corners = [
      [Offset(padding, padding + length),
       Offset(padding, padding),
       Offset(padding + length, padding)],
      [Offset(size.width - padding - length, padding),
       Offset(size.width - padding, padding),
       Offset(size.width - padding, padding + length)],
      [Offset(padding, size.height - padding - length),
       Offset(padding, size.height - padding),
       Offset(padding + length, size.height - padding)],
      [Offset(size.width - padding - length,
               size.height - padding),
       Offset(size.width - padding, size.height - padding),
       Offset(size.width - padding,
               size.height - padding - length)],
    ];

    for (final c in corners) {
      final path = Path()
        ..moveTo(c[0].dx, c[0].dy)
        ..lineTo(c[1].dx, c[1].dy)
        ..lineTo(c[2].dx, c[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter o) =>
      o.color != color;
}