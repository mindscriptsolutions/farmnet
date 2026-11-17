import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/prediction.dart';
import 'knowledge_base.dart';

/// Runs the bundled crop-disease model fully on-device (offline).
///
/// Model: MobileNetV2 trained on PlantVillage (38 classes).
/// Input : float32 NHWC [1, 224, 224, 3], raw 0-255 RGB
///         (the model has its own rescaling baked in).
/// Output: probabilities over 38 classes.
class Classifier {
  static const int _inputSize = 224;

  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _ready = false;

  bool get isReady => _ready;

  Future<void> load() async {
    if (_ready) return;
    _interpreter = await Interpreter.fromAsset(
      'assets/models/plant_disease.tflite',
    );
    final raw = await rootBundle.loadString('assets/data/labels.txt');
    _labels = raw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    await KnowledgeBase.load();
    _ready = true;
  }

  /// Classify raw image bytes and return the top prediction merged with advice.
  Future<Prediction> classify(Uint8List imageBytes) async {
    if (!_ready || _interpreter == null) {
      throw StateError('Classifier not initialised. Call load() first.');
    }

    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw const FormatException('Could not read the selected image.');
    }

    final input = _preprocess(decoded);

    // Output buffer [1, numClasses].
    final numClasses = _labels.length;
    final output =
        List.generate(1, (_) => List<double>.filled(numClasses, 0.0));

    _interpreter!.run(input, output);

    // Normalise to probabilities defensively (works whether or not the model
    // already applies softmax).
    final probs = _softmaxIfNeeded(output[0]);

    // Find the best class.
    int bestIdx = 0;
    double bestVal = probs[0];
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > bestVal) {
        bestVal = probs[i];
        bestIdx = i;
      }
    }

    final label = bestIdx < _labels.length ? _labels[bestIdx] : 'Unknown';
    final info = KnowledgeBase.lookup(label);

    return Prediction(
      label: label,
      crop: info['crop']!,
      disease: info['disease']!,
      status: info['status']!,
      confidence: bestVal,
      symptoms: info['symptoms']!,
      prevention: info['prevention']!,
      management: info['management']!,
    );
  }

  /// Resize to 224x224 and build a raw-valued NHWC float tensor
  /// with shape [1, 224, 224, 3]. Pixel values are kept in 0-255.
  List<List<List<List<double>>>> _preprocess(img.Image image) {
    final resized = img.copyResize(
      image,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );

    return [
      List.generate(_inputSize, (y) {
        return List.generate(_inputSize, (x) {
          final px = resized.getPixel(x, y);
          return [
            px.r.toDouble(),
            px.g.toDouble(),
            px.b.toDouble(),
          ];
        });
      })
    ];
  }

  List<double> _softmaxIfNeeded(List<double> raw) {
    final sum = raw.fold<double>(0.0, (a, b) => a + b);
    final allInRange = raw.every((v) => v >= -0.001 && v <= 1.001);
    if (allInRange && (sum - 1.0).abs() < 0.05) {
      // Already a probability distribution.
      return raw;
    }
    final maxV = raw.reduce(math.max);
    final exps = raw.map((v) => math.exp(v - maxV)).toList();
    final expSum = exps.fold<double>(0.0, (a, b) => a + b);
    return exps.map((v) => v / expSum).toList();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _ready = false;
  }
}
