import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final List<String> _filters = ['All', 'Disease', 'Healthy'];
  final TextEditingController _searchController = TextEditingController();

  // Simulated diagnosis history data
  final List<_DiagnosisRecord> _records = [
    _DiagnosisRecord(
      crop: 'Maize',
      disease: 'Northern Leaf Blight',
      confidence: 94,
      date: 'Today, 9:41 AM',
      isHealthy: false,
      severity: 'High',
      location: 'Nairobi, Kenya',
      icon: Icons.grass_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Tomato',
      disease: 'Early Blight',
      confidence: 87,
      date: 'Today, 8:15 AM',
      isHealthy: false,
      severity: 'Moderate',
      location: 'Kiambu, Kenya',
      icon: Icons.eco_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Bean',
      disease: 'Healthy',
      confidence: 99,
      date: 'Yesterday, 3:22 PM',
      isHealthy: true,
      severity: 'None',
      location: 'Nakuru, Kenya',
      icon: Icons.spa_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Potato',
      disease: 'Late Blight',
      confidence: 91,
      date: 'Yesterday, 11:05 AM',
      isHealthy: false,
      severity: 'High',
      location: 'Meru, Kenya',
      icon: Icons.grass_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Wheat',
      disease: 'Healthy',
      confidence: 97,
      date: '2 days ago, 2:10 PM',
      isHealthy: true,
      severity: 'None',
      location: 'Eldoret, Kenya',
      icon: Icons.eco_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Cassava',
      disease: 'Mosaic Virus',
      confidence: 88,
      date: '3 days ago, 10:30 AM',
      isHealthy: false,
      severity: 'Moderate',
      location: 'Kisumu, Kenya',
      icon: Icons.spa_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Sorghum',
      disease: 'Healthy',
      confidence: 96,
      date: '4 days ago, 9:00 AM',
      isHealthy: true,
      severity: 'None',
      location: 'Machakos, Kenya',
      icon: Icons.grass_rounded,
    ),
    _DiagnosisRecord(
      crop: 'Rice',
      disease: 'Brown Spot',
      confidence: 83,
      date: '5 days ago, 4:45 PM',
      isHealthy: false,
      severity: 'Low',
      location: 'Mwea, Kenya',
      icon: Icons.eco_rounded,
    ),
  ];

  List<_DiagnosisRecord> get _filtered {
    return _records.where((r) {
      final matchFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Healthy' && r.isHealthy) ||
          (_selectedFilter == 'Disease' && !r.isHealthy);
      final matchSearch = _searchQuery.isEmpty ||
          r.crop.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.disease.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F0),
      body: Column(
        children: [

          // ── Header ───────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.greenDeep, AppColors.greenMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [

                  // Title row
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('Diagnosis History',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800)),
                          Text('All past crop diagnoses',
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11)),
                        ],
                      ),
                      // Total count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  Colors.white.withOpacity(0.2)),
                        ),
                        child: Text(
                          '${_records.length} Total',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search bar
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) =>
                          setState(() => _searchQuery = v),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Search crop or disease...',
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12),
                        prefixIcon: Icon(
                            Icons.search_rounded,
                            color:
                                Colors.white.withOpacity(0.6),
                            size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(
                                      () => _searchQuery = '');
                                },
                                child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white
                                        .withOpacity(0.6),
                                    size: 18),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(
                                vertical: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Summary stats
                  Row(children: [
                    _statChip(
                      Icons.warning_amber_rounded,
                      '${_records.where((r) => !r.isHealthy).length}',
                      'Diseases',
                      const Color(0xFFE74C3C),
                    ),
                    const SizedBox(width: 8),
                    _statChip(
                      Icons.check_circle_outline_rounded,
                      '${_records.where((r) => r.isHealthy).length}',
                      'Healthy',
                      AppColors.greenBright,
                    ),
                    const SizedBox(width: 8),
                    _statChip(
                      Icons.trending_up_rounded,
                      '91%',
                      'Avg Accuracy',
                      AppColors.amber,
                    ),
                  ]),
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
                        horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.greenMid
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.greenMid
                            : const Color(0xFFC5D9C7),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.greenMid
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
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

          // ── Records count ─────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Text(
                  '${filtered.length} record${filtered.length != 1 ? "s" : ""} found',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textDim,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // ── List ──────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        14, 0, 14, 14),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        _recordCard(context, filtered[i]),
                  ),
          ),

          // ── Bottom Nav ───────────────────────────
          _bottomNav(context),
        ],
      ),
    );
  }

  Widget _statChip(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 7, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
              color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                Text(label,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 8)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordCard(
      BuildContext context, _DiagnosisRecord record) {
    final dotColor = record.isHealthy
        ? AppColors.greenBright
        : record.severity == 'High'
            ? const Color(0xFFE74C3C)
            : record.severity == 'Moderate'
                ? AppColors.amber
                : const Color(0xFF3B82F6);

    return GestureDetector(
      onTap: () => _showDetail(context, record),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenDeep.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [

            // Icon box
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: record.isHealthy
                    ? AppColors.greenLight.withOpacity(0.5)
                    : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(record.icon,
                  color: record.isHealthy
                      ? AppColors.greenMid
                      : const Color(0xFFE74C3C),
                  size: 22),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(record.crop,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      // Confidence badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.greenMid
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(100),
                        ),
                        child: Text('${record.confidence}%',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.greenMid)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(record.disease,
                      style: TextStyle(
                          fontSize: 11,
                          color: record.isHealthy
                              ? AppColors.greenMid
                              : const Color(0xFFE74C3C),
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.access_time_rounded,
                        size: 10, color: AppColors.textDim),
                    const SizedBox(width: 3),
                    Text(record.date,
                        style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textDim)),
                    const SizedBox(width: 10),
                    Icon(Icons.location_on_outlined,
                        size: 10, color: AppColors.textDim),
                    const SizedBox(width: 3),
                    Text(record.location,
                        style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textDim)),
                  ]),
                ],
              ),
            ),

            // Severity dot + chevron
            Column(
              children: [
                CircleAvatar(
                    radius: 5, backgroundColor: dotColor),
                const SizedBox(height: 10),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textDim, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(
      BuildContext context, _DiagnosisRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: record.isHealthy
                      ? AppColors.greenLight.withOpacity(0.5)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(record.icon,
                    color: record.isHealthy
                        ? AppColors.greenMid
                        : const Color(0xFFE74C3C),
                    size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(record.crop,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.greenDeep)),
                    Text(record.disease,
                        style: TextStyle(
                            fontSize: 12,
                            color: record.isHealthy
                                ? AppColors.greenMid
                                : const Color(0xFFE74C3C),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      AppColors.greenMid.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${record.confidence}%',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenMid)),
              ),
            ]),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFEEF2EF)),
            const SizedBox(height: 14),

            // Detail rows
            _detailRow(Icons.calendar_today_outlined,
                'Date', record.date),
            const SizedBox(height: 10),
            _detailRow(Icons.location_on_outlined,
                'Location', record.location),
            const SizedBox(height: 10),
            _detailRow(Icons.warning_amber_rounded,
                'Severity', record.severity),
            const SizedBox(height: 20),

            // Confidence bar
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text('Confidence Score',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textDim)),
                Text('${record.confidence}%',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenMid)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: record.confidence / 100,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5F0E8),
                valueColor: const AlwaysStoppedAnimation(
                    AppColors.greenBright),
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded,
                      size: 16),
                  label: const Text('Close'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textMid,
                    side: const BorderSide(
                        color: Color(0xFFDDE8DF), width: 1.5),
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
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, AppRoutes.result);
                  },
                  icon: const Icon(
                      Icons.visibility_outlined,
                      size: 16),
                  label: const Text('View Full'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenMid,
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
      IconData icon, String label, String value) {
    return Row(children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.greenLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(9),
        ),
        child:
            Icon(icon, color: AppColors.greenMid, size: 16),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9, color: AppColors.textDim)),
        Text(value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
      ]),
    ]);
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded,
              size: 64,
              color: AppColors.textDim.withOpacity(0.4)),
          const SizedBox(height: 14),
          const Text('No records found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMid)),
          const SizedBox(height: 6),
          const Text('Try a different filter or search term',
              style: TextStyle(
                  fontSize: 11, color: AppColors.textDim)),
        ],
      ),
    );
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
        border:
            Border(top: BorderSide(color: Color(0xFFE2EBE3))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == 3;
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

// ── Data model ────────────────────────────────────────────
class _DiagnosisRecord {
  final String crop;
  final String disease;
  final int confidence;
  final String date;
  final bool isHealthy;
  final String severity;
  final String location;
  final IconData icon;

  const _DiagnosisRecord({
    required this.crop,
    required this.disease,
    required this.confidence,
    required this.date,
    required this.isHealthy,
    required this.severity,
    required this.location,
    required this.icon,
  });
}