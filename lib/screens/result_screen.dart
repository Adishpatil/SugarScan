import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/classifier.dart';
import '../main.dart';
import '../models/disease_data.dart';
import '../services/language_service.dart';

class ResultScreen extends StatefulWidget {
  final File imageFile;
  const ResultScreen({super.key, required this.imageFile});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  final Classifier _classifier = Classifier();
  ClassifierResult? _result;
  bool _isLoading = true;
  String? _error;
  bool _saved = false;
  late AnimationController _loadAnim;
  late AnimationController _resultAnim;

  @override
  void initState() {
    super.initState();
    _loadAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _resultAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _runPrediction();
  }

  Future<void> _runPrediction() async {
    try {
      await _classifier.loadModel();
      final result = await _classifier.predict(widget.imageFile);
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
        _loadAnim.stop();
        _resultAnim.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveToHistory() async {
    if (_result == null || _saved) return;
    final box = Hive.box('history');
    await box.add({
      'id': const Uuid().v4(),
      'label': _result!.label,
      'confidence': _result!.confidence,
      'imagePath': widget.imageFile.path,
      'timestamp': DateTime.now().toIso8601String(),
    });
    if (mounted) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary),
              const SizedBox(width: 8),
              Text(S.saved),
            ],
          ),
          backgroundColor: AppColors.surfaceLight,
        ),
      );
    }
  }

  Future<void> _shareResult() async {
    if (_result == null) return;
    final info = diseaseDatabase[_result!.label];
    final pct = (_result!.confidence * 100).toStringAsFixed(1);
    final text = '${S.appName} - ${S.detectionResult}\n\n'
        '${info?.localName ?? _result!.label}\n'
        '${S.confidence}: $pct%\n'
        '${S.severity}: ${info?.localSeverity ?? "N/A"}\n\n'
        '${info?.localDescription ?? ""}\n\n'
        '${S.treatment}:\n${info?.localTreatment ?? ""}';
    await Share.share(text);
  }

  @override
  void dispose() {
    _classifier.dispose();
    _loadAnim.dispose();
    _resultAnim.dispose();
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
            title: Text(S.detectionResult),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _isLoading
              ? _buildLoading()
              : _error != null
                  ? _buildError()
                  : _buildResult(),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated leaf scanner
          AnimatedBuilder(
            animation: _loadAnim,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: _loadAnim.value * 2 * math.pi,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.0),
                            AppColors.primary,
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Text('🌿',
                      style: TextStyle(fontSize: 48)),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          Text(S.analyzing,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: 8),
          Text(S.running8passes,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textMuted,
              )),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 56),
            ),
            const SizedBox(height: 20),
            Text(S.detectionFailed,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
            const SizedBox(height: 10),
            Text(_error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(S.goBack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final info = diseaseDatabase[_result!.label]!;
    final color = info.color;
    final pct = (_result!.confidence * 100).toStringAsFixed(1);

    return FadeTransition(
      opacity: _resultAnim,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            // ── Image ──
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.file(widget.imageFile,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Result Card ──
            _buildResultCard(info, color, pct),
            const SizedBox(height: 16),

            // ── Confidence Gauge ──
            _buildConfidenceGauge(color),
            const SizedBox(height: 16),

            // ── All Probabilities ──
            _buildProbabilities(color),
            const SizedBox(height: 16),

            // ── Disease Details ──
            _buildDiseaseDetails(info),
            const SizedBox(height: 20),

            // ── Action Buttons ──
            _buildActionButtons(info, pct),
            const SizedBox(height: 12),

            // ── Debug Info (collapsible) ──
            if (_result!.debugInfo.isNotEmpty) _buildDebugInfo(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(DiseaseInfo info, Color color, String pct) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Text(info.emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 10),
          Text(
            info.localName,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${S.confidence}: $pct%',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${S.severity}: ${info.localSeverity}',
              style: GoogleFonts.poppins(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceGauge(Color color) {
    final confidence = _result!.confidence;
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
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: confidence),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CustomPaint(
                  painter: _GaugePainter(
                    value: value,
                    color: color,
                    bgColor: AppColors.surfaceBright,
                  ),
                  child: Center(
                    child: Text(
                      '${(value * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(S.confidence,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textMuted,
              )),
        ],
      ),
    );
  }

  Widget _buildProbabilities(Color topColor) {
    final sorted = _result!.allProbabilities.entries.toList()
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
          Text(S.allProbs,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: 14),
          ...sorted.map((e) {
            final isTop = e.key == _result!.label;
            final info = diseaseDatabase[e.key];
            final barColor = isTop ? topColor : AppColors.textMuted;
            final pctVal = (e.value * 100).toStringAsFixed(1);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                              fontWeight: isTop
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: isTop
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Text('$pctVal%',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: isTop
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                            fontSize: 13,
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: e.value),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, val, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: val.clamp(0.0, 1.0),
                          backgroundColor: AppColors.surfaceBright,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(barColor),
                          minHeight: 8,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDiseaseDetails(DiseaseInfo info) {
    final sections = [
      (S.description, info.localDescription, Icons.info_outline_rounded),
      (S.symptoms, info.localSymptoms, Icons.visibility_rounded),
      (S.cause, info.localCause, Icons.bug_report_rounded),
      (S.treatment, info.localTreatment, Icons.medical_services_rounded),
      (S.prevention, info.localPrevention, Icons.verified_user_rounded),
      (S.fieldTips, info.localFieldTips, Icons.lightbulb_rounded),
    ];

    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Icon(Icons.menu_book_rounded,
                    color: info.color, size: 20),
                const SizedBox(width: 8),
                Text(S.diseaseInfoTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          ...sections.map((s) {
            return Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: Icon(s.$3, color: info.color, size: 20),
                title: Text(s.$1,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                iconColor: AppColors.textMuted,
                collapsedIconColor: AppColors.textMuted,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Text(s.$2,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        )),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DiseaseInfo info, String pct) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saved ? null : _saveToHistory,
            icon: Icon(_saved
                ? Icons.check_rounded
                : Icons.bookmark_add_rounded),
            label: Text(_saved ? S.saved : S.saveHistory),
            style: ElevatedButton.styleFrom(
              backgroundColor: _saved
                  ? AppColors.surfaceBright
                  : AppColors.primary,
              foregroundColor:
                  _saved ? AppColors.textMuted : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _shareResult,
            icon: const Icon(Icons.share_rounded),
            label: Text(S.shareResult),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side:
                  const BorderSide(color: AppColors.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugInfo() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text('Debug Info',
            style: GoogleFonts.inter(
              fontSize: 12, color: AppColors.textMuted)),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              _result!.debugInfo,
              style: GoogleFonts.firaCode(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Circular gauge painter ───
class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color bgColor;

  _GaugePainter({
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background arc
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5 * value.clamp(0.0, 1.0),
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.value != value || old.color != color;
}
