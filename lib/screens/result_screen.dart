import 'dart:io';
import 'package:flutter/material.dart';

import '../models/diagnosis_record.dart';
import '../models/prediction.dart';
import '../services/app_locale.dart';
import '../services/history_db.dart';

class ResultScreen extends StatefulWidget {
  final Prediction prediction;
  final String imagePath;

  const ResultScreen({
    super.key,
    required this.prediction,
    required this.imagePath,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  Color _statusColor(ColorScheme scheme) {
    switch (widget.prediction.status) {
      case 'healthy':
        return const Color(0xFF2E7D32);
      case 'invalid':
        return Colors.grey;
      case 'pest':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFFC62828);
    }
  }

  Future<void> _save() async {
    final p = widget.prediction;
    await HistoryDb.instance.insert(
      DiagnosisRecord(
        imagePath: widget.imagePath,
        crop: p.crop,
        disease: p.disease,
        status: p.status,
        confidence: p.confidence,
        symptoms: p.symptoms,
        prevention: p.prevention,
        management: p.management,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    if (!mounted) return;
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(T.get('saved'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prediction;
    final scheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(scheme);
    final lowConfidence = p.confidence < 0.55 && !p.isInvalid;

    return Scaffold(
      appBar: AppBar(title: Text(T.get('result'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(widget.imagePath),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      p.isHealthy
                          ? Icons.check_circle
                          : p.isInvalid
                              ? Icons.help_outline
                              : Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.isInvalid ? T.get('invalid') : p.disease,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!p.isInvalid) ...[
                  const SizedBox(height: 8),
                  Text('${T.get('crop')}: ${p.crop}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  _confidenceBar(p.confidencePercent, statusColor),
                ],
              ],
            ),
          ),
          if (lowConfidence) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFE65100)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(T.get('lowConfidence'))),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (!p.isInvalid) ...[
            _section(Icons.coronavirus_outlined, T.get('symptoms'), p.symptoms,
                scheme),
            _section(Icons.shield_outlined, T.get('prevention'), p.prevention,
                scheme),
            _section(Icons.healing_outlined, T.get('management'), p.management,
                scheme),
          ] else
            _section(Icons.camera_alt_outlined, T.get('invalid'), p.management,
                scheme),
          const SizedBox(height: 8),
          if (!p.isInvalid)
            FilledButton.icon(
              icon: Icon(_saved ? Icons.check : Icons.save_outlined),
              label: Text(_saved ? T.get('saved') : T.get('save')),
              onPressed: _saved ? null : _save,
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            icon: const Icon(Icons.camera_alt),
            label: Text(T.get('retake')),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _confidenceBar(int percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(T.get('confidence'),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$percent%',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent / 100.0,
            minHeight: 10,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _section(
      IconData icon, String title, String body, ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: scheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }
}
