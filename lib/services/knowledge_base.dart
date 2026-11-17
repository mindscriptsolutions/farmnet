import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Loads the offline advisory knowledge base bundled with the app.
/// No internet is ever required: all disease information ships inside the APK.
class KnowledgeBase {
  static Map<String, dynamic> _data = {};
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/data/knowledge_base.json');
    _data = json.decode(raw) as Map<String, dynamic>;
    _loaded = true;
  }

  /// Returns advisory info for a raw model label, with safe fallbacks.
  static Map<String, String> lookup(String label) {
    final entry = _data[label];
    if (entry is Map) {
      return {
        'crop': (entry['crop'] ?? 'Unknown').toString(),
        'disease': (entry['disease'] ?? 'Unknown').toString(),
        'status': (entry['status'] ?? 'diseased').toString(),
        'symptoms': (entry['symptoms'] ?? 'No information available.').toString(),
        'prevention':
            (entry['prevention'] ?? 'No information available.').toString(),
        'management':
            (entry['management'] ?? 'Consult a local agriculture officer.')
                .toString(),
      };
    }
    // Fallback: derive a readable crop/disease from the raw label.
    final parts = label.split('___');
    return {
      'crop': parts.isNotEmpty ? parts[0].replaceAll('_', ' ') : 'Unknown',
      'disease':
          parts.length > 1 ? parts[1].replaceAll('_', ' ') : 'Unknown',
      'status': 'diseased',
      'symptoms': 'No local information available for this class.',
      'prevention': 'Maintain field hygiene and consult an expert.',
      'management': 'Consult your nearest agriculture extension officer.',
    };
  }
}
