import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

// Result model returned after every diagnosis 
class DiagnosisResult {
  final String crop;
  final String disease;
  final double confidence;
  final bool isHealthy;

  const DiagnosisResult({
    required this.crop,
    required this.disease,
    required this.confidence,
    required this.isHealthy,
  });

  String get severityLevel {
    if (isHealthy) return 'None';
    if (confidence >= 90) return 'High';
    if (confidence >= 70) return 'Moderate';
    return 'Low';
  }
}

// Main inference engine 
class InferenceEngine {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;

  bool get isReady => _isLoaded && _interpreter != null;
  int get numClasses => _labels.length;

  static const int inputSize  = 224;
  static const String _modelPath  = 'assets/model/crop_model.tflite';
  static const String _labelsPath = 'assets/model/labels.txt';

  // Load model and labels from assets
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);

      final raw = await rootBundle.loadString(_labelsPath);
      _labels   = raw
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      _isLoaded = true;

      final inShape  = _interpreter!.getInputTensor(0).shape;
      final outShape = _interpreter!.getOutputTensor(0).shape;
      print('✅ Model loaded — ${_labels.length} classes');
      print('   Input  shape: $inShape');
      print('   Output shape: $outShape');
    } catch (e) {
      _isLoaded = false;
      print('❌ Model failed to load: $e');
      rethrow;
    }
  }

  //  Run diagnosis on a captured image file 
  Future<DiagnosisResult> diagnose(File imageFile) async {
    if (!isReady) {
      throw Exception('Model not loaded — call loadModel() first');
    }

    // 1. Decode and resize image to 224×224
    final bytes   = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Could not decode image file');

    final resized = img.copyResize(
      decoded,
      width:  inputSize,
      height: inputSize,
    );

    // 2. Build float32 input tensor [1, 224, 224, 3]
    //    Normalization is inside the model so we pass raw 0-255 values
    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r.toDouble(),
              pixel.g.toDouble(),
              pixel.b.toDouble(),
            ];
          },
        ),
      ),
    );

    // 3. Prepare output tensor [1, num_classes]
    final output = List.generate(
      1,
      (_) => List.filled(_labels.length, 0.0),
    );

    // 4. Run the model
    _interpreter!.run(input, output);

    // 5. Find the highest scoring class
    final scores    = output[0];
    int bestIndex   = 0;
    double bestScore = 0.0;

    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }

    // 6. Parse the raw label into crop + disease
    //    PlantVillage format: "Tomato___Early_blight"
    //    Some use single underscore: "Tomato_Early_blight"
    final raw   = _labels[bestIndex];
    String crop;
    String disease;

    if (raw.contains('___')) {
      final parts = raw.split('___');
      crop    = _formatLabel(parts[0]);
      disease = _formatLabel(parts[1]);
    } else if (raw.contains('_')) {
      final parts = raw.split('_');
      crop    = parts[0];
      disease = parts.sublist(1).join(' ');
    } else {
      crop    = raw;
      disease = raw;
    }

    final isHealthy = disease.toLowerCase().contains('healthy');

    return DiagnosisResult(
      crop:       crop,
      disease:    disease,
      confidence: bestScore * 100,
      isHealthy:  isHealthy,
    );
  }

  // Converts "Early_blight" to "Early Blight"
  String _formatLabel(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ')
        .trim();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded    = false;
  }
}