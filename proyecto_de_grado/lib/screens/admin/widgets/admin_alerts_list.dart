import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_theme.dart';

class AdminAlertsList extends StatelessWidget {
  const AdminAlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAlertCard(
          'Carlos Pérez (Adulto Mayor)',
          'Ha olvidado tomar Losartán por 3 días consecutivos',
          Icons.warning,
          Colors.red,
        ),
        const SizedBox(height: 10),
        _buildAlertCard(
          'María López (Cuidadora)',
          'No ha confirmado la toma de medicamentos de hoy',
          Icons.notification_important,
          Colors.orange,
        ),
        const SizedBox(height: 10),
        _buildAlertCard(
          'Dr. Roberto Gómez (Médico)',
          'Solicita revisión de historial médico',
          Icons.medical_information,
          Colors.blue,
        ),
      ],
    );
  }
  
  Widget _buildAlertCard(String title, String message, IconData icon, Color color) {
    return FadeInUp(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(message),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ),
    );
  }
}