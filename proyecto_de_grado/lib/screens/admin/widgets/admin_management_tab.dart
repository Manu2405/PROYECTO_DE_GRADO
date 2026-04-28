import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_theme.dart';
import '../services/pdf_export_service.dart';

class AdminManagementTab extends StatelessWidget {
  const AdminManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: Text(
              'Configuración del Sistema',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tarjetas de gestión
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildManagementCard(
                'Asignar Paciente a Cuidador',
                'Vincular familiar responsable con adulto mayor',
                Icons.link,
                Colors.blue,
                () => _showAssignmentDialog(context),
              ),
              _buildManagementCard(
                'Ver Historial de Tomas',
                'Acceso completo al historial de medicamentos',
                Icons.history,
                Colors.teal,
                () => _showHistoryDialog(context),
              ),
              _buildManagementCard(
                'Generar Reportes',
                'Exportar estadísticas de cumplimiento',
                Icons.description,
                Colors.orange,
                () => _showExportOptionsDialog(context),
              ),
              _buildManagementCard(
                'Configurar Alertas',
                'Notificaciones para familiares y cuidadores',
                Icons.notifications_active,
                Colors.purple,
                () => _showAlertsDialog(context),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Sección de acceso a reportes para autorizados
          FadeInLeft(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade800],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.security, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'Acceso a Reportes para Autorizados',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Familiares y cuidadores pueden acceder a reportes de seguimiento',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showPermissionsDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueGrey.shade800,
                    ),
                    child: const Text('Gestionar Permisos'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildManagementCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  
  void _showAssignmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Asignar Paciente a Cuidador'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Seleccionar Paciente'),
              items: const [
                DropdownMenuItem(value: 'Carlos Pérez', child: Text('Carlos Pérez')),
                DropdownMenuItem(value: 'Ana Rodríguez', child: Text('Ana Rodríguez')),
                DropdownMenuItem(value: 'Luis Martínez', child: Text('Luis Martínez')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Seleccionar Cuidador'),
              items: const [
                DropdownMenuItem(value: 'María López', child: Text('María López')),
                DropdownMenuItem(value: 'Juan García', child: Text('Juan García')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Asignación realizada exitosamente')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('Asignar'),
          ),
        ],
      ),
    );
  }
  
  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Historial de Tomas'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Seleccionar Usuario'),
                items: const [
                  DropdownMenuItem(value: 'Carlos Pérez', child: Text('Carlos Pérez')),
                  DropdownMenuItem(value: 'Ana Rodríguez', child: Text('Ana Rodríguez')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Historial exportado a PDF')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Exportar Historial'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }
  
  void _showExportOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar Reportes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Exportar a PDF'),
              onTap: () async {
                Navigator.pop(context);
                await PdfExportService.generateReport(
                  title: 'Reporte General del Sistema',
                  data: [],
                  headers: [],
                  columns: [],
                  totalAdherence: 88.0,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reporte PDF generado')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Exportar a Excel (CSV)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reporte CSV generado')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAlertsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurar Alertas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Alertas de medicamentos'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Alertas a familiares'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Alertas a médicos'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Guardar')),
        ],
      ),
    );
  }
  
  void _showPermissionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gestionar Permisos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Familiares'),
              trailing: const Icon(Icons.visibility),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Médicos'),
              trailing: const Icon(Icons.visibility),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.elderly),
              title: const Text('Adultos Mayores'),
              trailing: const Icon(Icons.visibility_off),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}