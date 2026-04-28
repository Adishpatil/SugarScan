import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import '../main.dart';
import '../models/disease_data.dart';
import '../services/language_service.dart';

class FarmJournalScreen extends StatefulWidget {
  const FarmJournalScreen({super.key});
  @override
  State<FarmJournalScreen> createState() => _FarmJournalScreenState();
}

class _FarmJournalScreenState extends State<FarmJournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(S.farmJournal),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: S.farmJournal, icon: const Icon(Icons.book_rounded, size: 18)),
                Tab(text: S.scanTrends, icon: const Icon(Icons.analytics_rounded, size: 18)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabCtrl,
            children: const [
              _JournalTab(),
              _TrendsTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEntryDialog(context),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        );
      },
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final fieldCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedStage = 'planting';

    final stages = {
      'planting': S.stagePlanting,
      'tillering': S.stageTillering,
      'grand_growth': S.stageGrandGrowth,
      'maturity': S.stageMaturity,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textMuted,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(S.addEntry,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        )),
                    const SizedBox(height: 20),

                    // Field Name
                    Text(S.fieldName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        )),
                    const SizedBox(height: 8),
                    TextField(
                      controller: fieldCtrl,
                      style: GoogleFonts.inter(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: LanguageService().t3(
                          'e.g. North Field, Plot 3',
                          'जैसे: उत्तर खेत, प्लॉट 3',
                          'उदा: उत्तर शेत, प्लॉट 3',
                        ),
                        hintStyle: GoogleFonts.inter(
                            color: AppColors.textMuted, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Crop Stage
                    Text(S.cropStage,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        )),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: stages.entries.map((e) {
                        final isSelected = selectedStage == e.key;
                        return GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedStage = e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.15)
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              e.value,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    Text(S.observations,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        )),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 3,
                      style: GoogleFonts.inter(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: LanguageService().t3(
                          'What did you observe in the field today?',
                          'आज खेत में आपने क्या देखा?',
                          'आज शेतात काय निरीक्षण केले?',
                        ),
                        hintStyle: GoogleFonts.inter(
                            color: AppColors.textMuted, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.surfaceBright,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (fieldCtrl.text.trim().isEmpty) return;
                          final box = Hive.box('journal');
                          box.add({
                            'id': const Uuid().v4(),
                            'fieldName': fieldCtrl.text.trim(),
                            'stage': selectedStage,
                            'notes': notesCtrl.text.trim(),
                            'timestamp': DateTime.now().toIso8601String(),
                          });
                          Navigator.pop(ctx);
                          setState(() {});
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: Text(S.save),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ================================================================
//  JOURNAL TAB
// ================================================================
class _JournalTab extends StatelessWidget {
  const _JournalTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('journal').listenable(),
      builder: (context, Box box, _) {
        final entries = box.values.toList().reversed.toList();

        if (entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_rounded,
                      size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text(S.noFieldsYet,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textMuted,
                      )),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final entry = entries[i] as Map;
            return _JournalCard(entry: entry, box: box, index: i,
                totalEntries: entries.length);
          },
        );
      },
    );
  }
}

class _JournalCard extends StatelessWidget {
  final Map entry;
  final Box box;
  final int index;
  final int totalEntries;

  const _JournalCard({
    required this.entry,
    required this.box,
    required this.index,
    required this.totalEntries,
  });

  String _stageLabel(String stage) {
    switch (stage) {
      case 'planting': return S.stagePlanting;
      case 'tillering': return S.stageTillering;
      case 'grand_growth': return S.stageGrandGrowth;
      case 'maturity': return S.stageMaturity;
      default: return stage;
    }
  }

  String _stageEmoji(String stage) {
    switch (stage) {
      case 'planting': return '🌱';
      case 'tillering': return '🌿';
      case 'grand_growth': return '🎋';
      case 'maturity': return '🌾';
      default: return '📝';
    }
  }

