import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/ai_voice_button.dart';
import '../auth/login_screen.dart';

class DashboardAdultoScreen extends StatelessWidget {
  const DashboardAdultoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '¡Hola, Don Carlos!',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppTheme.primaryColor,
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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, color: Colors.white, size: 40),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Próxima Toma',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Losartán 50mg',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'A las 14:30 (En 15 min)',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
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
                    child: Text(
                      'Tus Medicamentos de Hoy',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _MedicationCard(
                      name: 'Aspirina Protect',
                      time: '08:00',
                      status: 'Tomado',
                      iconColor: AppTheme.successColor,
                      icon: Icons.check_circle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: _MedicationCard(
                      name: 'Losartán 50mg',
                      time: '14:30',
                      status: 'Pendiente',
                      iconColor: AppTheme.secondaryColor,
                      icon: Icons.access_time_filled,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _MedicationCard(
                      name: 'Metformina 850mg',
                      time: '20:00',
                      status: 'Pendiente',
                      iconColor: AppTheme.textSecondary,
                      icon: Icons.access_time,
                    ),
                  ),
                  
                  // Espacio para que el botón de IA no tape el contenido final
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          
          // Botón IA posicionado en el centro inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: AiVoiceButton(
                onTap: () {
                  // Acción adicional si es necesaria, la lógica ya está en el widget
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final String name;
  final String time;
  final String status;
  final Color iconColor;
  final IconData icon;

  const _MedicationCard({
    required this.name,
    required this.time,
    required this.status,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(FontAwesomeIcons.pills, color: iconColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Hora: $time', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Column(
              children: [
                Icon(icon, color: iconColor, size: 30),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
