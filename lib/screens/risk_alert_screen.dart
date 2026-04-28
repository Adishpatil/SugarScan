import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/disease_data.dart';
import '../models/risk_data.dart';
import '../services/language_service.dart';

class RiskAlertScreen extends StatefulWidget {
  const RiskAlertScreen({super.key});
  @override
  State<RiskAlertScreen> createState() => _RiskAlertScreenState();
}

class _RiskAlertScreenState extends State<RiskAlertScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedMonth;
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now().month;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
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
            title: Text(S.diseaseInfo),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Disease Encyclopedia ──
                _buildSectionTitle(S.diseaseInfo),
                const SizedBox(height: 12),
                _buildDiseaseEncyclopedia(),

                const SizedBox(height: 28),

                // ── Seasonal Risk Calendar ──
                _buildSectionTitle(S.seasonalRisk),
                const SizedBox(height: 12),
                _buildMonthSelector(),
                const SizedBox(height: 16),
                _buildMonthRiskDetail(),

                const SizedBox(height: 28),

                // ── Preventive Actions ──
                _buildSectionTitle(S.preventiveActions),
                const SizedBox(height: 12),
                _buildPreventiveActions(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ── Disease Encyclopedia ──
  Widget _buildDiseaseEncyclopedia() {
    return Column(
      children: diseaseDatabase.entries.map((entry) {
        final info = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: info.color.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: info.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(info.emoji,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                title: Text(
                  info.localName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: info.color,
                    fontSize: 15,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: info.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${S.severity}: ${info.localSeverity}',
                        style: GoogleFonts.inter(
                          color: info.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                iconColor: AppColors.textMuted,
                collapsedIconColor: AppColors.textMuted,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: 8),
                        _infoSection(S.description, info.localDescription,
                            Icons.info_outline_rounded, info.color),
                        _infoSection(S.symptoms, info.localSymptoms,
                            Icons.visibility_rounded, info.color),
                        _infoSection(S.cause, info.localCause,
                            Icons.bug_report_rounded, info.color),
                        _infoSection(S.treatment, info.localTreatment,
                            Icons.medical_services_rounded, info.color),
                        _infoSection(S.prevention, info.localPrevention,
                            Icons.verified_user_rounded, info.color),
                        _fieldTipBox(info.localFieldTips, info.color),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _infoSection(
      String title, String content, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Text(content,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.6,
              )),
        ],
      ),
    );
  }

  Widget _fieldTipBox(String tip, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(tip,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                )),
          ),
        ],
      ),
    );
  }

  // ── Month Selector ──
  Widget _buildMonthSelector() {
    final months = List.generate(12, (i) => i + 1);
    final now = DateTime.now().month;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, i) {
          final month = months[i];
          final isSelected = month == _selectedMonth;
          final isCurrent = month == now;
          final monthName =
              DateFormat.MMM().format(DateTime(2024, month));

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedMonth = month),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isCurrent
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isCurrent
                            ? AppColors.primary.withOpacity(0.4)
                            : AppColors.divider,
                  ),
                ),
                child: Center(
                  child: Text(
                    monthName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isCurrent
                              ? AppColors.primary
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Monthly Risk Details ──
  Widget _buildMonthRiskDetail() {
    final monthRisk = monthlyRiskData.firstWhere(
      (r) => r.month == _selectedMonth,
      orElse: () => monthlyRiskData[0],
    );

    final riskColors = [
      AppColors.primary,
      AppColors.warning,
      AppColors.error,
      const Color(0xFFD32F2F),
    ];

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
          // Tip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    monthRisk.localTip,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Risk bars
          ...monthRisk.diseaseRisk.entries.map((e) {
            final info = diseaseDatabase[e.key];
            final riskLevel = e.value.clamp(0, 3);
            final barColor = riskColors[riskLevel];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(info?.emoji ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            info?.localName ?? e.key,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: barColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          riskLabel(riskLevel),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: barColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (riskLevel + 1) / 4,
                      backgroundColor: AppColors.surfaceBright,
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      minHeight: 8,
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

  // ── Preventive Actions ──
  Widget _buildPreventiveActions() {
    return Column(
      children: preventiveActions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.localAction,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            action.localTiming,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}
