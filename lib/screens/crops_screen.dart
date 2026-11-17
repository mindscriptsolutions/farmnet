import 'package:flutter/material.dart';

import '../data/crops.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supported Crops & Diseases'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF43A047)]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _miniStat('${kCrops.length}', 'Crops'),
                _divider(),
                _miniStat('$kTotalDiseases', 'Diseases'),
                _divider(),
                _miniStat('$kTotalClasses', 'Total classes'),
              ],
            ),
          ),
          for (final c in kCrops) _cropCard(c),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 34, color: Colors.white24);

  Widget _cropCard(CropInfo c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.color.withOpacity(0.25)),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: c.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(c.emoji, style: const TextStyle(fontSize: 26))),
          ),
          title: Text(c.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(c.diseaseCount == 0
              ? 'Healthy detection only'
              : '${c.diseaseCount} disease${c.diseaseCount > 1 ? 's' : ''} + healthy'),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final cond in c.conditions)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: cond == 'Healthy'
                          ? const Color(0xFF2E7D32).withOpacity(0.12)
                          : c.color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cond == 'Healthy'
                              ? Icons.check_circle
                              : Icons.coronavirus,
                          size: 15,
                          color: cond == 'Healthy'
                              ? const Color(0xFF2E7D32)
                              : c.color,
                        ),
                        const SizedBox(width: 6),
                        Text(cond, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
