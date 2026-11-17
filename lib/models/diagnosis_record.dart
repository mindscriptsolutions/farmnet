/// A saved diagnosis stored locally in the device database (offline history).
class DiagnosisRecord {
  final int? id;
  final String imagePath;
  final String crop;
  final String disease;
  final String status;
  final double confidence;
  final String symptoms;
  final String prevention;
  final String management;
  final int timestamp; // millisecondsSinceEpoch

  const DiagnosisRecord({
    this.id,
    required this.imagePath,
    required this.crop,
    required this.disease,
    required this.status,
    required this.confidence,
    required this.symptoms,
    required this.prevention,
    required this.management,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'imagePath': imagePath,
        'crop': crop,
        'disease': disease,
        'status': status,
        'confidence': confidence,
        'symptoms': symptoms,
        'prevention': prevention,
        'management': management,
        'timestamp': timestamp,
      };

  factory DiagnosisRecord.fromMap(Map<String, dynamic> m) => DiagnosisRecord(
        id: m['id'] as int?,
        imagePath: m['imagePath'] as String,
        crop: m['crop'] as String,
        disease: m['disease'] as String,
        status: m['status'] as String,
        confidence: (m['confidence'] as num).toDouble(),
        symptoms: m['symptoms'] as String,
        prevention: m['prevention'] as String,
        management: m['management'] as String,
        timestamp: m['timestamp'] as int,
      );
}
