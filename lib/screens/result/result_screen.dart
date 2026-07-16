import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../database/db_provider.dart';
import '../../models/result_args.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;
  bool _saved    = false;

  // ── Save diagnosis to SQLite ──────────────────────────
  Future<void> _saveRecord(ResultArgs args) async {
    if (_saved) return;
    setState(() => _isSaving = true);

    try {
      final diagnosisId = await DBProvider.database
          .diagnosisDao
          .insertDiagnosis(
            crop:       args.diagnosis.crop,
            disease:    args.diagnosis.disease,
            confidence: args.diagnosis.confidence,
            imagePath:  args.imagePath,
          );

      // Queue for cloud sync when internet is available
      await DBProvider.database
          .diagnosisDao
          .queueForSync(diagnosisId);

      setState(() {
        _saved    = true;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Diagnosis saved successfully'),
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
            content: Text('❌ Save failed: $e'),
            backgroundColor: const Color(0xFFE74C3C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read arguments passed from ScanScreen
    final args = ModalRoute.of(context)?.settings.arguments
        as ResultArgs?;

    // Fallback if opened without arguments (e.g. direct route)
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
              const SizedBox(height: 8),
              const Text('Go back and scan a crop first',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDim)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.scan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenMid,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Scan a Crop'),
              ),
            ],
          ),
        ),
      );
    }

    final diagnosis  = args.diagnosis;
    final severityColor = diagnosis.isHealthy
        ? AppColors.greenBright
        : diagnosis.confidence >= 90
            ? const Color(0xFFE74C3C)
            : diagnosis.confidence >= 70
                ? AppColors.amber
                : const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [

          // ── Crop image area ──────────────────────
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Show captured image or gradient fallback
                args.imagePath.isNotEmpty &&
                        File(args.imagePath).existsSync()
                    ? Image.file(
                        File(args.imagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF183D1C),
                              Color(0xFF2A6030),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.eco_rounded,
                            size: 90,
                            color: Colors.white
                                .withOpacity(0.2),
                          ),
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

                // Back button + status badge
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
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5),
                          decoration: BoxDecoration(
                            color: diagnosis.isHealthy
                                ? AppColors.greenMid
                                : const Color(0xFFE74C3C),
                            borderRadius:
                                BorderRadius.circular(100),
                          ),
                          child: Text(
                            diagnosis.isHealthy
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

          // ── Result body ──────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  16, 8, 16, 20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // Disease name + crop
                  Text(
                    diagnosis.disease,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenDeep),
                  ),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.grass_rounded,
                        size: 12,
                        color: AppColors.textDim),
                    const SizedBox(width: 4),
                    Text(
                      '${diagnosis.crop}  ·  ${args.location}',
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textDim),
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
                          offset: const Offset(0, 3),
                        ),
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
                            '${diagnosis.confidence.toStringAsFixed(1)}%',
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
                          value: diagnosis.confidence / 100,
                          minHeight: 6,
                          backgroundColor:
                              const Color(0xFFE5F0E8),
                          valueColor:
                              AlwaysStoppedAnimation(
                                  AppColors.greenBright),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),

                  // Severity + info cards
                  Row(children: [
                    _infoCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: severityColor,
                      iconBg: severityColor
                          .withOpacity(0.12),
                      title: 'Severity',
                      value: diagnosis.severityLevel,
                    ),
                    const SizedBox(width: 10),
                    _infoCard(
                      icon: Icons.thermostat_rounded,
                      iconColor: AppColors.amber,
                      iconBg: AppColors.amberLight,
                      title: 'Spread Risk',
                      value: diagnosis.isHealthy
                          ? 'None'
                          : diagnosis.confidence >= 85
                              ? 'High'
                              : 'Moderate',
                    ),
                    const SizedBox(width: 10),
                    _infoCard(
                      icon: Icons.schedule_rounded,
                      iconColor: AppColors.greenMid,
                      iconBg: AppColors.greenLight,
                      title: 'Act Within',
                      value: diagnosis.isHealthy
                          ? 'N/A'
                          : '48 hrs',
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // Treatment tags
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
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'RECOMMENDED TREATMENT',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMid,
                                letterSpacing: 1)),
                        const SizedBox(height: 10),
                        if (!diagnosis.isHealthy) ...[
                          Row(children: [
                            _treatTag('Organic',
                                Colors.green.shade700,
                                const Color(0xFFA8E6C3),
                                const Color(0xFFF0FAF4)),
                            const SizedBox(width: 6),
                            _treatTag(
                                'Chemical',
                                const Color(0xFF8B5E3C),
                                const Color(0xFFF4C99A),
                                const Color(0xFFFDF4EC)),
                            const SizedBox(width: 6),
                            _treatTag(
                                'Cultural',
                                const Color(0xFF1D4ED8),
                                const Color(0xFF93C5FD),
                                const Color(0xFFEFF6FF)),
                          ]),
                          const SizedBox(height: 10),
                          Text(
                            _getTreatmentAdvice(
                                diagnosis.disease),
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMid,
                                height: 1.6),
                          ),
                        ] else ...[
                          Row(children: [
                            _treatTag(
                                '✅ Healthy Plant',
                                AppColors.greenMid,
                                AppColors.greenLight,
                                const Color(0xFFF0FAF4)),
                          ]),
                          const SizedBox(height: 10),
                          const Text(
                            'Your crop appears healthy. Continue '
                            'regular monitoring and maintain '
                            'good agricultural practices.',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMid,
                                height: 1.6),
                          ),
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
                          foregroundColor:
                              AppColors.greenMid,
                          side: const BorderSide(
                              color: AppColors.greenBright,
                              width: 1.5),
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12)),
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
                                width: 14,
                                height: 14,
                                child:
                                    CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                              )
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
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12)),
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

  String _getTreatmentAdvice(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('blight')) {
      return 'Apply mancozeb or copper-based fungicide. '
          'Remove and destroy infected plant tissue. '
          'Avoid overhead irrigation. Rotate crops '
          'next season.';
    } else if (d.contains('mosaic') || d.contains('virus')) {
      return 'Remove and destroy infected plants immediately. '
          'Control aphid vectors with insecticide. '
          'Use virus-resistant seed varieties next season.';
    } else if (d.contains('rust')) {
      return 'Apply triazole fungicide at first sign. '
          'Improve air circulation between plants. '
          'Avoid wetting foliage during irrigation.';
    } else if (d.contains('spot')) {
      return 'Apply copper fungicide or chlorothalonil. '
          'Remove infected leaves. Avoid working '
          'in field when plants are wet.';
    } else {
      return 'Consult your local agricultural extension '
          'officer for specific treatment. Remove '
          'visibly infected tissue and monitor '
          'surrounding plants closely.';
    }
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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9)),
            child:
                Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          Text(title,
              style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.textDim)),
        ]),
      ),
    );
  }
}