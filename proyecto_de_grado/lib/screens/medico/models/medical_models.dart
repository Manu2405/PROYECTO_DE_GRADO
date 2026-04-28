import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final int age;
  final String diagnosis;
  final double adherence;
  final RiskLevel riskLevel;
  final List<Medication> medications;
  final String lastVisit;
  final String? photoUrl;
  final String? familyContact;
  final String? caregiver;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.diagnosis,
    required this.adherence,
    required this.riskLevel,
    required this.medications,
    required this.lastVisit,
    this.photoUrl,
    this.familyContact,
    this.caregiver,
  });

  Color getRiskColor() {
    switch (riskLevel) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
    }
  }

  String getRiskText() {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Bajo';
      case RiskLevel.medium:
        return 'Medio';
      case RiskLevel.high:
        return 'Alto';
    }
  }

  String getInitials() {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name[0];
  }
}

enum RiskLevel { low, medium, high }

class Medication {
  final String name;
  final String dosage;
  final String schedule;
  final String startDate;
  final String? endDate;
  final bool isActive;

  Medication({
    required this.name,
    required this.dosage,
    required this.schedule,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });
}

class ClinicalReport {
  final String patientId;
  final String patientName;
  final DateTime date;
  final double adherenceRate;
  final List<String> recommendations;
  final Map<String, int> missedMedications;
  final String observations;

  ClinicalReport({
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.adherenceRate,
    required this.recommendations,
    required this.missedMedications,
    required this.observations,
  });
}