import '../models/ai_analysis_model.dart';

class AIService {
  // Datos simulados de medicamentos
  static List<MedicationRecord> getMedicationHistory() {
    return [
      MedicationRecord(
        name: 'Losartán 50mg',
        time: '14:30',
        status: 'Tomado',
        date: DateTime.now(),
      ),
      MedicationRecord(
        name: 'Losartán 50mg',
        time: '14:30',
        status: 'Tomado',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MedicationRecord(
        name: 'Losartán 50mg',
        time: '14:30',
        status: 'Omisión',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      MedicationRecord(
        name: 'Losartán 50mg',
        time: '14:30',
        status: 'Retraso',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      MedicationRecord(
        name: 'Metformina 850mg',
        time: '20:00',
        status: 'Tomado',
        date: DateTime.now(),
      ),
      MedicationRecord(
        name: 'Metformina 850mg',
        time: '20:00',
        status: 'Tomado',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MedicationRecord(
        name: 'Metformina 850mg',
        time: '20:00',
        status: 'Omisión',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      MedicationRecord(
        name: 'Aspirina 100mg',
        time: '08:00',
        status: 'Tomado',
        date: DateTime.now(),
      ),
      MedicationRecord(
        name: 'Aspirina 100mg',
        time: '08:00',
        status: 'Tomado',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MedicationRecord(
        name: 'Aspirina 100mg',
        time: '08:00',
        status: 'Tomado',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  static AIAnalysisResult analyzeCompliance(String userName) {
    final history = getMedicationHistory();
    final totalMeds = history.length;
    final takenMeds = history.where((m) => m.status == 'Tomado').length;
    final missedMeds = history.where((m) => m.status == 'Omisión').toList();
    final delayedMeds = history.where((m) => m.status == 'Retraso').toList();
    
    final adherenceRate = (takenMeds / totalMeds) * 100;
    
    // Identificar patrones
    final patterns = <String>[];
    if (missedMeds.isNotEmpty) {
      patterns.add('🔴 Se detectaron ${missedMeds.length} omisiones en los últimos días');
    }
    if (delayedMeds.isNotEmpty) {
      patterns.add('🟡 ${delayedMeds.length} tomas con retraso significativo');
    }
    if (adherenceRate >= 90) {
      patterns.add('✅ Excelente cumplimiento del tratamiento!');
    } else if (adherenceRate >= 70) {
      patterns.add('📈 Cumplimiento moderado, puede mejorar');
    } else {
      patterns.add('⚠️ Bajo cumplimiento, se requiere atención');
    }
    
    // Generar alertas inteligentes
    final alerts = <Alert>[];
    if (missedMeds.isNotEmpty) {
      alerts.add(Alert(
        title: '⚠️ Alerta de Omisión',
        message: 'Has olvidado tomar ${missedMeds.first.name} el día ${missedMeds.first.date.day}/${missedMeds.first.date.month}',
        type: AlertType.warning,
        timestamp: DateTime.now(),
      ));
    }
    if (delayedMeds.isNotEmpty) {
      alerts.add(Alert(
        title: '⏰ Alerta de Retraso',
        message: 'Se detectó retraso en la toma de ${delayedMeds.first.name}',
        type: AlertType.info,
        timestamp: DateTime.now(),
      ));
    }
    if (adherenceRate < 70) {
      alerts.add(Alert(
        title: '🔴 Alerta Crítica',
        message: 'Tu cumplimiento está por debajo del 70%. Es importante que tomes tus medicamentos a tiempo.',
        type: AlertType.critical,
        timestamp: DateTime.now(),
      ));
    }
    
    // Recomendaciones personalizadas
    final recommendations = <String>[];
    if (missedMeds.isNotEmpty) {
      recommendations.add('💡 Configura recordatorios adicionales para ${missedMeds.first.name}');
    }
    if (delayedMeds.isNotEmpty) {
      recommendations.add('⏰ Intenta tomar tus medicamentos a la misma hora todos los días');
    }
    if (adherenceRate < 80) {
      recommendations.add('📱 Usa la función de recordatorios por voz para no olvidar tus medicamentos');
      recommendations.add('👨‍⚕️ Consulta con tu médico sobre posibles ajustes en el horario');
    } else {
      recommendations.add('🎉 ¡Sigue así! Mantén este excelente hábito');
      recommendations.add('📊 Revisa tu progreso semanalmente');
    }
    recommendations.add('💊 Si tienes dudas sobre tus medicamentos, siempre puedes preguntarme');

    return AIAnalysisResult(
      adherenceRate: adherenceRate,
      missedMeds: missedMeds,
      delayedMeds: delayedMeds,
      patterns: patterns,
      alerts: alerts,
      recommendations: recommendations,
    );
  }
}