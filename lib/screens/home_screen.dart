import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../models/prediction.dart';
import '../services/app_locale.dart';
import 'result_screen.dart';
import 'history_screen.dart';

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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(T.get('appName')),
        actions: [
          IconButton(
            tooltip: T.get('language'),
            icon: const Icon(Icons.language),
            onPressed: _showLanguageSheet,
          ),
          IconButton(
            tooltip: T.get('history'),
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _busy ? _buildBusy() : _buildHome(scheme),
      ),
    );
  }

  Widget _buildBusy() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(T.get('analyzing'), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHome(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(Icons.eco, size: 64, color: scheme.primary),
                const SizedBox(height: 12),
                Text(
                  T.get('appName'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  T.get('tagline'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 16, color: scheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      T.get('offlineBadge'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            icon: const Icon(Icons.camera_alt, size: 26),
            label: Text(T.get('capture')),
            onPressed: () => _pick(ImageSource.camera),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.photo_library, size: 24),
            label: Text(T.get('gallery')),
            onPressed: () => _pick(ImageSource.gallery),
          ),
          const SizedBox(height: 28),
          _tipCard(scheme),
        ],
      ),
    );
  }

  Widget _tipCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hold one affected leaf flat, fill the frame, and use daylight '
              'for the most accurate result.',
              style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
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
