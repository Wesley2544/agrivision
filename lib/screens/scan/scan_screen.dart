import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/result_args.dart';
import '../../modules/ai/model_service.dart';
import '../../modules/gis/gis_module.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with WidgetsBindingObserver {
  // ── Camera ────────────────────────────────────────────
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool   _cameraReady   = false;
  bool   _isInitializing = false;
  String _cameraError   = '';

  // ── UI state ──────────────────────────────────────────
  bool   _isAnalyzing   = false;
  bool   _flashOn       = false;
  bool   _showGrid      = false;

  // ── Focus ─────────────────────────────────────────────
  bool   _autoFocus     = true;   // true = continuous, false = tap-to-focus
  Offset? _focusPoint;            // null means no focus indicator showing

  // ── Zoom ──────────────────────────────────────────────
  double _currentZoom   = 1.0;
  double _minZoom       = 1.0;
  double _maxZoom       = 1.0;

  bool get _modelReady => ModelService.instance.isReady;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        // Phone locked or app backgrounded — dispose camera
        _controller?.dispose();
        if (mounted) setState(() => _cameraReady = false);
        break;

      case AppLifecycleState.resumed:
        // Phone unlocked — reinitialise camera
        if (controller != null && !_isInitializing) {
          _initCamera();
        }
        break;

      default:
        break;
    }
  }

  // ── Camera init ───────────────────────────────────────
  Future<void> _initCamera() async {
    if (_isInitializing) return;
    _isInitializing = true;

    if (mounted) setState(() => _cameraReady = false);

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _cameraError     = 'No cameras found on device';
            _isInitializing  = false;
          });
        }
        return;
      }

      // Always use back camera
      final back = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      // Dispose existing controller first
      await _controller?.dispose();

      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _controller = controller;
      await controller.initialize();

      // Read zoom limits
      _minZoom = await controller.getMinZoomLevel();
      _maxZoom = await controller.getMaxZoomLevel();
      _currentZoom = _minZoom;

      // Set initial focus mode
      await controller.setFocusMode(
          _autoFocus ? FocusMode.auto : FocusMode.locked);

      if (!mounted) return;
      setState(() {
        _cameraReady    = true;
        _cameraError    = '';
        _isInitializing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraError    = 'Camera failed to start: ${e.toString()}';
          _cameraReady    = false;
          _isInitializing = false;
        });
      }
    }
  }

  // ── Flash toggle ──────────────────────────────────────
  Future<void> _toggleFlash() async {
    if (_controller == null || !_cameraReady) return;
    setState(() => _flashOn = !_flashOn);
    await _controller!.setFlashMode(
        _flashOn ? FlashMode.torch : FlashMode.off);
  }

  // ── Tap to focus ──────────────────────────────────────
  Future<void> _onTapToFocus(TapDownDetails details) async {
    if (_controller == null || !_cameraReady) return;

    final size   = MediaQuery.of(context).size;
    final previewH = size.height * 0.58;
    final previewW = size.width - 32;

    final x = details.localPosition.dx / previewW;
    final y = details.localPosition.dy / previewH;

    final clamped = Offset(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));

    try {
      await _controller!.setFocusMode(FocusMode.locked);
      await _controller!.setFocusPoint(clamped);
      await _controller!.setExposurePoint(clamped);

      setState(() => _focusPoint = details.localPosition);

      // Show focus ring for 1.5 seconds then hide
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) setState(() => _focusPoint = null);

      // Return to auto if in auto mode
      if (_autoFocus) {
        await _controller!.setFocusMode(FocusMode.auto);
      }
    } catch (_) {}
  }

  // ── Pinch to zoom ─────────────────────────────────────
  double _baseZoom = 1.0;

  void _onScaleStart(ScaleStartDetails _) {
    _baseZoom = _currentZoom;
  }

  Future<void> _onScaleUpdate(ScaleUpdateDetails d) async {
    if (_controller == null || !_cameraReady) return;
    final newZoom = (_baseZoom * d.scale)
        .clamp(_minZoom, _maxZoom);
    setState(() => _currentZoom = newZoom);
    await _controller!.setZoomLevel(newZoom);
  }

  // ── Gallery picker ────────────────────────────────────
  Future<void> _pickFromGallery() async {
    if (_isAnalyzing) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source:       ImageSource.gallery,
      imageQuality: 90,
      maxWidth:     1024,
      maxHeight:    1024,
    );
    if (picked == null) return;

    await _runDiagnosis(File(picked.path));
  }

  // ── Capture + diagnose ────────────────────────────────
  Future<void> _captureAndDiagnose() async {
    if (!_modelReady) {
      _showError('AI model not ready — tap retry on the status tag');
      return;
    }
    if (!_cameraReady || _controller == null) {
      _showError('Camera not ready');
      return;
    }
    if (_isAnalyzing) return;

    // Briefly lock focus before capture
    try {
      if (_autoFocus) {
        await _controller!.setFocusMode(FocusMode.locked);
      }
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.auto);
      }

      final photo = await _controller!.takePicture();

      if (_autoFocus) {
        await _controller!.setFocusMode(FocusMode.auto);
      }
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.torch);
      }

      await _runDiagnosis(File(photo.path));
    } catch (e) {
      _showError('Capture failed: $e');
    }
  }

  Future<void> _runDiagnosis(File imageFile) async {
    if (!_modelReady) {
      _showError('AI model not loaded');
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final gpsFuture = GisModule.instance.getCurrentPosition();
      final result    = await ModelService.instance.engine
          .diagnose(imageFile);
      final gpsResult = await gpsFuture;

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        AppRoutes.result,
        arguments: ResultArgs(
          diagnosis: result,
          imagePath: imageFile.path,
          gpsResult: gpsResult,
        ),
      );
    } catch (e) {
      _showError('Diagnosis failed: $e');
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  // ── Retry model load ──────────────────────────────────
  Future<void> _retryModel() async {
    try {
      await ModelService.instance.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('Model load failed: $e');
    }
  }

  // ── Settings bottom sheet ─────────────────────────────
  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SettingsSheet(
        autoFocus:    _autoFocus,
        showGrid:     _showGrid,
        currentZoom:  _currentZoom,
        minZoom:      _minZoom,
        maxZoom:      _maxZoom,
        onAutoFocusChanged: (val) async {
          setState(() => _autoFocus = val);
          try {
            await _controller?.setFocusMode(
                val ? FocusMode.auto : FocusMode.locked);
          } catch (_) {}
        },
        onGridChanged: (val) {
          setState(() => _showGrid = val);
        },
        onZoomChanged: (val) async {
          setState(() => _currentZoom = val);
          try {
            await _controller?.setZoomLevel(val);
          } catch (_) {}
        },
        onTapToFocusInfo: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Tap anywhere on the preview to focus'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.greenMid,
            ),
          );
        },
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(msg),
        backgroundColor: const Color(0xFFE74C3C),
        behavior:        SnackBarBehavior.floating,
        duration:        const Duration(seconds: 4),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pushReplacementNamed(
              context, AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [

              // ── Top bar ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _iconBtn(
                      icon: Icons.chevron_left_rounded,
                      onTap: () =>
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.home),
                    ),
                    const Text('Scan Crop',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    _iconBtn(
                      icon: _flashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      iconColor: _flashOn
                          ? AppColors.greenBright
                          : Colors.white,
                      onTap: _toggleFlash,
                    ),
                  ],
                ),
              ),

              // Subtitle
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _isAnalyzing
                      ? 'Running AI diagnosis...'
                      : 'Point camera at the affected leaf',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11),
                ),
              ),

              // ── Camera preview ────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTapDown:    _onTapToFocus,
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [

                          // Camera or error/loading state
                          _buildCameraView(),

                          // Grid overlay
                          if (_showGrid && _cameraReady)
                            CustomPaint(
                                painter: _GridOverlayPainter()),

                          // Corner brackets
                          CustomPaint(
                            painter: _CornerPainter(
                              color: _isAnalyzing
                                  ? AppColors.amber
                                  : AppColors.greenBright,
                            ),
                          ),

                          // Focus ring at tap point
                          if (_focusPoint != null)
                            Positioned(
                              left:  _focusPoint!.dx - 28,
                              top:   _focusPoint!.dy - 28,
                              child: Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.amber,
                                      width: 1.5),
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                              ),
                            ),

                          // Zoom indicator
                          if (_currentZoom > _minZoom + 0.1)
                            Positioned(
                              top: 12, left: 0, right: 0,
                              child: Center(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                        .withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),
                                  child: Text(
                                    '${_currentZoom.toStringAsFixed(1)}×',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),

                          // Focus mode badge
                          Positioned(
                            top: 12, right: 12,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black
                                    .withOpacity(0.45),
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                _autoFocus
                                    ? 'AF'
                                    : 'TAP FOCUS',
                                style: TextStyle(
                                    color: _autoFocus
                                        ? Colors.white
                                            .withOpacity(0.7)
                                        : AppColors.amber,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.w700),
                              ),
                            ),
                          ),

                          // Analyzing overlay
                          if (_isAnalyzing)
                            _analyzingOverlay(),

                          // Bottom hint
                          if (!_isAnalyzing && _cameraReady)
                            Positioned(
                              bottom: 14,
                              left: 0, right: 0,
                              child: Text(
                                'Align leaf within frame  '
                                '·  Pinch to zoom  '
                                '·  Tap to focus',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.55),
                                    fontSize: 9.5,
                                    shadows: const [
                                      Shadow(
                                          blurRadius: 4,
                                          color: Colors.black)
                                    ]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Status tags ───────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _statusTag(
                      icon:      Icons.wifi_off_rounded,
                      label:     'Offline Mode',
                      bgColor:   Colors.white.withOpacity(0.08),
                      textColor: Colors.white.withOpacity(0.55),
                    ),
                    GestureDetector(
                      onTap: _modelReady ? null : _retryModel,
                      child: _statusTag(
                        icon: _modelReady
                            ? Icons.check_circle_outline_rounded
                            : Icons.refresh_rounded,
                        label: _modelReady
                            ? 'AI Ready'
                            : 'Tap to retry',
                        bgColor: _modelReady
                            ? AppColors.greenBright
                                .withOpacity(0.13)
                            : AppColors.amber.withOpacity(0.15),
                        textColor: _modelReady
                            ? AppColors.greenBright
                            : AppColors.amber,
                        borderColor: _modelReady
                            ? AppColors.greenBright
                                .withOpacity(0.3)
                            : AppColors.amber.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Controls row ──────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    28, 4, 28, 24),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [

                    // LEFT — Gallery picker
                    GestureDetector(
                      onTap: _isAnalyzing
                          ? null
                          : _pickFromGallery,
                      child: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.2)),
                        ),
                        child: Icon(
                          Icons.photo_library_outlined,
                          color: Colors.white.withOpacity(0.85),
                          size: 22,
                        ),
                      ),
                    ),

                    // CENTER — Shutter
                    GestureDetector(
                      onTap: (_isAnalyzing ||
                              !_cameraReady ||
                              !_modelReady)
                          ? null
                          : _captureAndDiagnose,
                      child: AnimatedContainer(
                        duration: const Duration(
                            milliseconds: 200),
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (_isAnalyzing ||
                                  !_cameraReady)
                              ? Colors.grey.shade700
                              : Colors.white,
                          border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.3),
                              width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(
                                  _isAnalyzing ? 0 : 0.2),
                              blurRadius:  16,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: _isAnalyzing
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white),
                              )
                            : Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2),
                                ),
                              ),
                      ),
                    ),

                    // RIGHT — Settings
                    GestureDetector(
                      onTap: _openSettings,
                      child: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.2)),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white.withOpacity(0.85),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Camera view ───────────────────────────────────────
  Widget _buildCameraView() {
    // Show loading while initializing
    if (_isInitializing || (!_cameraReady && _cameraError.isEmpty)) {
      return Container(
        color: const Color(0xFF0A1A0C),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                  color: AppColors.greenBright,
                  strokeWidth: 2),
              const SizedBox(height: 12),
              Text('Starting camera...',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12)),
            ],
          ),
        ),
      );
    }

    // Show error state
    if (_cameraError.isNotEmpty) {
      return Container(
        color: const Color(0xFF0A1A0C),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined,
                    size: 48,
                    color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 14),
                Text(_cameraError,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 12),
                    textAlign: TextAlign.center),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _initCamera,
                  icon: const Icon(Icons.refresh_rounded,
                      size: 16),
                  label: const Text('Retry Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenMid,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show live preview
    if (_controller != null && _controller!.value.isInitialized) {
      return CameraPreview(_controller!);
    }

    // Fallback loading
    return Container(color: const Color(0xFF0A1A0C));
  }

  Widget _analyzingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 56, height: 56,
              child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.greenBright,
                  backgroundColor:
                      Colors.white.withOpacity(0.1)),
            ),
            const SizedBox(height: 18),
            const Text('Analysing crop...',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('Running AI model offline',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _statusTag({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: borderColor != null
            ? Border.all(color: borderColor)
            : null,
      ),
      child: Row(children: [
        Icon(icon, color: textColor, size: 12),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: textColor,
                fontSize: 9,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════
// SETTINGS BOTTOM SHEET
// ══════════════════════════════════════════════════════════

class _SettingsSheet extends StatefulWidget {
  final bool   autoFocus;
  final bool   showGrid;
  final double currentZoom;
  final double minZoom;
  final double maxZoom;
  final ValueChanged<bool>   onAutoFocusChanged;
  final ValueChanged<bool>   onGridChanged;
  final ValueChanged<double> onZoomChanged;
  final VoidCallback         onTapToFocusInfo;

  const _SettingsSheet({
    required this.autoFocus,
    required this.showGrid,
    required this.currentZoom,
    required this.minZoom,
    required this.maxZoom,
    required this.onAutoFocusChanged,
    required this.onGridChanged,
    required this.onZoomChanged,
    required this.onTapToFocusInfo,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late bool   _autoFocus;
  late bool   _showGrid;
  late double _zoom;

  @override
  void initState() {
    super.initState();
    _autoFocus = widget.autoFocus;
    _showGrid  = widget.showGrid;
    _zoom      = widget.currentZoom;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text('Camera Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),

          // ── Focus mode ──────────────────────────────────
          _sectionLabel('FOCUS MODE'),
          const SizedBox(height: 8),

          Row(children: [
            _focusOption(
              label:    'Auto Focus',
              subtitle: 'Continuous autofocus',
              icon:     Icons.center_focus_strong_rounded,
              selected: _autoFocus,
              onTap: () {
                setState(() => _autoFocus = true);
                widget.onAutoFocusChanged(true);
              },
            ),
            const SizedBox(width: 10),
            _focusOption(
              label:    'Tap to Focus',
              subtitle: 'Tap preview to focus',
              icon:     Icons.touch_app_rounded,
              selected: !_autoFocus,
              onTap: () {
                setState(() => _autoFocus = false);
                widget.onAutoFocusChanged(false);
                widget.onTapToFocusInfo();
              },
            ),
          ]),
          const SizedBox(height: 20),

          // ── Zoom ────────────────────────────────────────
          _sectionLabel('ZOOM LEVEL'),
          const SizedBox(height: 4),
          Row(children: [
            Text('${widget.minZoom.toStringAsFixed(1)}×',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11)),
            Expanded(
              child: Slider(
                value:    _zoom,
                min:      widget.minZoom,
                max:      widget.maxZoom,
                divisions: ((widget.maxZoom - widget.minZoom)
                        * 10)
                    .round(),
                activeColor:   AppColors.greenBright,
                inactiveColor: Colors.white.withOpacity(0.15),
                label: '${_zoom.toStringAsFixed(1)}×',
                onChanged: (v) {
                  setState(() => _zoom = v);
                  widget.onZoomChanged(v);
                },
              ),
            ),
            Text('${widget.maxZoom.toStringAsFixed(1)}×',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11)),
          ]),
          const SizedBox(height: 16),

          // ── Grid overlay ─────────────────────────────────
          _sectionLabel('COMPOSITION'),
          const SizedBox(height: 8),
          _toggleRow(
            icon:    Icons.grid_3x3_rounded,
            label:   'Rule of Thirds Grid',
            value:   _showGrid,
            onChanged: (v) {
              setState(() => _showGrid = v);
              widget.onGridChanged(v);
            },
          ),
          const SizedBox(height: 12),

          // ── Tip ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.greenMid.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.greenMid.withOpacity(0.25)),
            ),
            child: Row(children: [
              Icon(Icons.lightbulb_outline_rounded,
                  color: AppColors.greenBright, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'For best results: use Tap to Focus and '
                  'tap directly on the leaf before capturing.',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.5),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text,
        style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2));
  }

  Widget _focusOption({
    required String   label,
    required String   subtitle,
    required IconData icon,
    required bool     selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.greenMid.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.greenBright.withOpacity(0.6)
                  : Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected
                      ? AppColors.greenBright
                      : Colors.white.withOpacity(0.4),
                  size: 24),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.55),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 9),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleRow({
    required IconData icon,
    required String   label,
    required bool     value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(children: [
      Icon(icon,
          color: Colors.white.withOpacity(0.5), size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 13)),
      ),
      Switch(
        value:            value,
        onChanged:        onChanged,
        activeColor:      AppColors.greenBright,
        inactiveTrackColor: Colors.white.withOpacity(0.15),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════
// PAINTERS
// ══════════════════════════════════════════════════════════

class _GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = Colors.white.withOpacity(0.25)
      ..strokeWidth  = 0.5;

    // 2 horizontal lines (rule of thirds)
    canvas.drawLine(Offset(0, size.height / 3),
        Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3),
        Offset(size.width, size.height * 2 / 3), paint);

    // 2 vertical lines
    canvas.drawLine(Offset(size.width / 3, 0),
        Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0),
        Offset(size.width * 2 / 3, size.height), paint);
  }

  @override
  bool shouldRepaint(_GridOverlayPainter _) => false;
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..strokeWidth  = 2.5
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round;

    const l = 24.0;
    const p = 12.0;

    for (final corner in [
      [Offset(p, p + l), Offset(p, p), Offset(p + l, p)],
      [Offset(size.width - p - l, p),
       Offset(size.width - p, p),
       Offset(size.width - p, p + l)],
      [Offset(p, size.height - p - l),
       Offset(p, size.height - p),
       Offset(p + l, size.height - p)],
      [Offset(size.width - p - l, size.height - p),
       Offset(size.width - p, size.height - p),
       Offset(size.width - p, size.height - p - l)],
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(corner[0].dx, corner[0].dy)
          ..lineTo(corner[1].dx, corner[1].dy)
          ..lineTo(corner[2].dx, corner[2].dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CornerPainter o) => o.color != color;
}