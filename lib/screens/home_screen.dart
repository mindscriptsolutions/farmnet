import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../models/prediction.dart';
import '../data/crops.dart';
import '../services/app_locale.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';
import 'crops_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );
      if (file == null) return;

      setState(() => _busy = true);
      if (!classifier.isReady) {
        await classifier.load();
      }
      final bytes = await File(file.path).readAsBytes();
      final Prediction prediction = await classifier.classify(bytes);

      if (!mounted) return;
      setState(() => _busy = false);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            prediction: prediction,
            imagePath: file.path,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _busy ? _buildBusy() : _buildHome(),
    );
  }

  Widget _buildBusy() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(T.get('analyzing'),
                style: const TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _hero(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _statsRow(),
                  const SizedBox(height: 22),
                  _scanButtons(),
                  const SizedBox(height: 24),
                  _sectionHeader(Icons.grass, 'Supported crops', onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const CropsScreen()));
                  }),
                  const SizedBox(height: 12),
                  _cropsStrip(),
                  const SizedBox(height: 20),
                  _tipCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF43A047), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.eco, color: Colors.white, size: 30),
              const SizedBox(width: 8),
              Text(
                T.get('appName'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                tooltip: T.get('language'),
                icon: const Icon(Icons.language, color: Colors.white),
                onPressed: _showLanguageSheet,
              ),
              IconButton(
                tooltip: T.get('history'),
                icon: const Icon(Icons.history, color: Colors.white),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
              ),
              IconButton(
                tooltip: 'About',
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '🌿',
            style: TextStyle(fontSize: 54),
          ),
          const SizedBox(height: 6),
          Text(
            T.get('tagline'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(T.get('offlineBadge'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    final stats = [
      ['${kCrops.length}', 'Crops', Icons.spa, const Color(0xFF2E7D32)],
      ['$kTotalDiseases', 'Diseases', Icons.coronavirus, const Color(0xFFC62828)],
      ['100%', 'Offline', Icons.offline_bolt, const Color(0xFF1565C0)],
    ];
    return Row(
      children: [
        for (final s in stats) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: (s[3] as Color).withOpacity(0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(s[2] as IconData, color: s[3] as Color, size: 26),
                  const SizedBox(height: 6),
                  Text(s[0] as String,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: s[3] as Color)),
                  Text(s[1] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ),
          if (s != stats.last) const SizedBox(width: 10),
        ]
      ],
    );
  }

  Widget _scanButtons() {
    return Column(
      children: [
        _bigButton(
          icon: Icons.camera_alt,
          label: T.get('capture'),
          gradient: const [Color(0xFF2E7D32), Color(0xFF43A047)],
          onTap: () => _pick(ImageSource.camera),
        ),
        const SizedBox(height: 14),
        _bigButton(
          icon: Icons.photo_library,
          label: T.get('gallery'),
          gradient: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
          onTap: () => _pick(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _bigButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, {VoidCallback? onTap}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 8),
        Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        if (onTap != null)
          TextButton(onPressed: onTap, child: const Text('See all')),
      ],
    );
  }

  Widget _cropsStrip() {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kCrops.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final c = kCrops[i];
          return Container(
            width: 92,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.color.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 6),
                Text(c.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                Text(
                    c.diseaseCount == 0
                        ? 'healthy'
                        : '${c.diseaseCount} disease${c.diseaseCount > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFFDE7)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: Color(0xFFF9A825)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'For best results, hold one affected leaf flat, fill the frame, '
              'and use good daylight.',
              style: TextStyle(fontSize: 14, color: Colors.brown.shade700),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(T.get('language'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            for (final entry in kSupportedLanguages.entries)
              ListTile(
                title: Text(entry.value),
                trailing: AppLocale.code.value == entry.key
                    ? const Icon(Icons.check, color: Color(0xFF2E7D32))
                    : null,
                onTap: () {
                  AppLocale.set(entry.key);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
