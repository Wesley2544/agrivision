import 'inference_engine.dart';

/// Single shared instance of the AI engine
/// accessible from anywhere in the app.
class ModelService {
  ModelService._();
  static final ModelService instance = ModelService._();

  final InferenceEngine engine = InferenceEngine();
  bool _initialized = false;

  bool get isReady => _initialized && engine.isReady;

  Future<void> initialize() async {
    if (_initialized) return;
    await engine.loadModel();
    _initialized = true;
  }
}