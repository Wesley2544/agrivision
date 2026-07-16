import '../modules/ai/inference_engine.dart';

/// Passed from ScanScreen → ResultScreen via route arguments.
class ResultArgs {
  final DiagnosisResult diagnosis;
  final String imagePath;
  final String location;

  const ResultArgs({
    required this.diagnosis,
    required this.imagePath,
    required this.location,
  });
}