import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../database/db_provider.dart';
import '../../database/local_database.dart';
import '../../models/result_args.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;
  bool _saved    = false;
  List<Treatment> _treatments = [];
  bool _loadingTreatments = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTreatments();
  }

  Future<void> _loadTreatments() async {
    final args = ModalRoute.of(context)?.settings.arguments
        as ResultArgs?;
    if (args == null) return;

    final treatments = await DBProvider.db.treatmentDao
        .getSmartTreatments(args.diagnosis.disease);

    if (mounted) {
      setState(() {
        _treatments = treatments;
        _loadingTreatments = false;
      });
    }
  }

  Future<void> _saveRecord(ResultArgs args) async {
    if (_saved) return;
    setState(() => _isSaving = true);

    try {
      final diagnosisId = await DBProvider.db.diagnosisDao
          .insertDiagnosis(
            crop:       args.diagnosis.crop,
            disease:    args.diagnosis.disease,
            confidence: args.diagnosis.confidence,
            isHealthy:  args.diagnosis.isHealthy,
            imagePath:  args.imagePath,
            location:   args.gpsResult.label,
            latitude:   args.gpsResult.latitude,
            longitude:  args.gpsResult.longitude,
          );

      await DBProvider.db.diagnosisDao
          .queueForSync(diagnosisId);

      setState(() {
        _saved    = true;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Diagnosis saved successfully'),
            backgroundColor: AppColors.greenMid,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Save failed: $e'),
            backgroundColor: const Color(0xFFE74C3C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments
        as ResultArgs?;

    if (args == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 48, color: AppColors.amber),
              const SizedBox(height: 12),
              const Text('No diagnosis data',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenDeep)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.scan),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenMid,
                    foregroundColor: Colors.white),
                child: const Text('Scan a Crop'),
              ),
            ],
          ),
        ),
      );
    }

    final d = args.diagnosis;
    final severityColor = d.isHealthy
        ? AppColors.greenBright
        : d.confidence >= 90
            ? const Color(0xFFE74C3C)
            : d.confidence >= 70
                ? AppColors.amber
                : const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [

          // ── Image area ───────────────────────────
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.32,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Captured image or fallback
                args.imagePath.isNotEmpty &&
                        File(args.imagePath).existsSync()
                    ? Image.file(
                        File(args.imagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF183D1C),
                              Color(0xFF2A6030)
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.eco_rounded,
                              size: 90,
                              color: Colors.white
                                  .withOpacity(0.2)),
                        ),
                      ),

                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.cream
                              .withOpacity(0.95),
                        ],
                        stops: const [0.35, 1.0],
                      ),
                    ),
                  ),
                ),

                // Back + badge
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pop(context),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black
                                  .withOpacity(0.3),
                            ),
                            child: const Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 22),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: d.isHealthy
                                ? AppColors.greenMid
                                : const Color(0xFFE74C3C),
                            borderRadius:
                                BorderRadius.circular(100),
                          ),
                          child: Text(
                            d.isHealthy
                                ? 'HEALTHY'
                                : 'DISEASE DETECTED',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  16, 8, 16, 20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // Disease name + location
                  Text(d.disease,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.greenDeep)),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.grass_rounded,
                        size: 12,
                        color: AppColors.textDim),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${d.crop}  ·  ${args.gpsResult.label}',
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textDim),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 14),

                  // Confidence bar
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greenDeep
                                .withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Confidence Score',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textDim)),
                          Text(
                            '${d.confidence.toStringAsFixed(1)}%',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.greenMid),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: d.confidence / 100,
                          minHeight: 6,
                          backgroundColor:
                              const Color(0xFFE5F0E8),
                          valueColor:
                              const AlwaysStoppedAnimation(
                                  AppColors.greenBright),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Severity cards
                  Row(children: [
                    _infoCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: severityColor,
                      iconBg: severityColor.withOpacity(0.12),
                      title: 'Severity',
                      value: d.isHealthy
                          ? 'None'
                          : d.confidence >= 90
                              ? 'High'
                              : d.confidence >= 70
                                  ? 'Moderate'
                                  : 'Low',
                    ),
                    const SizedBox(width: 10),
                    _infoCard(
                      icon: Icons.thermostat_rounded,
                      iconColor: AppColors.amber,
                      iconBg: AppColors.amberLight,
                      title: 'Spread Risk',
                      value: d.isHealthy
                          ? 'None'
                          : d.confidence >= 85
                              ? 'High'
                              : 'Moderate',
                    ),
                    const SizedBox(width: 10),
                    _infoCard(
                      icon: Icons.schedule_rounded,
                      iconColor: AppColors.greenMid,
                      iconBg: AppColors.greenLight,
                      title: 'Act Within',
                      value: d.isHealthy ? 'N/A' : '48 hrs',
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // Treatment section
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.greenDeep
                                .withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3)),
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

                        if (_loadingTreatments)
                          const Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      AppColors.greenMid),
                            ),
                          )
                        else if (_treatments.isEmpty)
                          _fallbackTreatment(d.disease)
                        else ...[
                          // Type filter tabs
                          Row(children: [
                            if (_treatments.any(
                                (t) => t.type == 'organic'))
                              _treatTag('🌿 Organic',
                                  Colors.green.shade700,
                                  const Color(0xFFA8E6C3),
                                  const Color(0xFFF0FAF4)),
                            if (_treatments.any(
                                (t) => t.type == 'chemical'))
                              ...[const SizedBox(width: 6),
                              _treatTag('⚗️ Chemical',
                                  const Color(0xFF8B5E3C),
                                  const Color(0xFFF4C99A),
                                  const Color(0xFFFDF4EC))],
                            if (_treatments.any(
                                (t) => t.type == 'cultural'))
                              ...[const SizedBox(width: 6),
                              _treatTag('🌾 Cultural',
                                  const Color(0xFF1D4ED8),
                                  const Color(0xFF93C5FD),
                                  const Color(0xFFEFF6FF))],
                          ]),
                          const SizedBox(height: 10),

                          // Treatment descriptions
                          ..._treatments.map((t) => Padding(
                                padding:
                                    const EdgeInsets.only(
                                        bottom: 8),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets
                                          .only(
                                              top: 5,
                                              right: 8),
                                      decoration:
                                          BoxDecoration(
                                        color: _typeColor(
                                            t.type),
                                        shape:
                                            BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        t.description,
                                        style:
                                            const TextStyle(
                                                fontSize:
                                                    11,
                                                color: AppColors
                                                    .textMid,
                                                height:
                                                    1.55),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.scan),
                        icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 16),
                        label: const Text('Scan Again'),
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
                        onPressed: _saved || _isSaving
                            ? null
                            : () => _saveRecord(args),
                        icon: _isSaving
                            ? const SizedBox(
                                width: 14, height: 14,
                                child:
                                    CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color:
                                            Colors.white))
                            : Icon(
                                _saved
                                    ? Icons.check_rounded
                                    : Icons.save_outlined,
                                size: 16),
                        label: Text(_saved
                            ? 'Saved ✓'
                            : _isSaving
                                ? 'Saving...'
                                : 'Save Record'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _saved
                              ? AppColors.greenBright
                              : AppColors.greenMid,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
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

  Color _typeColor(String type) {
    switch (type) {
      case 'organic':  return Colors.green.shade600;
      case 'chemical': return const Color(0xFF8B5E3C);
      case 'cultural': return const Color(0xFF1D4ED8);
      default:         return AppColors.textMid;
    }
  }

  Widget _fallbackTreatment(String disease) {
    return Text(
      'Consult your local agricultural extension '
      'officer for specific treatment advice for '
      '$disease. Remove visibly infected tissue and '
      'monitor surrounding plants closely.',
      style: const TextStyle(
          fontSize: 11,
          color: AppColors.textMid,
          height: 1.6),
    );
  }

  Widget _treatTag(String label, Color textColor,
      Color borderColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: textColor)),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: AppColors.greenDeep.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          Text(title,
              style: const TextStyle(
                  fontSize: 8, color: AppColors.textDim)),
        ]),
      ),
    );
  }
}