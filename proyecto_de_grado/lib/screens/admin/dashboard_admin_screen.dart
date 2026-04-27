import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        elevation: 0,
        title: const Text(
          'Administración Central',
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
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueGrey.shade800,
                      child: const FaIcon(FontAwesomeIcons.buildingUser, color: Colors.white, size: 25),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hogar "La Casa del Abuelo"',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Panel Operacional',
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
                  'Gestión del Sistema',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _AdminMenuCard(
                        icon: FontAwesomeIcons.usersGear,
                        title: 'Usuarios y Roles',
                        color: Colors.orange,
                        onTap: () {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _AdminMenuCard(
                        icon: FontAwesomeIcons.link,
                        title: 'Asignar Paciente a Cuidador',
                        color: Colors.blue,
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FadeInLeft(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'Reportes Institucionales',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 15),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tasa de Adherencia Global:', style: TextStyle(fontSize: 16)),
                            Text('88%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                          ],
                        ),
                        Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Alertas IA Activas:', style: TextStyle(fontSize: 16)),
                            Text('4', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
                          ],
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

class _AdminMenuCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            FaIcon(icon, color: color, size: 35),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
