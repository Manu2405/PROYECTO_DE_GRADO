import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class DashboardFamiliarScreen extends StatelessWidget {
  const DashboardFamiliarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Monitoreo: Carlos',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: AppTheme.textSecondary),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(FontAwesomeIcons.heartPulse, color: Colors.teal, size: 30),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Adherencia Semanal',
                              style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '92% Excelente',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeInLeft(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Historial de Hoy',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Ver todo', style: TextStyle(color: Colors.teal)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: _HistoryCard(
                  name: 'Aspirina Protect',
                  time: '08:00',
                  status: 'Tomado a tiempo',
                  isSuccess: true,
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: _HistoryCard(
                  name: 'Losartán 50mg',
                  time: '14:30',
                  status: 'Pendiente',
                  isSuccess: null,
                ),
              ),
              const SizedBox(height: 30),
              FadeInLeft(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'Alertas IA Recientes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.errorColor),
                ),
              ),
              const SizedBox(height: 15),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Card(
                  color: AppTheme.errorColor.withValues(alpha: 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: AppTheme.errorColor.withValues(alpha: 0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.triangleExclamation, color: AppTheme.errorColor),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Patrón de Omisión Detectado',
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.errorColor),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Carlos ha retrasado la toma nocturna de Metformina los últimos 3 días. Considere ajustar el horario.',
                                style: TextStyle(color: AppTheme.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String name;
  final String time;
  final String status;
  final bool? isSuccess;

  const _HistoryCard({
    required this.name,
    required this.time,
    required this.status,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = isSuccess == null
        ? AppTheme.secondaryColor
        : (isSuccess! ? AppTheme.successColor : AppTheme.errorColor);
    IconData icon = isSuccess == null
        ? Icons.access_time_filled
        : (isSuccess! ? Icons.check_circle : Icons.cancel);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: statusColor, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Programado: $time', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
