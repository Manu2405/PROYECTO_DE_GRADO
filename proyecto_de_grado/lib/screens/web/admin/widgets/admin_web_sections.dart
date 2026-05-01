import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AdminWebDashboardSection extends StatelessWidget {
  const AdminWebDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard general', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _Metric(title: 'Usuarios', value: '1248', icon: Icons.group),
              _Metric(title: 'Adherencia', value: '87%', icon: Icons.trending_up),
              _Metric(title: 'Alertas', value: '4', icon: Icons.warning_amber),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminWebReportsSection extends StatelessWidget {
  final VoidCallback onGeneratePdf;

  const AdminWebReportsSection({
    super.key,
    required this.onGeneratePdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reportes operativos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Visualiza tendencias de adherencia y eventos del sistema.'),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onGeneratePdf,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Generar reporte PDF'),
          ),
        ],
      ),
    );
  }
}

class AdminWebUsersSection extends StatelessWidget {
  final List<Map<String, String>> users;
  final VoidCallback onCreateUser;

  const AdminWebUsersSection({
    super.key,
    required this.users,
    required this.onCreateUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Gestion de usuarios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton.icon(
              onPressed: onCreateUser,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Crear usuario'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 860),
              child: DataTable(
                columnSpacing: 28,
                headingRowColor: WidgetStateProperty.all(AppTheme.primaryColor.withValues(alpha: 0.08)),
                columns: const [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Rol')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: users
                    .map(
                      (user) => DataRow(
                        cells: [
                          DataCell(Text(user['nombre']!)),
                          DataCell(Text(user['email']!)),
                          DataCell(Text(user['rol']!)),
                          DataCell(Text(user['estado']!)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AdminWebManagementSection extends StatelessWidget {
  const AdminWebManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gestion del sistema', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Configura roles, accesos y parametros institucionales.'),
        ],
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
      width: 250,
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
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
