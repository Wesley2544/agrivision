import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Maize', 'Tomato', 'Beans'];

  // Simulated outbreak data points
  final List<_OutbreakPin> _pins = [
    _OutbreakPin(left: 0.37, top: 0.22, count: 7,
        severity: _Severity.high,   label: 'Northern Blight'),
    _OutbreakPin(left: 0.63, top: 0.18, count: 3,
        severity: _Severity.moderate, label: 'Early Blight'),
    _OutbreakPin(left: 0.22, top: 0.50, count: 2,
        severity: _Severity.moderate, label: 'Leaf Rust'),
    _OutbreakPin(left: 0.70, top: 0.48, count: 1,
        severity: _Severity.low,    label: 'Healthy'),
    _OutbreakPin(left: 0.50, top: 0.68, count: 1,
        severity: _Severity.low,    label: 'Healthy'),
    _OutbreakPin(left: 0.82, top: 0.32, count: 1,
        severity: _Severity.low,    label: 'Healthy'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F0),
      body: Column(
        children: [

          // ── Header ───────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.greenDeep, AppColors.greenMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text('Outbreak Map',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text('Nairobi Region · Cached Offline',
                          style: TextStyle(
                              color:
                                  Colors.white.withOpacity(0.55),
                              fontSize: 10)),
                    ],
                  ),
                  // Offline badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      Icon(Icons.wifi_off_rounded,
                          color: Colors.white.withOpacity(0.75),
                          size: 12),
                      const SizedBox(width: 4),
                      Text('Offline',
                          style: TextStyle(
                              color:
                                  Colors.white.withOpacity(0.75),
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
              ),
            ),
          ),

          // ── Filter chips ─────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final isSelected =
                    _filters[i] == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(
                      () => _selectedFilter = _filters[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.greenMid
                          : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.greenMid
                            : const Color(0xFFC5D9C7),
                        width: 1.5,
                      ),
                    ),
                    child: Text(_filters[i],
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textMid)),
                  ),
                );
              },
            ),
          ),

          // ── Map area ─────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFC8DAC9),
                      width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [

                      // Grid background (map tiles)
                      CustomPaint(
                        painter: _GridPainter(),
                        child: Container(),
                      ),

                      // Roads
                      CustomPaint(
                        painter: _RoadPainter(),
                        child: Container(),
                      ),

                      // Outbreak pins
                      ..._pins.map((pin) =>
                          _buildPin(context, pin)),

                      // Legend
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.93),
                            borderRadius:
                                BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _legendItem(
                                  const Color(0xFFE74C3C),
                                  'High (5+)'),
                              const SizedBox(height: 4),
                              _legendItem(AppColors.amber,
                                  'Moderate (2–4)'),
                              const SizedBox(height: 4),
                              _legendItem(
                                  AppColors.greenBright,
                                  'Low / Healthy'),
                            ],
                          ),
                        ),
                      ),

                      // Compass
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                              Icons.explore_outlined,
                              color: AppColors.greenMid,
                              size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom Nav ───────────────────────────
          _bottomNav(context),
        ],
      ),
    );
  }

  Widget _buildPin(BuildContext context, _OutbreakPin pin) {
    Color pinColor;
    double size;

    switch (pin.severity) {
      case _Severity.high:
        pinColor = const Color(0xFFE74C3C);
        size = 30;
        break;
      case _Severity.moderate:
        pinColor = AppColors.amber;
        size = 24;
        break;
      case _Severity.low:
        pinColor = AppColors.greenBright;
        size = 16;
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: pin.left * constraints.maxWidth - size / 2,
          top: pin.top * constraints.maxHeight - size,
          child: GestureDetector(
            onTap: () => _showPinDetail(context, pin),
            child: Column(
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: pinColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: pinColor.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: pin.severity != _Severity.low
                      ? Center(
                          child: Text(
                            '${pin.count}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : null,
                ),
                Container(
                    width: 2,
                    height: 6,
                    color: Colors.black26),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPinDetail(BuildContext context, _OutbreakPin pin) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pin.label,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDeep)),
            const SizedBox(height: 6),
            Text('${pin.count} case${pin.count > 1 ? "s" : ""} reported in this area',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textDim)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenMid,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(children: [
      CircleAvatar(radius: 5, backgroundColor: color),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontSize: 9, color: AppColors.textMid)),
    ]);
  }

  Widget _bottomNav(BuildContext context) {
    final items = [
      (Icons.home_outlined, Icons.home_rounded,
          'Home', AppRoutes.home),
      (Icons.camera_alt_outlined, Icons.camera_alt_rounded,
          'Scan', AppRoutes.scan),
      (Icons.location_on_outlined, Icons.location_on_rounded,
          'Map', AppRoutes.map),
      (Icons.list_alt_outlined, Icons.list_alt_rounded,
          'History', AppRoutes.history),
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
          final isActive = i == 2;
          return GestureDetector(
            onTap: () {
              if (!isActive) {
                Navigator.pushReplacementNamed(
                    context, items[i].$4);
              }
            },
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
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

// ── Data models ───────────────────────────────────────────
enum _Severity { high, moderate, low }

class _OutbreakPin {
  final double left;
  final double top;
  final int count;
  final _Severity severity;
  final String label;
  const _OutbreakPin({
    required this.left,
    required this.top,
    required this.count,
    required this.severity,
    required this.label,
  });
}

// ── Map painters ──────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDCE9DE)
      ..strokeWidth = 1;

    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA0C3A3).withOpacity(0.5)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.35),
        Offset(size.width, size.height * 0.35), paint);
    canvas.drawLine(Offset(0, size.height * 0.65),
        Offset(size.width, size.height * 0.65), paint);
    canvas.drawLine(Offset(size.width * 0.38, 0),
        Offset(size.width * 0.38, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.68, 0),
        Offset(size.width * 0.68, size.height), paint);
  }

  @override
  bool shouldRepaint(_RoadPainter old) => false;
}