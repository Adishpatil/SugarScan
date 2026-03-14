import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/classifier.dart';
import '../models/disease_data.dart';
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Disease Info'),
        ],
      ),
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
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ResultScreen(imageFile: File(picked.path)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🌿 SugarScan', style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,
                  )),
                  SizedBox(height: 4),
                  Text('AI Sugarcane Disease Detection', style: TextStyle(
                    color: Colors.white70, fontSize: 14,
                  )),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text('Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Camera button
            _ActionButton(
              icon: Icons.camera_alt,
              label: 'Take Photo',
              subtitle: 'Use camera to capture leaf',
              color: const Color(0xFF2ECC71),
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            const SizedBox(height: 12),

            // Gallery button
            _ActionButton(
              icon: Icons.photo_library,
              label: 'Choose from Gallery',
              subtitle: 'Select existing leaf image',
              color: const Color(0xFF1B4332),
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),

            const SizedBox(height: 32),

            // Stats
            ValueListenableBuilder(
              valueListenable: Hive.box('history').listenable(),
              builder: (context, Box box, _) {
                final total = box.length;
                final diseased = box.values
                    .where((v) => v['label'] != 'Healthy').length;
                return Row(
                  children: [
                    _StatCard('Total Scans', '$total', Colors.blue),
                    const SizedBox(width: 12),
                    _StatCard('Diseases', '$diseased', Colors.red),
                    const SizedBox(width: 12),
                    _StatCard('Healthy', '${total - diseased}',
                        const Color(0xFF2ECC71)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
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
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
                )),
                Text(subtitle, style: const TextStyle(
                  color: Colors.white70, fontSize: 12,
                )),
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
          Text(value, style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: color,
          )),
          Text(label, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
          ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
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
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('📋', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text('No scans yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }
          final scans = box.values.toList().reversed.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: scans.length,
            itemBuilder: (context, i) {
              final scan = scans[i] as Map;
              final info = diseaseDatabase[scan['label']];
              final color = info?.color ?? const Color(0xFF2ECC71);
              final pct = ((scan['confidence'] as double) * 100).toStringAsFixed(1);
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
                    style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                  subtitle: Text('$pct% confidence • $date',
                    style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => box.deleteAt(box.length - 1 - i),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── INFO TAB ──
class _InfoTab extends StatelessWidget {
  const _InfoTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Info'),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: diseaseDatabase.entries.map((entry) {
          final info = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              leading: Text(info.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(info.name,
                style: TextStyle(fontWeight: FontWeight.bold, color: info.color)),
              subtitle: Text('Severity: ${info.severity}',
                style: TextStyle(color: info.color.withOpacity(0.7), fontSize: 12)),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow('📋 Description', info.description),
                      const SizedBox(height: 8),
                      _InfoRow('🦠 Cause', info.cause),
                      const SizedBox(height: 8),
                      _InfoRow('💊 Treatment', info.treatment),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

Widget _InfoRow(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 4),
      Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
    ],
  );
}
