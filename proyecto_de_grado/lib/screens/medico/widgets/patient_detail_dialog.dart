import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '/../core/theme/app_theme.dart';
import '../models/medical_models.dart';
import '../services/medical_service.dart';

class PatientDetailDialog extends StatelessWidget {
  final Patient patient;

  const PatientDetailDialog({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final report = MedicalService.generateReport(patient);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigo.shade300],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      patient.getInitials(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${patient.age} años • ${patient.diagnosis}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de contacto
                    _buildInfoSection('📞 Contacto', [
                      'Familiar: ${patient.familyContact ?? "No registrado"}',
                      'Cuidador: ${patient.caregiver ?? "No asignado"}',
                    ]),
                    const SizedBox(height: 16),

                    // Medicamentos
                    _buildInfoSection('💊 Medicamentos', [
                      ...patient.medications.map((m) => '• ${m.name} ${m.dosage} - ${m.schedule}'),
                    ]),
                    const SizedBox(height: 16),

                    // Reporte clínico
                    _buildInfoSection('📊 Reporte Clínico', [
                      'Adherencia: ${patient.adherence.toInt()}%',
                      'Última visita: ${patient.lastVisit}',
                      'Riesgo IA: ${patient.getRiskText()}',
                    ]),
                    const SizedBox(height: 16),

                    // Observaciones
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: patient.adherence < 70 ? Colors.red.shade50 : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                patient.adherence < 70 ? Icons.warning : Icons.info,
                                color: patient.adherence < 70 ? Colors.red : Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Observación Clínica',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: patient.adherence < 70 ? Colors.red : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.observations,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recomendaciones
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Recomendaciones IA',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...report.recommendations.map((rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('• $rec', style: const TextStyle(fontSize: 12)),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botones
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Cerrar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Aquí iría la acción de generar reporte PDF
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Generar Reporte'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item, style: const TextStyle(fontSize: 13)),
          )),
        ],
      ),
    );
  }
}