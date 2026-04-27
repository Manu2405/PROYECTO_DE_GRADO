import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class DashboardMedicoScreen extends StatelessWidget {
  const DashboardMedicoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: const Text(
          'Panel Médico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
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
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.indigo,
                      child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dr. Roberto',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Geriatría',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInLeft(
                child: Text(
                  'Pacientes Activos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 15),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      child: const Text('C', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                    title: const Text('Carlos (78 años)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Adherencia: 92% | Riesgo IA: Bajo'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Simular abrir expediente
                    },
                  ),
                ),
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.errorColor.withValues(alpha: 0.2),
                      child: const Text('M', style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold)),
                    ),
                    title: const Text('María (82 años)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Adherencia: 65% | Riesgo IA: Alto', style: TextStyle(color: AppTheme.errorColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: Column(
                    children: [
                      const FaIcon(FontAwesomeIcons.chartLine, color: Colors.indigo, size: 40),
                      const SizedBox(height: 15),
                      const Text(
                        'Reportes Mensuales Disponibles',
                        style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        child: const Text('Descargar Informe Consolidado'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
