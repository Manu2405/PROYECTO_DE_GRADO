class MedicationRecord {
  final String name;
  final String time;
  final String status;
  final DateTime date;
  final String? notes;

  MedicationRecord({
    required this.name,
    required this.time,
    required this.status,
    required this.date,
    this.notes,
  });
}

class AIAnalysisResult {
  final double adherenceRate;
  final List<MedicationRecord> missedMeds;
  final List<MedicationRecord> delayedMeds;
  final List<String> patterns;
  final List<Alert> alerts;
  final List<String> recommendations;

  AIAnalysisResult({
    required this.adherenceRate,
    required this.missedMeds,
    required this.delayedMeds,
    required this.patterns,
    required this.alerts,
    required this.recommendations,
  });
}

class Alert {
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;

  Alert({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

enum AlertType {
  warning,
  info,
  success,
  critical,
}