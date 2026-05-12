import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  bool _flashOn = false;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  _iconBtn(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text('Scan Crop',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  // Flash button
                  _iconBtn(
                    icon: _flashOn
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    onTap: () =>
                        setState(() => _flashOn = !_flashOn),
                    iconColor: _flashOn
                        ? AppColors.greenBright
                        : Colors.white,
                  ),
                ],
              ),
            ),

            // Subtitle
            Text(
              'Point camera at the affected plant area',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11,
                  letterSpacing: 0.4),
            ),
            const SizedBox(height: 10),

            // ── Camera viewfinder ─────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    // Camera background
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                      child: Center(
                        child: Icon(
                          Icons.eco_rounded,
                          size: 80,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                    ),

                    // Scanning corners
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CornerPainter(
                            color: AppColors.greenBright),
                      ),
                    ),

                    // Animated scan line
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanAnimation.value *
                              (MediaQuery.of(context).size.height * 0.35),
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
                                  color: AppColors.greenBright
                                      .withOpacity(0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Bottom hint inside frame
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Align leaf within frame',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusTag(
                    icon: Icons.wifi_off_rounded,
                    label: 'Offline Mode',
                    bgColor: Colors.white.withOpacity(0.08),
                    textColor: Colors.white.withOpacity(0.55),
                  ),
                  _statusTag(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'AI Ready',
                    bgColor:
                        AppColors.greenBright.withOpacity(0.13),
                    textColor: AppColors.greenBright,
                    borderColor:
                        AppColors.greenBright.withOpacity(0.3),
                  ),
                ],
              ),
            ),

            // ── Camera controls ───────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white.withOpacity(0.8),
                        size: 22,
                      ),
                    ),
                  ),

                  // Shutter button
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.result),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2),
                        ),
                      ),
                    ),
                  ),

                  // Settings button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 22,
                      ),
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

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
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
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: textColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Custom corner painter ─────────────────────────────────
class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const length = 24.0;
    const padding = 12.0;

    final corners = [
      // Top-left
      [
        Offset(padding, padding + length),
        Offset(padding, padding),
        Offset(padding + length, padding),
      ],
      // Top-right
      [
        Offset(size.width - padding - length, padding),
        Offset(size.width - padding, padding),
        Offset(size.width - padding, padding + length),
      ],
      // Bottom-left
      [
        Offset(padding, size.height - padding - length),
        Offset(padding, size.height - padding),
        Offset(padding + length, size.height - padding),
      ],
      // Bottom-right
      [
        Offset(size.width - padding - length, size.height - padding),
        Offset(size.width - padding, size.height - padding),
        Offset(size.width - padding, size.height - padding - length),
      ],
    ];

    for (final corner in corners) {
      final path = Path()
        ..moveTo(corner[0].dx, corner[0].dy)
        ..lineTo(corner[1].dx, corner[1].dy)
        ..lineTo(corner[2].dx, corner[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter oldDelegate) => false;
}