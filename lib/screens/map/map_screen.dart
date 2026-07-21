import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../database/db_provider.dart';
import '../../database/local_database.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Disease', 'Healthy'];
  List<Diagnosis> _gpsData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGpsData();
  }

  Future<void> _loadGpsData() async {
    final data = await DBProvider.db.diagnosisDao
        .getDiagnosesWithGps();
    if (mounted) {
      setState(() {
        _gpsData = data;
        _loading = false;
      });
    }
  }

  List<Diagnosis> get _filtered {
    return _gpsData.where((d) {
      if (_selectedFilter == 'Healthy') return d.isHealthy;
      if (_selectedFilter == 'Disease') return !d.isHealthy;
      return true;
    }).toList();
  }

  // Converts GPS coordinates to relative map positions (0.0–1.0)
  Map<String, double> _toRelativePosition(
      Diagnosis d, List<Diagnosis> all) {
    if (all.length == 1) {
      return {'left': 0.5, 'top': 0.4};
    }

    final lats = all.map((e) => e.latitude!).toList();
    final lngs = all.map((e) => e.longitude!).toList();

    final minLat = lats.reduce(min);
    final maxLat = lats.reduce(max);
    final minLng = lngs.reduce(min);
    final maxLng = lngs.reduce(max);

    final latRange = (maxLat - minLat).abs();
    final lngRange = (maxLng - minLng).abs();

    final relLng = lngRange == 0
        ? 0.5
        : (d.longitude! - minLng) / lngRange;
    final relLat = latRange == 0
        ? 0.5
        : 1.0 - ((d.latitude! - minLat) / latRange);

    // Keep pins within visible bounds (10%–90%)
    return {
      'left': 0.1 + relLng * 0.8,
      'top':  0.1 + relLat * 0.7,
    };
  }

  Color _pinColor(Diagnosis d) {
    if (d.isHealthy)        return AppColors.greenBright;
    if (d.confidence >= 85) return const Color(0xFFE74C3C);
    return AppColors.amber;
  }

  double _pinSize(Diagnosis d) {
    if (d.isHealthy)        return 15;
    if (d.confidence >= 85) return 28;
    return 22;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F0),
      body: Column(
        children: [

          // ── Header ─────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(
                16, 0, 16, 13),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.greenDeep,
                  AppColors.greenMid
                ],
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
                      Text(
                        '${_gpsData.length} GPS-tagged '
                        'diagnosis${_gpsData.length != 1 ? "es" : ""}',
                        style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.55),
                            fontSize: 10),
                      ),
                    ],
                  ),
                  // Refresh button
                  GestureDetector(
                    onTap: () {
                      setState(() => _loading = true);
                      _loadGpsData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.13),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.refresh_rounded,
                            color: Colors.white
                                .withOpacity(0.75),
                            size: 14),
                        const SizedBox(width: 4),
                        Text('Refresh',
                            style: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.75),
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w600)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Filter chips ──────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final sel =
                    _filters[i] == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(
                      () => _selectedFilter = _filters[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.greenMid
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(100),
                      border: Border.all(
                          color: sel
                              ? AppColors.greenMid
                              : const Color(0xFFC5D9C7),
                          width: 1.5),
                    ),
                    child: Text(_filters[i],
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: sel
                                ? Colors.white
                                : AppColors.textMid)),
                  ),
                );
              },
            ),
          ),

          // ── Map area ──────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 0, 12, 8),
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
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.greenMid))
                      : filtered.isEmpty
                          ? _emptyMap()
                          : Stack(
                              children: [
                                // Grid
                                CustomPaint(
                                    painter: _GridPainter(),
                                    child: Container()),
                                // Roads
                                CustomPaint(
                                    painter: _RoadPainter(),
                                    child: Container()),

                                // Real GPS pins
                                ...filtered.map(
                                    (d) => _buildPin(d,
                                        filtered)),

                                // Legend
                                Positioned(
                                  bottom: 12, left: 12,
                                  child: Container(
                                    padding:
                                        const EdgeInsets
                                            .all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0.93),
                                      borderRadius:
                                          BorderRadius
                                              .circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors
                                                .black
                                                .withOpacity(
                                                    0.08),
                                            blurRadius: 8)
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        _legendItem(
                                            const Color(
                                                0xFFE74C3C),
                                            'High confidence disease'),
                                        const SizedBox(
                                            height: 4),
                                        _legendItem(
                                            AppColors.amber,
                                            'Moderate disease'),
                                        const SizedBox(
                                            height: 4),
                                        _legendItem(
                                            AppColors
                                                .greenBright,
                                            'Healthy crop'),
                                      ],
                                    ),
                                  ),
                                ),

                                // Compass
                                Positioned(
                                  top: 12, right: 12,
                                  child: Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0.9),
                                      shape:
                                          BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors
                                                .black
                                                .withOpacity(
                                                    0.1),
                                            blurRadius: 6)
                                      ],
                                    ),
                                    child: const Icon(
                                        Icons
                                            .explore_outlined,
                                        color: AppColors
                                            .greenMid,
                                        size: 20),
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ),
          ),

          _bottomNav(context),
        ],
      ),
    );
  }

  Widget _buildPin(
      Diagnosis d, List<Diagnosis> all) {
    final pos = _toRelativePosition(d, all);
    final color = _pinColor(d);
    final size  = _pinSize(d);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: pos['left']! * constraints.maxWidth -
              size / 2,
          top: pos['top']! * constraints.maxHeight - size,
          child: GestureDetector(
            onTap: () => _showPinDetail(context, d),
            child: Column(children: [
              Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8)
                  ],
                ),
                child: !d.isHealthy && size > 20
                    ? Center(
                        child: Text(
                          d.confidence
                              .toStringAsFixed(0),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight:
                                  FontWeight.w700),
                        ),
                      )
                    : null,
              ),
              Container(
                  width: 2,
                  height: 5,
                  color: Colors.black26),
            ]),
          ),
        );
      },
    );
  }

  void _showPinDetail(
      BuildContext context, Diagnosis d) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text(d.disease,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDeep)),
            const SizedBox(height: 4),
            Text('${d.crop} · ${d.confidence.toStringAsFixed(1)}% confidence',
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDim)),
            const SizedBox(height: 8),
            if (d.location != null)
              Row(children: [
                const Icon(Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textDim),
                const SizedBox(width: 4),
                Text(d.location!,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textDim)),
              ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenMid,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12)),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyMap() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined,
              size: 56,
              color: AppColors.textDim.withOpacity(0.4)),
          const SizedBox(height: 14),
          const Text('No GPS data yet',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMid)),
          const SizedBox(height: 6),
          const Text(
            'Scan a crop outdoors with location\nenabled to see pins here',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11,
                color: AppColors.textDim),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(
                context, AppRoutes.scan),
            icon: const Icon(
                Icons.camera_alt_outlined, size: 16),
            label: const Text('Scan a Crop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenMid,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
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
      (Icons.camera_alt_outlined,
          Icons.camera_alt_rounded, 'Scan', AppRoutes.scan),
      (Icons.location_on_outlined,
          Icons.location_on_rounded, 'Map', AppRoutes.map),
      (Icons.list_alt_outlined,
          Icons.list_alt_rounded, 'History',
          AppRoutes.history),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Color(0xFFE2EBE3))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == 2;
          return GestureDetector(
            onTap: () {
              if (!active)
                Navigator.pushReplacementNamed(
                    context, items[i].$4);
            },
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.greenLight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  active ? items[i].$2 : items[i].$1,
                  color: active
                      ? AppColors.greenMid
                      : AppColors.textDim,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(items[i].$3,
                  style: TextStyle(
                      fontSize: 9,
                      color: active
                          ? AppColors.greenMid
                          : AppColors.textDim,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.normal)),
            ]),
          );
        }),
      ),
    );
  }
}

// ── Painters ──────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDCE9DE)
      ..strokeWidth = 1;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y < size.height; y += step)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override bool shouldRepaint(_) => false;
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
  @override bool shouldRepaint(_) => false;
}