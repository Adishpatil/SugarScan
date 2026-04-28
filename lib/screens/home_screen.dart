import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/disease_data.dart';
import '../models/risk_data.dart';
import '../services/language_service.dart';
import 'result_screen.dart';
import 'risk_alert_screen.dart';
import 'farm_journal_screen.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(context),
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              _HomeTab(),
              _HistoryTab(),
              RiskAlertScreen(),
              FarmJournalScreen(),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final lang = LanguageService();
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('🌿', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 14),
                  Text(S.appName,
                      style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(S.tagline,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Language Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.translate_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Text(S.language, style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
            ),
            ...LanguageService.supportedCodes.map((code) {
              final isSelected = lang.langCode == code;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => lang.setLanguage(code),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primarySurface : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8,
                              color: isSelected ? AppColors.primary : AppColors.textMuted),
                          const SizedBox(width: 12),
                          Text(LanguageService.languageNames[code]!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              )),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Divider(color: AppColors.divider),
            ),

            // About
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
              title: Text(S.aboutApp, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Row(children: [
                      const Text('🌿', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(S.appName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ]),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(S.aboutDescription, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
                      const SizedBox(height: 16),
                      Text(S.madeWithLove, style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(S.versionLabel, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                    ]),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(S.ok))],
                  ),
                );
              },
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                Text(S.madeWithLove, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(height: 4),
                Text(S.versionLabel, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(Icons.home_rounded, S.home),
      _NavItem(Icons.history_rounded, S.history),
      _NavItem(Icons.menu_book_rounded, S.guide),
      _NavItem(Icons.book_rounded, S.journal),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = _currentIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 16 : 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primarySurface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].icon,
                        size: 22,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Text(
                          items[i].label,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

// ================================================================
//  HOME TAB
// ================================================================
class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 95);
    if (picked != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(imageFile: File(picked.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  _buildHeader(),
                  const SizedBox(height: 28),

                  // ── Scan Buttons ──
                  _buildSectionTitle(S.selectImage),
                  const SizedBox(height: 14),
                  _buildScanButton(
                    icon: Icons.camera_alt_rounded,
                    label: S.takePhoto,
                    subtitle: S.takePhotoSub,
                    gradient: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
                    onTap: () => _pickImage(context, ImageSource.camera),
                    delay: 0.0,
                  ),
                  const SizedBox(height: 12),
                  _buildScanButton(
                    icon: Icons.photo_library_rounded,
                    label: S.chooseGallery,
                    subtitle: S.chooseGallerySub,
                    gradient: const [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                    onTap: () => _pickImage(context, ImageSource.gallery),
                    delay: 0.1,
                  ),

                  const SizedBox(height: 28),

                  // ── Stats Dashboard ──
                  _buildStats(),

                  const SizedBox(height: 28),

                  // ── Risk Summary ──
                  _buildRiskSummary(),

                  const SizedBox(height: 28),

                  // ── Quick Tips ──
                  _buildQuickTips(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut)),
      child: FadeTransition(
        opacity: _anim,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Hamburger menu button
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_rounded, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🌿', style: TextStyle(fontSize: 26)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            S.appName,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.tagline,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
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

  // Language picker removed — now in the drawer

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildScanButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
    required double delay,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _anim,
        curve: Interval(delay, delay + 0.6, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _anim,
          curve: Interval(delay, delay + 0.6),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(height: 2),
                          Text(subtitle,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white54, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('history').listenable(),
      builder: (context, Box box, _) {
        final scans = box.values
            .where((v) => v is Map && v.containsKey('label'))
            .toList();
        final total = scans.length;
        final diseased =
            scans.where((v) => (v as Map)['label'] != 'Healthy').length;
        final healthy = total - diseased;

        return Row(
          children: [
            _StatCard(
              label: S.totalScans,
              value: '$total',
              icon: Icons.analytics_rounded,
              color: const Color(0xFF3498DB),
            ),
            const SizedBox(width: 10),
            _StatCard(
              label: S.diseases,
              value: '$diseased',
              icon: Icons.warning_rounded,
              color: AppColors.error,
            ),
            const SizedBox(width: 10),
            _StatCard(
              label: S.healthy,
              value: '$healthy',
              icon: Icons.check_circle_rounded,
              color: AppColors.primary,
            ),
          ],
        );
      },
    );
  }

  Widget _StatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
            Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: color.withOpacity(0.8),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskSummary() {
    final now = DateTime.now();
    final monthRisk = monthlyRiskData.firstWhere(
      (r) => r.month == now.month,
      orElse: () => monthlyRiskData[0],
    );

    // Find the highest risk this month
    int maxRisk = 0;
    String maxDisease = '';
    monthRisk.diseaseRisk.forEach((disease, level) {
      if (level > maxRisk) {
        maxRisk = level;
        maxDisease = disease;
      }
    });

    final riskColors = [
      AppColors.primary,
      AppColors.warning,
      AppColors.error,
      const Color(0xFFD32F2F),
    ];
    final riskColor = riskColors[maxRisk.clamp(0, 3)];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: riskColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: riskColor, size: 22),
              const SizedBox(width: 8),
              Text(
                S.currentRisk,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: riskColor,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  riskLabel(maxRisk),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: riskColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            monthRisk.localTip,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Mini risk bars for each disease
          ...monthRisk.diseaseRisk.entries.map((e) {
            final info = diseaseDatabase[e.key];
            final barColor = riskColors[e.value.clamp(0, 3)];
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      info?.localName ?? e.key,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (e.value + 1) / 4,
                        backgroundColor: AppColors.surfaceBright,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    riskLabel(e.value),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: barColor,
                      fontWeight: FontWeight.w600,
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

  Widget _buildQuickTips() {
    final l = LanguageService();
    final tips = [
      {
        'icon': '📸',
        'text': l.t3(
          'Photograph the leaf flat, in natural daylight for best results',
          'सबसे अच्छे परिणाम के लिए पत्ती को सपाट, प्राकृतिक रोशनी में फोटो खींचें',
          'सर्वोत्तम निकालासाठी पान सपाट ठेवून नैसर्गिक प्रकाशात फोटो काढा',
        ),
      },
      {
        'icon': '🔍',
        'text': l.t3(
          'Focus on the affected area of the leaf for accurate detection',
          'सटीक पहचान के लिए पत्ती के प्रभावित हिस्से पर फोकस करें',
          'अचूक ओळखीसाठी पानाच्या बाधित भागावर फोकस करा',
        ),
      },
      {
        'icon': '📅',
        'text': l.t3(
          'Scan regularly to track your crop health over time',
          'समय के साथ फसल स्वास्थ्य ट्रैक करने के लिए नियमित स्कैन करें',
          'कालांतराने पिकाचे आरोग्य ट्रॅक करण्यासाठी नियमित स्कॅन करा',
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(S.quickTips),
        const SizedBox(height: 12),
        ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tip['icon']!,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip['text']!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

// ================================================================
//  HISTORY TAB
// ================================================================
class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(S.scanHistory),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded,
                    color: AppColors.textMuted),
                onPressed: () => _confirmClear(context),
              ),
            ],
          ),
          body: ValueListenableBuilder(
            valueListenable: Hive.box('history').listenable(),
            builder: (context, Box box, _) {
              final scans = box.values
                  .where((v) => v is Map && v.containsKey('label'))
                  .toList()
                  .reversed
                  .toList();

              if (scans.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_rounded,
                          size: 64, color: AppColors.textMuted),
                      const SizedBox(height: 16),
                      Text(S.noScans,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textMuted,
                          )),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: scans.length,
                itemBuilder: (context, i) {
                  final scan = scans[i] as Map;
                  return _HistoryCard(scan: scan, box: box, index: i,
                      totalScans: scans.length);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(S.clearAll,
            style: GoogleFonts.poppins(color: AppColors.textPrimary)),
        content: Text(S.confirmClear,
            style: GoogleFonts.inter(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.cancel),
          ),
          TextButton(
            onPressed: () {
              Hive.box('history').clear();
              Navigator.pop(ctx);
            },
            child: Text(S.yes,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map scan;
  final Box box;
  final int index;
  final int totalScans;

  const _HistoryCard({
    required this.scan,
    required this.box,
    required this.index,
    required this.totalScans,
  });

  @override
  Widget build(BuildContext context) {
    final info = diseaseDatabase[scan['label']];
    final color = info?.color ?? AppColors.primary;
    final pct = ((scan['confidence'] as double) * 100).toStringAsFixed(1);

    String dateStr = '';
    try {
      dateStr = DateFormat('dd MMM yyyy, hh:mm a')
          .format(DateTime.parse(scan['timestamp']));
    } catch (_) {
      dateStr = scan['timestamp'] ?? '';
    }

    final hasImage =
        scan['imagePath'] != null && File(scan['imagePath']).existsSync();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Could navigate to detail view
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasImage
                        ? Image.file(
                            File(scan['imagePath']),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 56,
                            height: 56,
                            color: color.withOpacity(0.1),
                            child: Icon(Icons.image_rounded,
                                color: color, size: 28),
                          ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(info?.emoji ?? '',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                info?.localName ?? scan['label'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                                '$pct%',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                dateStr,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textMuted, size: 20),
                    onPressed: () {
                      final keys = box.keys.toList();
                      // scans are reversed, so map back
                      final realIdx = totalScans - 1 - index;
                      // find keys that are scan entries
                      final scanKeys = keys.where((k) {
                        final v = box.get(k);
                        return v is Map && v.containsKey('label');
                      }).toList();
                      if (realIdx >= 0 && realIdx < scanKeys.length) {
                        box.delete(scanKeys[realIdx]);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
