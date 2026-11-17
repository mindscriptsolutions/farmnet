import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported regional languages. Easily extended with more locales.
const Map<String, String> kSupportedLanguages = {
  'en': 'English',
  'te': 'తెలుగు (Telugu)',
  'hi': 'हिंदी (Hindi)',
};

/// Holds the selected UI language and persists it locally (offline).
class AppLocale {
  static final ValueNotifier<String> code = ValueNotifier<String>('en');

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    code.value = prefs.getString('lang') ?? 'en';
  }

  static Future<void> set(String lang) async {
    code.value = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
  }
}

/// UI string table. Advisory/disease content is served from the knowledge base;
/// these are the interface labels, translated for rural accessibility.
class T {
  static const Map<String, Map<String, String>> _s = {
    'appName': {
      'en': 'FarmNet',
      'te': 'ఫార్మ్‌నెట్',
      'hi': 'फार्मनेट',
    },
    'tagline': {
      'en': 'Offline crop disease helper',
      'te': 'ఆఫ్‌లైన్ పంట వ్యాధి సహాయకం',
      'hi': 'ऑफ़लाइन फसल रोग सहायक',
    },
    'capture': {
      'en': 'Take a photo',
      'te': 'ఫోటో తీయండి',
      'hi': 'फ़ोटो लें',
    },
    'gallery': {
      'en': 'Choose from gallery',
      'te': 'గ్యాలరీ నుండి ఎంచుకోండి',
      'hi': 'गैलरी से चुनें',
    },
    'history': {
      'en': 'History',
      'te': 'చరిత్ర',
      'hi': 'इतिहास',
    },
    'analyzing': {
      'en': 'Analysing leaf...',
      'te': 'ఆకును విశ్లేషిస్తోంది...',
      'hi': 'पत्ती का विश्लेषण हो रहा है...',
    },
    'result': {
      'en': 'Diagnosis',
      'te': 'నిర్ధారణ',
      'hi': 'निदान',
    },
    'confidence': {
      'en': 'Confidence',
      'te': 'విశ్వాసం',
      'hi': 'विश्वास',
    },
    'crop': {
      'en': 'Crop',
      'te': 'పంట',
      'hi': 'फसल',
    },
    'symptoms': {
      'en': 'Symptoms',
      'te': 'లక్షణాలు',
      'hi': 'लक्षण',
    },
    'prevention': {
      'en': 'Prevention',
      'te': 'నివారణ',
      'hi': 'रोकथाम',
    },
    'management': {
      'en': 'Management',
      'te': 'నిర్వహణ',
      'hi': 'प्रबंधन',
    },
    'healthy': {
      'en': 'Looks healthy',
      'te': 'ఆరోగ్యంగా ఉంది',
      'hi': 'स्वस्थ दिख रहा है',
    },
    'save': {
      'en': 'Save to history',
      'te': 'చరిత్రలో భద్రపరచండి',
      'hi': 'इतिहास में सहेजें',
    },
    'saved': {
      'en': 'Saved',
      'te': 'భద్రపరచబడింది',
      'hi': 'सहेजा गया',
    },
    'noHistory': {
      'en': 'No saved diagnoses yet',
      'te': 'ఇంకా భద్రపరచిన నిర్ధారణలు లేవు',
      'hi': 'अभी तक कोई निदान सहेजा नहीं गया',
    },
    'offlineBadge': {
      'en': 'Works 100% offline',
      'te': '100% ఆఫ్‌లైన్‌లో పనిచేస్తుంది',
      'hi': '100% ऑफ़लाइन काम करता है',
    },
    'lowConfidence': {
      'en': 'Low confidence - retake a clear, close-up photo of one leaf.',
      'te': 'తక్కువ విశ్వాసం - ఒక ఆకు స్పష్టమైన ఫోటో మళ్లీ తీయండి.',
      'hi': 'कम विश्वास - एक पत्ती की स्पष्ट फ़ोटो दोबारा लें।',
    },
    'invalid': {
      'en': 'No clear leaf detected',
      'te': 'స్పష్టమైన ఆకు కనబడలేదు',
      'hi': 'कोई स्पष्ट पत्ती नहीं मिली',
    },
    'language': {
      'en': 'Language',
      'te': 'భాష',
      'hi': 'भाषा',
    },
    'retake': {
      'en': 'Scan another leaf',
      'te': 'మరో ఆకును స్కాన్ చేయండి',
      'hi': 'दूसरी पत्ती स्कैन करें',
    },
  };

  static String get(String key, [String? lang]) {
    final l = lang ?? AppLocale.code.value;
    final entry = _s[key];
    if (entry == null) return key;
    return entry[l] ?? entry['en'] ?? key;
  }
}
