import '../models/family_models.dart';

class FamilyService {
  static ElderlyPatient getPatientData() {
    return ElderlyPatient(
      id: '1',
      name: 'Carlos Pérez',
      age: 78,
      photoUrl: '',
      weeklyAdherence: 92,
      medicationHistory: [
        MedicationHistory(
          name: 'Aspirina Protect',
          time: '08:00',
          status: 'Tomado a tiempo',
          date: DateTime.now(),
          isSuccess: true,
        ),
        MedicationHistory(
          name: 'Losartán 50mg',
          time: '14:30',
          status: 'Pendiente',
          date: DateTime.now(),
          isSuccess: false,
        ),
        MedicationHistory(
          name: 'Metformina 850mg',
          time: '20:00',
          status: 'Tomado con retraso',
          date: DateTime.now(),
          isSuccess: false,
        ),
      ],
      alerts: [
        Alert(
          title: 'Patrón de Omisión Detectado',
          message: 'Carlos ha retrasado la toma nocturna de Metformina los últimos 3 días. Considere ajustar el horario.',
          type: AlertType.warning,
          date: DateTime.now(),
        ),
        Alert(
          title: 'Adherencia Excelente',
          message: 'Carlos ha cumplido con el 95% de sus medicamentos esta semana.',
          type: AlertType.success,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Alert(
          title: 'Medicamento Nuevo',
          message: 'Se ha agregado un nuevo medicamento: Losartán 50mg.',
          type: AlertType.info,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      healthSummary: HealthSummary(
        adherenceRate: 92,
        missedDoses: 2,
        delayedDoses: 3,
        lastCheckup: '10/04/2024',
        nextCheckup: '10/05/2024',
      ),
    );
  }
}