import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../database/db_provider.dart';
import '../../database/local_database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter      = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl =
      TextEditingController();
  final List<String> _filters = ['All', 'Disease', 'Healthy'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────

  String _formatDate(DateTime dt) {
    final now  = DateTime.now();
    final diff = now.difference(dt);
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';

    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inHours  < 1)  return '${diff.inMinutes}m ago';
    if (diff.inDays   < 1)  return 'Today, $time';
    if (diff.inDays  == 1)  return 'Yesterday, $time';
    if (diff.inDays   < 7)  return '${diff.inDays} days ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Color _severityColor(Diagnosis d) {
    if (d.isHealthy)            return AppColors.greenBright;
    if (d.confidence >= 90)     return const Color(0xFFE74C3C);
    if (d.confidence >= 70)     return AppColors.amber;
    return const Color(0xFF3B82F6);
  }

  String _severityLabel(Diagnosis d) {
    if (d.isHealthy)        return 'None';
    if (d.confidence >= 90) return 'High';
    if (d.confidence >= 70) return 'Moderate';
    return 'Low';
  }

  List<Diagnosis> _applyFilters(List<Diagnosis> all) {
    return all.where((d) {
      final matchFilter =
          _filter == 'All'      ||
          (_filter == 'Healthy' && d.isHealthy) ||
          (_filter == 'Disease' && !d.isHealthy);

      final q = _searchQuery.toLowerCase();
      final matchSearch =
          q.isEmpty                              ||
          d.crop.toLowerCase().contains(q)       ||
          d.disease.toLowerCase().contains(q)    ||
          (d.location?.toLowerCase().contains(q) ?? false);

      return matchFilter && matchSearch;
    }).toList();
  }

  // ── Build ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F0),
      body: StreamBuilder<List<Diagnosis>>(
        stream: DBProvider.db.diagnosisDao.watchAllDiagnoses(),
        builder: (context, snapshot) {
          final allDiagnoses = snapshot.data ?? [];
          final filtered = _applyFilters(allDiagnoses);
          final diseaseCount =
              allDiagnoses.where((d) => !d.isHealthy).length;
          final healthyCount =
              allDiagnoses.where((d) => d.isHealthy).length;
          final avgConf = allDiagnoses.isEmpty
              ? 0.0
              : allDiagnoses.fold<double>(
                      0, (s, d) => s + d.confidence) /
                  allDiagnoses.length;

          return Column(
            children: [

              // ── Header ─────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 16),
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
                    bottomLeft:  Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [

                      // Title + count
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
                                      fontWeight:
                                          FontWeight.w800)),
                              Text('All past crop diagnoses',
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 11)),
                            ],
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                              border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              '${allDiagnoses.length} Total',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Search bar
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color:
                              Colors.white.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.2)),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(
                              () => _searchQuery = v),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13),
                          decoration: InputDecoration(
                            hintText:
                                'Search crop or disease...',
                            hintStyle: TextStyle(
                                color: Colors.white
                                    .withValues(alpha: 0.5),
                                fontSize: 12),
                            prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.white
                                    .withValues(alpha: 0.6),
                                size: 20),
                            suffixIcon:
                                _searchQuery.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchCtrl
                                              .clear();
                                          setState(() =>
                                              _searchQuery =
                                                  '');
                                        },
                                        child: Icon(
                                            Icons
                                                .close_rounded,
                                            color: Colors
                                                .white
                                                .withValues(
                                                    alpha: 0.6),
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

                      // Stats row
                      Row(children: [
                        _statChip(
                            Icons.warning_amber_rounded,
                            '$diseaseCount',
                            'Diseases',
                            const Color(0xFFE74C3C)),
                        const SizedBox(width: 8),
                        _statChip(
                            Icons.check_circle_outline_rounded,
                            '$healthyCount',
                            'Healthy',
                            AppColors.greenBright),
                        const SizedBox(width: 8),
                        _statChip(
                            Icons.trending_up_rounded,
                            '${avgConf.toStringAsFixed(0)}%',
                            'Avg Conf',
                            AppColors.amber),
                      ]),
                    ],
                  ),
                ),
              ),

              // ── Filters ────────────────────────────
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final sel = _filters[i] == _filter;
                    return GestureDetector(
                      onTap: () => setState(
                          () => _filter = _filters[i]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.greenMid
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(100),
                          border: Border.all(
                              color: sel
                                  ? AppColors.greenMid
                                  : const Color(
                                      0xFFC5D9C7),
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

              // ── Count label ────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 8),
                child: Row(children: [
                  Text(
                    '${filtered.length} record'
                    '${filtered.length != 1 ? "s" : ""} found',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textDim),
                  ),
                ]),
              ),

              // ── List ───────────────────────────────
              Expanded(
                child: snapshot.connectionState ==
                        ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.greenMid))
                    : filtered.isEmpty
                        ? _emptyState(allDiagnoses.isEmpty)
                        : ListView.separated(
                            padding:
                                const EdgeInsets.fromLTRB(
                                    14, 0, 14, 14),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (ctx, i) =>
                                _diagnosisCard(
                                    ctx, filtered[i]),
                          ),
              ),

              // ── Bottom Nav ─────────────────────────
              _bottomNav(context),
            ],
          );
        },
      ),
    );
  }

  // ── Card ──────────────────────────────────────────────

  Widget _diagnosisCard(BuildContext context, Diagnosis d) {
    final dotColor = _severityColor(d);

    return GestureDetector(
      onTap: () => _showDetail(context, d),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenDeep.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(children: [

          // Icon
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: d.isHealthy
                  ? AppColors.greenLight.withValues(alpha: 0.5)
                  : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              d.isHealthy
                  ? Icons.eco_rounded
                  : Icons.grass_rounded,
              color: d.isHealthy
                  ? AppColors.greenMid
                  : const Color(0xFFE74C3C),
              size: 22,
            ),
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
                    Text(d.crop,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.greenMid
                            .withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${d.confidence.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenMid),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(d.disease,
                    style: TextStyle(
                        fontSize: 11,
                        color: d.isHealthy
                            ? AppColors.greenMid
                            : const Color(0xFFE74C3C),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Row(children: [
                  const Icon(Icons.access_time_rounded,
                      size: 10, color: AppColors.textDim),
                  const SizedBox(width: 3),
                  Text(_formatDate(d.timestamp),
                      style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textDim)),
                  if (d.location != null) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_outlined,
                        size: 10, color: AppColors.textDim),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        d.location!,
                        style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textDim),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ]),
              ],
            ),
          ),

          // Right side
          Column(children: [
            CircleAvatar(radius: 5, backgroundColor: dotColor),
            const SizedBox(height: 10),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textDim, size: 18),
          ]),
        ]),
      ),
    );
  }

  // ── Detail bottom sheet ───────────────────────────────

  void _showDetail(BuildContext context, Diagnosis d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
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
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),

            // Header
            Row(children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: d.isHealthy
                      ? AppColors.greenLight.withValues(alpha: 0.5)
                      : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                    d.isHealthy
                        ? Icons.eco_rounded
                        : Icons.grass_rounded,
                    color: d.isHealthy
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
                    Text(d.crop,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.greenDeep)),
                    Text(d.disease,
                        style: TextStyle(
                            fontSize: 12,
                            color: d.isHealthy
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
                  color: AppColors.greenMid.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${d.confidence.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.greenMid),
                ),
              ),
            ]),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFEEF2EF)),
            const SizedBox(height: 14),

            _detailRow(Icons.calendar_today_outlined,
                'Date', _formatDate(d.timestamp)),
            const SizedBox(height: 10),
            _detailRow(
                Icons.location_on_outlined,
                'Location',
                d.location ?? 'Not recorded'),
            const SizedBox(height: 10),
            _detailRow(Icons.warning_amber_rounded,
                'Severity', _severityLabel(d)),
            const SizedBox(height: 10),
            _detailRow(Icons.sync_rounded, 'Sync Status',
                d.isSynced ? 'Synced ✓' : 'Pending sync'),

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
                Text(
                  '${d.confidence.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.greenMid),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: d.confidence / 100,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5F0E8),
                valueColor: const AlwaysStoppedAnimation(
                    AppColors.greenBright),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
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
            ]),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────

  Widget _statChip(IconData icon, String value, String label,
      Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 7, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.1)),
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
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 8)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
      IconData icon, String label, String value) {
    return Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: AppColors.greenLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon,
            color: AppColors.greenMid, size: 16),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9, color: AppColors.textDim)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ],
      ),
    ]);
  }

  Widget _emptyState(bool noDataAtAll) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded,
              size: 64,
              color: AppColors.textDim.withValues(alpha: 0.3)),
          const SizedBox(height: 14),
          Text(
            noDataAtAll
                ? 'No diagnoses yet'
                : 'No records found',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textMid),
          ),
          const SizedBox(height: 6),
          Text(
            noDataAtAll
                ? 'Go scan a crop to get started'
                : 'Try a different filter or search term',
            style: const TextStyle(
                fontSize: 11, color: AppColors.textDim),
          ),
          if (noDataAtAll) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, AppRoutes.scan),
              icon: const Icon(Icons.camera_alt_outlined,
                  size: 16),
              label: const Text('Scan a Crop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenMid,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      ),
    );
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
          final active = i == 3;
          return GestureDetector(
            onTap: () {
              if (!active) {
                Navigator.pushReplacementNamed(
                    context, items[i].$4);
              }
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