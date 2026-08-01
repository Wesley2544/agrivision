import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

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
    if (isHealthy)            return 'None';
    if (confidence >= 90)     return 'High';
    if (confidence >= 70)     return 'Moderate';
    return 'Low';
  }
}

class InferenceEngine {
  Interpreter? _interpreter;
  List<String>  _labels   = [];
  bool          _isLoaded = false;
  String?       _lastError;

  bool    get isReady   => _isLoaded && _interpreter != null;
  int     get numClasses => _labels.length;
  String? get lastError  => _lastError;

  static const int    inputSize   = 224;
  static const String _modelPath  = 'assets/model/crop_model.tflite';
  static const String _labelsPath = 'assets/model/labels.txt';
  static const double _threshold  = 55.0;

  Future<void> loadModel() async {
    try {
      // Load bytes directly — more reliable than fromAsset on all devices
      final ByteData modelData = await rootBundle.load(_modelPath);
      final Uint8List modelBytes = modelData.buffer.asUint8List(
        modelData.offsetInBytes,
        modelData.lengthInBytes,
      );

      _interpreter = Interpreter.fromBuffer(modelBytes);

      // Load labels
      final String labelsRaw =
          await rootBundle.loadString(_labelsPath);
      _labels = labelsRaw
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      _isLoaded  = true;
      _lastError = null;

      final inShape  = _interpreter!.getInputTensor(0).shape;
      final outShape = _interpreter!.getOutputTensor(0).shape;
      print(' Model loaded — ${_labels.length} classes');
      print('   Input : $inShape');
      print('   Output: $outShape');
    } catch (e) {
      _isLoaded  = false;
      _lastError = e.toString();
      print(' Model failed to load: $e');
      rethrow;
    }
  }

  Future<DiagnosisResult> diagnose(File imageFile) async {
    if (!isReady) {
      throw Exception(
          'Model not loaded. Error: ${_lastError ?? "unknown"}');
    }

    final bytes   = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Could not decode image');

    final resized = img.copyResize(decoded,
        width: inputSize, height: inputSize);

    // Build float32 input tensor — normalization inside model
    final input = [
      List.generate(inputSize, (y) =>
        List.generate(inputSize, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            pixel.r.toDouble(),
            pixel.g.toDouble(),
            pixel.b.toDouble(),
          ];
        })),
    ];

    final output =
        List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter!.run(input, output);

    final scores = output[0];
    int    bestIndex = 0;
    double bestScore = 0.0;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }

    // Return uncertain if below threshold
    if (bestScore * 100 < _threshold) {
      return const DiagnosisResult(
        crop:       'Unknown',
        disease:    'Uncertain — low confidence',
        confidence: 0,
        isHealthy:  false,
      );
    }

    final raw = _labels[bestIndex];
    String crop;
    String disease;

    if (raw.contains('___')) {
      final parts = raw.split('___');
      crop    = _formatLabel(parts[0]);
      disease = _formatLabel(parts[1]);
    } else {
      final parts = raw.split('_');
      crop    = parts.isNotEmpty ? parts[0] : raw;
      disease = parts.length > 1
          ? parts.sublist(1).join(' ')
          : raw;
    }

    final isHealthy = disease.toLowerCase().contains('healthy');

    return DiagnosisResult(
      crop:       crop,
      disease:    disease,
      confidence: bestScore * 100,
      isHealthy:  isHealthy,
    );
  }

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