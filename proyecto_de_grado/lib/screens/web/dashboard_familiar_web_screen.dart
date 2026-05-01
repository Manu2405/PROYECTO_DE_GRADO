import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'familiar/widgets/familiar_web_sections.dart';
import 'services/web_pdf_report_service.dart';
import 'widgets/web_role_components.dart';

class DashboardFamiliarWebScreen extends StatefulWidget {
  const DashboardFamiliarWebScreen({super.key});

  @override
  State<DashboardFamiliarWebScreen> createState() => _DashboardFamiliarWebScreenState();
}

class _DashboardFamiliarWebScreenState extends State<DashboardFamiliarWebScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _history = const [
    {'med': 'Losartan', 'time': '08:00', 'status': 'Tomado'},
    {'med': 'Metformina', 'time': '14:00', 'status': 'Tomado'},
    {'med': 'Omeprazol', 'time': '20:00', 'status': 'Pendiente'},
  ];

  final List<String> _alerts = const [
    'Se omitio una dosis de Omeprazol.',
    'Adherencia semanal por debajo de la meta.',
  ];

  void _showProfile() {
    Navigator.pushNamed(context, '/web/profile');
  }

  Widget _buildSection() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: FamiliarWebSummarySection()),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => WebPdfReportService.generateFamilyAdherenceReport(
                  familyName: 'Maria',
                  history: _history,
                ),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generar reporte PDF'),
              ),
            ),
          ],
        );
      case 1:
        return FamiliarWebHistorySection(history: _history);
      case 2:
        return FamiliarWebAlertsSection(alerts: _alerts);
      default:
        return const FamiliarWebSummarySection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebRoleScaffold(
      title: 'Panel Familiar/Cuidador - Web',
      sidebarHeader: const DrawerHeader(
        decoration: BoxDecoration(color: AppTheme.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.family_restroom, color: AppTheme.primaryColor)),
            SizedBox(height: 10),
            Text('Maria (Hija)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      sidebarItems: const [
        WebSidebarItem(icon: Icons.dashboard, label: 'Resumen'),
        WebSidebarItem(icon: Icons.history, label: 'Historial'),
        WebSidebarItem(icon: Icons.notifications, label: 'Alertas'),
      ],
      selectedIndex: _selectedIndex,
      onSelectItem: (index) => setState(() => _selectedIndex = index),
      onProfile: _showProfile,
      onLogout: () => Navigator.pushReplacementNamed(context, '/web/welcome'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildSection(),
      ),
    );
  }
}
