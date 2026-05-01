import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class FamiliarWebSummarySection extends StatelessWidget {
  const FamiliarWebSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen del paciente', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _Metric(title: 'Adherencia semanal', value: '92%', icon: Icons.check_circle, color: AppTheme.successColor),
              _Metric(title: 'Proxima toma', value: '14:00', icon: Icons.access_time, color: AppTheme.secondaryColor),
              _Metric(title: 'Alertas activas', value: '1', icon: Icons.notifications_active, color: AppTheme.primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}

class FamiliarWebHistorySection extends StatelessWidget {
  final List<Map<String, String>> history;

  const FamiliarWebHistorySection({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: history.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          leading: Icon(item['status'] == 'Tomado' ? Icons.check_circle : Icons.access_time, color: item['status'] == 'Tomado' ? Colors.green : Colors.orange),
          title: Text(item['med']!),
          subtitle: Text('Hora: ${item['time']}'),
          trailing: Text(item['status']!),
        );
      },
    );
  }
}

class FamiliarWebAlertsSection extends StatelessWidget {
  final List<String> alerts;

  const FamiliarWebAlertsSection({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Center(child: Text('No hay alertas recientes'));
    }

    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.warning_amber, color: AppTheme.secondaryColor),
            title: Text(alerts[index]),
          ),
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _Metric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
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
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppTheme.textSecondary)),
                  Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
