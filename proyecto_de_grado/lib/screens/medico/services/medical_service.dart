import '../models/medical_models.dart';

class MedicalService {
  static List<Patient> getPatients() {
    return [
      Patient(
        id: '1',
        name: 'Carlos Pérez',
        age: 78,
        diagnosis: 'Hipertensión arterial',
        adherence: 92,
        riskLevel: RiskLevel.low,
        medications: [
          Medication(name: 'Losartán', dosage: '50mg', schedule: '14:30', startDate: '01/01/2024'),
          Medication(name: 'Metformina', dosage: '850mg', schedule: '20:00', startDate: '15/02/2024'),
        ],
        lastVisit: '10/04/2024',
        familyContact: 'María López (Hija) - 987654321',
        caregiver: 'Ana Rodríguez',
      ),
      Patient(
        id: '2',
        name: 'María Rodríguez',
        age: 82,
        diagnosis: 'Diabetes tipo 2',
        adherence: 65,
        riskLevel: RiskLevel.high,
        medications: [
          Medication(name: 'Metformina', dosage: '1000mg', schedule: '08:00', startDate: '05/01/2024'),
          Medication(name: 'Insulina', dosage: '10 UI', schedule: '20:00', startDate: '10/03/2024'),
        ],
        lastVisit: '05/04/2024',
        familyContact: 'Juan Rodríguez (Hijo) - 987654322',
        caregiver: 'María López',
      ),
      Patient(
        id: '3',
        name: 'Luis Martínez',
        age: 75,
        diagnosis: 'Dislipidemia',
        adherence: 85,
        riskLevel: RiskLevel.medium,
        medications: [
          Medication(name: 'Atorvastatina', dosage: '20mg', schedule: '21:00', startDate: '20/02/2024'),
        ],
        lastVisit: '12/04/2024',
        familyContact: 'Carmen Martínez (Esposa) - 987654323',
        caregiver: 'Pedro Sánchez',
      ),
    ];
  }

  static Patient? getPatientById(String id) {
    return getPatients().firstWhere((p) => p.id == id, orElse: () => throw Exception('Paciente no encontrado'));
  }

  static ClinicalReport generateReport(Patient patient) {
    return ClinicalReport(
      patientId: patient.id,
      patientName: patient.name,
      date: DateTime.now(),
      adherenceRate: patient.adherence,
      recommendations: _generateRecommendations(patient),
      missedMedications: _getMissedMedications(patient),
      observations: _generateObservations(patient),
    );
  }

  static List<String> _generateRecommendations(Patient patient) {
    final recommendations = <String>[];
    if (patient.adherence < 70) {
      recommendations.add('⚠️ Implementar recordatorios por voz para mejorar adherencia');
      recommendations.add('📞 Contactar al familiar/cuidador para seguimiento');
    }
    if (patient.riskLevel == RiskLevel.high) {
      recommendations.add('🩺 Programar visita presencial en los próximos 7 días');
      recommendations.add('📊 Revisar plan de tratamiento actual');
    }
    if (patient.adherence >= 85) {
      recommendations.add('🎉 Mantener el excelente cumplimiento del tratamiento');
    }
    recommendations.add('💊 Revisar interacciones medicamentosas en la próxima visita');
    return recommendations;
  }

  static Map<String, int> _getMissedMedications(Patient patient) {
    // Simulación de medicamentos omitidos
    return {
      'Losartán 50mg': patient.adherence < 70 ? 3 : 0,
      'Metformina 850mg': patient.adherence < 80 ? 2 : 0,
    };
  }

  static String _generateObservations(Patient patient) {
    if (patient.adherence >= 85) {
      return 'Paciente con excelente adherencia al tratamiento. Continuar con el plan actual.';
    } else if (patient.adherence >= 70) {
      return 'Adherencia adecuada. Se recomienda reforzar recordatorios para mejorar.';
    } else {
      return 'ALERTA: Baja adherencia al tratamiento. Requiere intervención inmediata y contacto con familiar/cuidador.';
    }
  }
}