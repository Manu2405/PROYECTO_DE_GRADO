import 'package:flutter/material.dart';

class ElderlyPatient {
  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final double weeklyAdherence;
  final List<MedicationHistory> medicationHistory;
  final List<Alert> alerts;
  final HealthSummary healthSummary;

  ElderlyPatient({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.weeklyAdherence,
    required this.medicationHistory,
    required this.alerts,
    required this.healthSummary,
  });

  String get adherenceStatus {
    if (weeklyAdherence >= 90) return 'Excelente';
    if (weeklyAdherence >= 75) return 'Bueno';
    if (weeklyAdherence >= 60) return 'Regular';
    return 'Precaución';
  }

  Color get adherenceColor {
    if (weeklyAdherence >= 90) return Colors.green;
    if (weeklyAdherence >= 75) return Colors.teal;
    if (weeklyAdherence >= 60) return Colors.orange;
    return Colors.red;
  }
}

class MedicationHistory {
  final String name;
  final String time;
  final String status;
  final DateTime date;
  final bool isSuccess;

  MedicationHistory({
    required this.name,
    required this.time,
    required this.status,
    required this.date,
    required this.isSuccess,
  });
}

class Alert {
  final String title;
  final String message;
  final AlertType type;
  final DateTime date;
  final bool isRead;

  Alert({
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isRead = false,
  });

  Color getColor() {
    switch (type) {
      case AlertType.warning:
        return Colors.orange;
      case AlertType.critical:
        return Colors.red;
      case AlertType.info:
        return Colors.blue;
      case AlertType.success:
        return Colors.green;
    }
  }

  IconData getIcon() {
    switch (type) {
      case AlertType.warning:
        return Icons.warning_amber;
      case AlertType.critical:
        return Icons.error;
      case AlertType.info:
        return Icons.info;
      case AlertType.success:
        return Icons.check_circle;
    }
  }
}

enum AlertType { warning, critical, info, success }

class HealthSummary {
  final double adherenceRate;
  final int missedDoses;
  final int delayedDoses;
  final String lastCheckup;
  final String nextCheckup;

  HealthSummary({
    required this.adherenceRate,
    required this.missedDoses,
    required this.delayedDoses,
    required this.lastCheckup,
    required this.nextCheckup,
  });
}