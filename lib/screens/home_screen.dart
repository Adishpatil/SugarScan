import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/disease_data.dart';
import '../services/language_service.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              _HomeTab(),
              _HistoryTab(),
              _InfoTab(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            selectedItemColor: const Color(0xFF1B4332),
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: S.home),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.history), label: S.history),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.info), label: S.diseaseInfo),
            ],
          ),
        );
      },
    );
  }
}

// ── HOME TAB ──
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 95);
    if (picked != null && context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(imageFile: File(picked.path)),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        final lang = LanguageService();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with language toggle
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🌿 ${S.appName}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                            const SizedBox(height: 4),
                            Text(S.tagline,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      // Language Toggle Button
                      GestureDetector(
                        onTap: () => lang.toggle(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Row(
                            children: [
                              const Text('🌐', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                lang.isHindi ? 'हिंदी' : 'EN',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Text(S.selectImage,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                _ActionButton(
                  icon: Icons.camera_alt,
                  label: S.takePhoto,
                  subtitle: S.takePhotoSub,
                  color: const Color(0xFF2ECC71),
                  onTap: () => _pickImage(context, ImageSource.camera),
                ),
                const SizedBox(height: 12),

                _ActionButton(
                  icon: Icons.photo_library,
                  label: S.chooseGallery,
                  subtitle: S.chooseGallerySub,
                  color: const Color(0xFF1B4332),
                  onTap: () => _pickImage(context, ImageSource.gallery),
                ),

                const SizedBox(height: 28),

                ValueListenableBuilder(
                  valueListenable: Hive.box('history').listenable(),
                  builder: (context, Box box, _) {
                    final total = box.length;
                    final diseased =
                        box.values.where((v) => v['label'] != 'Healthy').length;
                    return Row(
                      children: [
                        _StatCard(S.totalScans, '$total', Colors.blue),
                        const SizedBox(width: 12),
                        _StatCard(S.diseases, '$diseased', Colors.red),
                        const SizedBox(width: 12),
                        _StatCard(S.healthy, '${total - diseased}',
                            const Color(0xFF2ECC71)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _StatCard(String label, String value, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
        ],
      ),
    ),
  );
}

// ── HISTORY TAB ──
class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.scanHistory),
            backgroundColor: const Color(0xFF1B4332),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => Hive.box('history').clear(),
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
                      const Text('📋', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(S.noScans,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: scans.length,
                itemBuilder: (context, i) {
                  final scan = scans[i] as Map;
                  final info = diseaseDatabase[scan['label']];
                  final color = info?.color ?? const Color(0xFF2ECC71);
                  final pct =
                      ((scan['confidence'] as double) * 100).toStringAsFixed(1);
                  final date = DateFormat('dd MMM, hh:mm a')
                      .format(DateTime.parse(scan['timestamp']));

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color, width: 2),
                    ),
                    child: ListTile(
                      leading: File(scan['imagePath']).existsSync()
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(scan['imagePath']),
                                  width: 52, height: 52, fit: BoxFit.cover),
                            )
                          : Icon(Icons.image, color: color, size: 40),
                      title: Text('${info?.emoji ?? ''} ${scan['label']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: color)),
                      subtitle: Text('$pct% ${S.confidence} • $date',
                          style: const TextStyle(fontSize: 12)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final keys = box.keys.toList();
                          final reversedIdx = scans.length - 1 - i;
                          if (reversedIdx < keys.length) {
                            box.delete(keys[reversedIdx]);
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ── INFO TAB ──
class _InfoTab extends StatelessWidget {
  const _InfoTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.diseaseInfo),
            backgroundColor: const Color(0xFF1B4332),
            foregroundColor: Colors.white,
          ),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: diseaseDatabase.entries.map((entry) {
              final info = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  leading:
                      Text(info.emoji, style: const TextStyle(fontSize: 28)),
                  title: Text(info.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: info.color)),
                  subtitle: Text('${S.severity}: ${info.severity}',
                      style: TextStyle(
                          color: info.color.withOpacity(0.7), fontSize: 12)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow('📋 ${S.description}', info.description),
                          const SizedBox(height: 8),
                          _InfoRow('🦠 ${S.cause}', info.cause),
                          const SizedBox(height: 8),
                          _InfoRow('💊 ${S.treatment}', info.treatment),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

Widget _InfoRow(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 4),
      Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
    ],
  );
}
