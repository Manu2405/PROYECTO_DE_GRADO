import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MedicoWebHeaderSection extends StatelessWidget {
  final int totalPatients;
  final int highRisk;
  final double adherence;

  const MedicoWebHeaderSection({
    super.key,
    required this.totalPatients,
    required this.highRisk,
    required this.adherence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard clinico', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Metric(title: 'Pacientes', value: '$totalPatients', icon: Icons.people),
            _Metric(title: 'Riesgo alto', value: '$highRisk', icon: Icons.warning),
            _Metric(title: 'Adherencia global', value: '${adherence.toInt()}%', icon: Icons.trending_up),
          ],
        ),
      ],
    );
  }
}

class MedicoWebPatientsSection extends StatelessWidget {
  final List<Map<String, String>> patients;

  const MedicoWebPatientsSection({
    super.key,
    required this.patients,
  });

  @override
  Widget build(BuildContext context) {
    if (patients.isEmpty) {
      return const Center(child: Text('No se encontraron pacientes'));
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppTheme.primaryColor.withValues(alpha: 0.1)),
          columns: const [
            DataColumn(label: Text('Paciente')),
            DataColumn(label: Text('Diagnostico')),
            DataColumn(label: Text('Riesgo')),
            DataColumn(label: Text('Adherencia')),
          ],
          rows: patients
              .map(
                (p) => DataRow(
                  cells: [
                    DataCell(Text(p['name']!)),
                    DataCell(Text(p['diagnosis']!)),
                    DataCell(Text(p['risk']!)),
                    DataCell(Text('${p['adherence']}%')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _Metric({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textSecondary)),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
