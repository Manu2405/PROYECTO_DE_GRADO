import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '/core/theme/app_theme.dart';
import '../models/family_models.dart';

class HealthSummaryCard extends StatelessWidget {
  final HealthSummary summary;

  const HealthSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.teal, size: 24),
                SizedBox(width: 8),
                Text(
                  'Resumen de Salud',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    Icons.check_circle,
                    'Adherencia',
                    '${summary.adherenceRate.toInt()}%',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    Icons.cancel,
                    'Omisiones',
                    summary.missedDoses.toString(),
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    Icons.access_time,
                    'Retrasos',
                    summary.delayedDoses.toString(),
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    Icons.calendar_today,
                    'Última Visita',
                    summary.lastCheckup,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    Icons.event,
                    'Próxima Visita',
                    summary.nextCheckup,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}