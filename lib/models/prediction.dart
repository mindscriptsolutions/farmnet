/// A single classification result produced by the on-device model.
class Prediction {
  final String label; // raw label, e.g. "Tomato___Late_blight"
  final String crop;
  final String disease;
  final String status; // healthy | diseased | pest | invalid
  final double confidence; // 0.0 - 1.0
  final String symptoms;
  final String prevention;
  final String management;

  const Prediction({
    required this.label,
    required this.crop,
    required this.disease,
    required this.status,
    required this.confidence,
    required this.symptoms,
    required this.prevention,
    required this.management,
  });

  bool get isHealthy => status == 'healthy';
  bool get isInvalid => status == 'invalid';

  int get confidencePercent => (confidence * 100).round();
}