  Color _stageColor(String stage) {
    switch (stage) {
      case 'planting': return const Color(0xFF81C784);
      case 'tillering': return const Color(0xFF4CAF50);
      case 'grand_growth': return const Color(0xFF2E7D32);
      case 'maturity': return const Color(0xFFFFC107);
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = entry['stage'] ?? 'planting';
    final color = _stageColor(stage);

    String dateStr = '';
    try {
      dateStr = DateFormat('dd MMM yyyy, hh:mm a')
          .format(DateTime.parse(entry['timestamp']));
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(_stageEmoji(stage),
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['fieldName'] ?? '',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _stageLabel(stage),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(dateStr,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textMuted, size: 18),
                    onPressed: () {
                      final keys = box.keys.toList().reversed.toList();
                      if (index < keys.length) {
                        box.delete(keys[index]);
                      }
                    },
                  ),
                ],
              ),
              if ((entry['notes'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry['notes'],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
//  TRENDS TAB
// ================================================================
class _TrendsTab extends StatelessWidget {
  const _TrendsTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('history').listenable(),
      builder: (context, Box box, _) {
        final scans = box.values
            .where((v) => v is Map && v.containsKey('label'))
            .cast<Map>()
            .toList();

        if (scans.length < 2) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_rounded,
                      size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    LanguageService().t3(
                      'Scan at least 2 leaves to see trends',
                      'ट्रेंड देखने के लिए कम से कम 2 पत्तियां स्कैन करें',
                      'ट्रेंड पाहण्यासाठी किमान 2 पाने स्कॅन करा',
                    ),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Health Overview ──
              _buildHealthOverview(scans),
              const SizedBox(height: 20),

              // ── Disease Distribution Pie ──
              _buildDistributionChart(scans),
              const SizedBox(height: 20),

              // ── Share Button ──
              _buildShareButton(context, scans),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHealthOverview(List<Map> scans) {
    final total = scans.length;
    final healthyCount =
        scans.where((s) => s['label'] == 'Healthy').length;
    final diseasedCount = total - healthyCount;
    final healthRate =
        total > 0 ? (healthyCount / total * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.healthOverview,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              _overviewStat(
                label: S.totalScans,
                value: '$total',
                color: const Color(0xFF3498DB),
                icon: Icons.analytics_rounded,
              ),
              const SizedBox(width: 10),
              _overviewStat(
                label: S.healthy,
                value: '$healthyCount',
                color: AppColors.primary,
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(width: 10),
              _overviewStat(
                label: S.diseases,
                value: '$diseasedCount',
                color: AppColors.error,
                icon: Icons.warning_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Health rate bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LanguageService().t3(
                      'Health Rate',
                      'स्वास्थ्य दर',
                      'आरोग्य दर',
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$healthRate%',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total > 0 ? healthyCount / total : 0,
                  backgroundColor: AppColors.error.withOpacity(0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${S.healthy}: $healthyCount',
                      style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.primary)),
                  Text('${S.diseases}: $diseasedCount',
                      style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.error)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewStat({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
            Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: color.withOpacity(0.8),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionChart(List<Map> scans) {
    // Count by disease
    final counts = <String, int>{};
    for (final scan in scans) {
      final label = scan['label'] as String;
      counts[label] = (counts[label] ?? 0) + 1;
    }

    final total = scans.length;
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LanguageService().t3(
              'Disease Distribution',
              'रोग वितरण',
              'रोग वितरण',
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: entries.map((e) {
                  final info = diseaseDatabase[e.key];
                  final color = info?.color ?? AppColors.textMuted;
                  final pct = (e.value / total * 100).toStringAsFixed(0);
                  return PieChartSectionData(
                    value: e.value.toDouble(),
                    color: color,
                    title: '$pct%',
                    titleStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    radius: 50,
                    titlePositionPercentageOffset: 0.55,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          ...entries.map((e) {
            final info = diseaseDatabase[e.key];
            final color = info?.color ?? AppColors.textMuted;
            final pct = (e.value / total * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    info?.localName ?? e.key,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${e.value} ($pct%)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildShareButton(BuildContext context, List<Map> scans) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _exportAndShare(context, scans),
        icon: const Icon(Icons.share_rounded),
        label: Text(S.exportSummary),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _exportAndShare(BuildContext context, List<Map> scans) {
    final total = scans.length;
    final healthyCount =
        scans.where((s) => s['label'] == 'Healthy').length;

    // Count by disease
    final counts = <String, int>{};
    for (final scan in scans) {
      final label = scan['label'] as String;
      counts[label] = (counts[label] ?? 0) + 1;
    }

    final buffer = StringBuffer();
    buffer.writeln('${S.appName} - ${S.healthOverview}');
    buffer.writeln('${'=' * 30}');
    buffer.writeln('${S.totalScans}: $total');
    buffer.writeln('${S.healthy}: $healthyCount');
    buffer.writeln('${S.diseases}: ${total - healthyCount}');
    buffer.writeln('');
    buffer.writeln(LanguageService().t3(
      'Disease Breakdown:',
      'रोग विवरण:',
      'रोग तपशील:',
    ));
    counts.forEach((label, count) {
      final info = diseaseDatabase[label];
      final pct = (count / total * 100).toStringAsFixed(1);
      buffer.writeln('  ${info?.emoji ?? ""} '
          '${info?.localName ?? label}: $count ($pct%)');
    });
    buffer.writeln('');
    buffer.writeln(LanguageService().t3(
      'Generated by SugarScan App',
      'SugarScan ऐप द्वारा बनाया गया',
      'SugarScan अॅपद्वारे तयार',
    ));

    Share.share(buffer.toString());
  }
}
