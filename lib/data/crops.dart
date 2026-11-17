import 'package:flutter/material.dart';

/// Static catalogue of crops and the conditions the model can detect,
/// used by the Home chips and the About / Supported-crops screen.
class CropInfo {
  final String name;
  final String emoji;
  final Color color;
  final List<String> conditions; // human-readable condition names

  const CropInfo(this.name, this.emoji, this.color, this.conditions);

  int get diseaseCount => conditions.where((c) => c != 'Healthy').length;
}

const List<CropInfo> kCrops = [
  CropInfo('Apple', '🍎', Color(0xFFE53935),
      ['Apple scab', 'Black rot', 'Cedar apple rust', 'Healthy']),
  CropInfo('Blueberry', '🫐', Color(0xFF3949AB), ['Healthy']),
  CropInfo('Cherry', '🍒', Color(0xFFD81B60),
      ['Powdery mildew', 'Healthy']),
  CropInfo('Corn (Maize)', '🌽', Color(0xFFF9A825),
      ['Gray leaf spot', 'Common rust', 'Northern leaf blight', 'Healthy']),
  CropInfo('Grape', '🍇', Color(0xFF8E24AA),
      ['Black rot', 'Esca (Black Measles)', 'Leaf blight', 'Healthy']),
  CropInfo('Orange', '🍊', Color(0xFFFB8C00),
      ['Citrus greening (HLB)']),
  CropInfo('Peach', '🍑', Color(0xFFFF7043),
      ['Bacterial spot', 'Healthy']),
  CropInfo('Pepper (Bell)', '🫑', Color(0xFF43A047),
      ['Bacterial spot', 'Healthy']),
  CropInfo('Potato', '🥔', Color(0xFF8D6E63),
      ['Early blight', 'Late blight', 'Healthy']),
  CropInfo('Raspberry', '🍓', Color(0xFFAD1457), ['Healthy']),
  CropInfo('Soybean', '🌱', Color(0xFF7CB342), ['Healthy']),
  CropInfo('Squash', '🎃', Color(0xFFEF6C00),
      ['Powdery mildew']),
  CropInfo('Strawberry', '🍓', Color(0xFFE91E63),
      ['Leaf scorch', 'Healthy']),
  CropInfo('Tomato', '🍅', Color(0xFFD32F2F), [
    'Bacterial spot',
    'Early blight',
    'Late blight',
    'Leaf mold',
    'Septoria leaf spot',
    'Spider mites',
    'Target spot',
    'Yellow Leaf Curl Virus',
    'Mosaic virus',
    'Healthy',
  ]),
];

int get kTotalDiseases =>
    kCrops.fold(0, (sum, c) => sum + c.diseaseCount);
int get kTotalClasses =>
    kCrops.fold(0, (sum, c) => sum + c.conditions.length);
