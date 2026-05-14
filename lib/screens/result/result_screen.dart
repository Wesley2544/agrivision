// Example: splash_screen.dart
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [

          // Crop image area
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background gradient (simulates crop image)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF183D1C),
                        Color(0xFF2A6030),
                        Color(0xFF1A4020),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.eco_rounded,
                      size: 90,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),

                // Fade overlay at bottom
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.cream.withOpacity(0.95),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Status bar back button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.black.withOpacity(0.25),
                            ),
                            child: const Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 22),
                          ),
                        ),
                        // Disease detected badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE74C3C),
                            borderRadius:
                                BorderRadius.circular(100),
                          ),
                          child: const Text('DISEASE DETECTED',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Result body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Disease name
                  const Text('Northern Leaf Blight',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.greenDeep)),
                  const SizedBox(height: 3),
                  const Text(
                      'Exserohilum turcicum  ·  Maize  ·  Today',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textDim)),
                  const SizedBox(height: 14),

                  // Confidence score
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greenDeep
                              .withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Confidence Score',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textDim)),
                            const Text('94%',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.greenMid)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.94,
                            minHeight: 6,
                            backgroundColor:
                                const Color(0xFFE5F0E8),
                            valueColor:
                                const AlwaysStoppedAnimation(
                                    AppColors.greenBright),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Treatment section
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greenDeep
                              .withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text('RECOMMENDED TREATMENT',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMid,
                                letterSpacing: 1)),
                        const SizedBox(height: 10),

                        // Treatment type tags
                        Row(children: [
                          _treatTag('Organic', Colors.green.shade700,
                              const Color(0xFFA8E6C3),
                              const Color(0xFFF0FAF4)),
                          const SizedBox(width: 6),
                          _treatTag('Chemical',
                              const Color(0xFF8B5E3C),
                              const Color(0xFFF4C99A),
                              const Color(0xFFFDF4EC)),
                          const SizedBox(width: 6),
                          _treatTag('Cultural',
                              const Color(0xFF1D4ED8),
                              const Color(0xFF93C5FD),
                              const Color(0xFFEFF6FF)),
                        ]),
                        const SizedBox(height: 10),

                        const Text(
                          'Apply mancozeb fungicide at 2kg/ha. '
                          'Remove infected leaves immediately. '
                          'Rotate with non-host crops next season. '
                          'Ensure proper field drainage.',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMid,
                              height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Additional info cards
                  Row(children: [
                    Expanded(
                      child: _infoCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: const Color(0xFFE74C3C),
                        iconBg: const Color(0xFFFEE2E2),
                        title: 'Severity',
                        value: 'High',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _infoCard(
                        icon: Icons.thermostat_rounded,
                        iconColor: AppColors.amber,
                        iconBg: AppColors.amberLight,
                        title: 'Spread Risk',
                        value: 'Moderate',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _infoCard(
                        icon: Icons.schedule_rounded,
                        iconColor: AppColors.greenMid,
                        iconBg: AppColors.greenLight,
                        title: 'Act Within',
                        value: '48 hrs',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined,
                            size: 16),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.greenMid,
                          side: const BorderSide(
                              color: AppColors.greenBright,
                              width: 1.5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.home),
                        icon: const Icon(Icons.save_outlined,
                            size: 16),
                        label: const Text('Save Record'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenMid,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                          elevation: 3,
                          shadowColor: AppColors.greenBright
                              .withOpacity(0.35),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }