import 'package:agrivision/modules/sync/sync_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../database/db_provider.dart';
import '../../database/local_database.dart';
import '../../providers/auth_provider.dart'; // ← adjust path if different

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 11)),
                          const Text('Wisley Otieno',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showProfileMenu(context),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(
                            context
                                .watch<AuthProvider>()
                                .displayName[0]
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats row
                  FutureBuilder<List<Diagnosis>>(
                    future: DBProvider.db.diagnosisDao.getAllDiagnoses(),
                    builder: (context, snapshot) {
                      final records = snapshot.data ?? [];
                      final total   = records.length;
                      final disease = records.where((d) => !d.isHealthy).length;
                      final avgConf = records.isEmpty
                          ? 0.0
                          : records.fold<double>(
                                  0, (s, d) => s + d.confidence) /
                              records.length;
                      return Row(children: [
                        _statPill('$total', 'Diagnoses'),
                        const SizedBox(width: 8),
                        _statPill('$disease', 'Alerts'),
                        const SizedBox(width: 8),
                        _statPill(
                            '${avgConf.toStringAsFixed(0)}%', 'Accuracy'),
                      ]);
                    },
                  ),
                  _syncStatus(),
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
                            color: Colors.white.withValues(alpha: 0.2),
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

                  // ── Recent Diagnoses ─────────────────────────────
                  _sectionLabel('Recent Diagnoses'),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Diagnosis>>(
                    future: DBProvider.db.diagnosisDao.getAllDiagnoses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                                color: AppColors.greenMid,
                                strokeWidth: 2),
                          ),
                        );
                      }

                      final records = snapshot.data ?? [];

                      if (records.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.greenDeep
                                    .withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'No diagnoses yet — scan a crop to get started',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textDim),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      // Show latest 3 diagnoses
                      final latest = records.take(3).toList();
                      return Column(
                        children: latest.map((d) {
                          final dotColor = d.isHealthy
                              ? AppColors.greenBright
                              : d.confidence >= 90
                                  ? const Color(0xFFE74C3C)
                                  : AppColors.amber;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _recentItem(
                              d.crop,
                              d.disease,
                              '${d.confidence.toStringAsFixed(0)}%',
                              dotColor,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
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

  // ── Profile menu / sign out ─────────────────────────
  void _showProfileMenu(BuildContext context) {
    final auth = context.read<AuthProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile info
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  AppColors.greenMid.withValues(alpha: 0.15),
              child: Text(
                auth.displayName[0].toUpperCase(),
                style: const TextStyle(
                    fontSize:   28,
                    fontWeight: FontWeight.w800,
                    color:      AppColors.greenMid),
              ),
            ),
            const SizedBox(height: 10),
            Text(auth.displayName,
                style: const TextStyle(
                    fontSize:   16,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.greenDeep)),
            Text(auth.email,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textDim)),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),

            // Sign out
            ListTile(
              leading: const Icon(Icons.logout_rounded,
                  color: Color(0xFFE74C3C)),
              title: const Text('Sign Out',
                  style: TextStyle(
                      color: Color(0xFFE74C3C),
                      fontWeight: FontWeight.w600)),
              onTap: () async {
                Navigator.pop(context);
                await auth.signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 8)),
        ]),
      ),
    );
  }

  Widget _syncStatus(){
    return FutureBuilder<int>(
      future: SyncEngine.instance.getPendingCount(),
      builder: (context, snapshot) {
        final count= snapshot.data ?? 0;
        if (count==0) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () async {
            final result= await SyncEngine.instance.syncNow();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.message),
                  backgroundColor: result.success
                      ? AppColors.greenMid
                      : const Color(0xFFE74C3C),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                const Icon(Icons.sync_rounded, color: Colors.white, size: 14),
                const SizedBox(width:6),
                Text(
                  '$count unsynced — tap to sync now',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
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
                color: AppColors.greenDeep.withValues(alpha: 0.07),
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
              color: Colors.black.withValues(alpha: 0.04),
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