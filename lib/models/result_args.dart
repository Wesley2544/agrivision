import '../modules/ai/inference_engine.dart';
import '../modules/gis/gis_module.dart';

/// Passed from ScanScreen → ResultScreen via route arguments
class ResultArgs {
  final DiagnosisResult diagnosis;
  final String imagePath;
  final GpsResult gpsResult;

  const ResultArgs({
    required this.diagnosis,
    required this.imagePath,
    required this.gpsResult,
  });
}