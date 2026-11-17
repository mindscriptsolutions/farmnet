import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/diagnosis_record.dart';
import '../services/app_locale.dart';
import '../services/history_db.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<DiagnosisRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = HistoryDb.instance.getAll();
  }

  void _reload() {
    setState(() => _future = HistoryDb.instance.getAll());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(T.get('history')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () async {
              await HistoryDb.instance.clear();
              _reload();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DiagnosisRecord>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 64, color: scheme.outline),
                  const SizedBox(height: 12),
                  Text(T.get('noHistory'),
                      style: TextStyle(color: scheme.outline)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final r = items[i];
              final healthy = r.status == 'healthy';
              final date = DateFormat('dd MMM yyyy, hh:mm a')
                  .format(DateTime.fromMillisecondsSinceEpoch(r.timestamp));
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: File(r.imagePath).existsSync()
                        ? Image.file(File(r.imagePath),
                            width: 52, height: 52, fit: BoxFit.cover)
                        : Container(
                            width: 52,
                            height: 52,
                            color: Colors.black12,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  title: Text('${r.crop} - ${r.disease}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      '${(r.confidence * 100).round()}%  -  $date'),
                  trailing: Icon(
                    healthy ? Icons.check_circle : Icons.warning_amber_rounded,
                    color: healthy
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFC62828),
                  ),
                  onTap: () => _showDetail(r),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetail(DiagnosisRecord r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Text('${r.crop} - ${r.disease}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _block(T.get('symptoms'), r.symptoms),
            _block(T.get('prevention'), r.prevention),
            _block(T.get('management'), r.management),
          ],
        ),
      ),
    );
  }

  Widget _block(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }
}
