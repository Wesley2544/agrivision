import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F0),
      body: Column(
        children: [

          // ── Header ───────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.greenDeep, AppColors.greenMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good morning,',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11)),
                          const Text('Wisley Otieno',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person_outline_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats row
                  Row(children: [
                    _statPill('24', 'Diagnoses'),
                    const SizedBox(width: 8),
                    _statPill('3', 'Alerts'),
                    const SizedBox(width: 8),
                    _statPill('91%', 'Accuracy'),
                  ]),
                ],
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  _sectionLabel('Quick Actions'),
                  const SizedBox(height: 10),

                  // Diagnose button (wide)
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.scan),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.greenMid, AppColors.greenBright],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.camera_alt_outlined,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Diagnose a Crop',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                            Text('Scan now — works offline',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Two secondary cards
                  Row(children: [
                    Expanded(
                      child: _quickCard(
                        icon: Icons.location_on_outlined,
                        iconColor: AppColors.amber,
                        title: 'Outbreak Map',
                        subtitle: 'View region',
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.map),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickCard(
                        icon: Icons.list_alt_outlined,
                        iconColor: AppColors.amber,
                        title: 'History',
                        subtitle: 'Past diagnoses',
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.history),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 18),
                  _sectionLabel('Recent Diagnoses'),
                  const SizedBox(height: 10),

                  _recentItem('Maize', 'Northern Leaf Blight',
                      '94%', const Color(0xFFE74C3C)),
                  const SizedBox(height: 6),
                  _recentItem('Tomato', 'Early Blight',
                      '87%', AppColors.amber),
                  const SizedBox(height: 6),
                  _recentItem('Bean', 'Healthy ✓',
                      '99%', AppColors.greenBright),
                ],
              ),
            ),
          ),

          // ── Bottom Nav 
          _bottomNav(context, 0),
        ],
      ),
    );
  }

  Widget _statPill(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 8)),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text.toUpperCase(),
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMid,
            letterSpacing: 1.2));
  }

  Widget _quickCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.greenDeep.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenDeep)),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 9, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }

  Widget _recentItem(
      String crop, String disease, String conf, Color dotColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        CircleAvatar(radius: 5, backgroundColor: dotColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(crop,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              Text(disease,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textDim)),
            ],
          ),
        ),
        Text(conf,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.greenMid)),
      ]),
    );
  }

  Widget _bottomNav(BuildContext context, int active) {
    final items = [
      (Icons.home_outlined, Icons.home_rounded, 'Home', AppRoutes.home),
      (Icons.camera_alt_outlined, Icons.camera_alt_rounded, 'Scan',
          AppRoutes.scan),
      (Icons.location_on_outlined, Icons.location_on_rounded, 'Map',
          AppRoutes.map),
      (Icons.list_alt_outlined, Icons.list_alt_rounded, 'History',
          AppRoutes.history),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2EBE3))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == active;
          return GestureDetector(
            onTap: () {
              if (!isActive) {
                Navigator.pushReplacementNamed(context, items[i].$4);
              }
            },
            child: Column(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.greenLight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isActive ? items[i].$2 : items[i].$1,
                  color: isActive
                      ? AppColors.greenMid
                      : AppColors.textDim,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(items[i].$3,
                  style: TextStyle(
                      fontSize: 9,
                      color: isActive
                          ? AppColors.greenMid
                          : AppColors.textDim,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal)),
            ]),
          );
        }),
      ),
    );
  }
}