import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'medico/widgets/medico_web_sections.dart';
import 'services/web_pdf_report_service.dart';
import 'widgets/web_role_components.dart';

class DashboardMedicoWebScreen extends StatefulWidget {
  const DashboardMedicoWebScreen({super.key});

  @override
  State<DashboardMedicoWebScreen> createState() => _DashboardMedicoWebScreenState();
}

class _DashboardMedicoWebScreenState extends State<DashboardMedicoWebScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _riskFilter = 'Todos';

  final List<Map<String, String>> _patients = [
    {'name': 'Carlos Ramirez', 'diagnosis': 'Hipertension', 'risk': 'Alto', 'adherence': '74'},
    {'name': 'Rosa Mendez', 'diagnosis': 'Diabetes II', 'risk': 'Medio', 'adherence': '88'},
    {'name': 'Manuel Pardo', 'diagnosis': 'Artritis', 'risk': 'Bajo', 'adherence': '93'},
    {'name': 'Elena Castro', 'diagnosis': 'EPOC', 'risk': 'Alto', 'adherence': '69'},
  ];

  List<Map<String, String>> get _filteredPatients {
    return _patients.where((p) {
      final matchSearch = _searchQuery.isEmpty ||
          p['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p['diagnosis']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchRisk = _riskFilter == 'Todos' || p['risk'] == _riskFilter;
      return matchSearch && matchRisk;
    }).toList();
  }

  double get _globalAdherence {
    if (_patients.isEmpty) return 0;
    final sum = _patients.map((p) => int.parse(p['adherence']!)).reduce((a, b) => a + b);
    return sum / _patients.length;
  }

  int get _highRiskCount => _patients.where((p) => p['risk'] == 'Alto').length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProfile() {
    Navigator.pushNamed(context, '/web/profile');
  }

  void _showNewPlanDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo plan de tratamiento'),
        content: const Text('Flujo de creacion de plan listo para integrar con backend.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _showReportDialog() {
    WebPdfReportService.generateMedicalReport(
      patients: _filteredPatients,
      globalAdherence: _globalAdherence,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebRoleScaffold(
      title: 'Panel Medico - Web',
      sidebarHeader: const DrawerHeader(
        decoration: BoxDecoration(color: AppTheme.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.medical_services, color: AppTheme.primaryColor)),
            SizedBox(height: 10),
            Text('Dr. Roberto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      sidebarItems: const [
        WebSidebarItem(icon: Icons.people, label: 'Pacientes'),
        WebSidebarItem(icon: Icons.note_add, label: 'Nuevo plan'),
        WebSidebarItem(icon: Icons.download, label: 'Reportes'),
      ],
      selectedIndex: 0,
      onSelectItem: (index) {
        if (index == 1) _showNewPlanDialog();
        if (index == 2) _showReportDialog();
      },
      onProfile: _showProfile,
      onLogout: () => Navigator.pushReplacementNamed(context, '/web/welcome'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicoWebHeaderSection(
              totalPatients: _patients.length,
              highRisk: _highRiskCount,
              adherence: _globalAdherence,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: const InputDecoration(
                      hintText: 'Buscar paciente o diagnostico...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 170,
                  child: DropdownButtonFormField<String>(
                    initialValue: _riskFilter,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: const ['Todos', 'Bajo', 'Medio', 'Alto']
                        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (value) => setState(() => _riskFilter = value ?? 'Todos'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            MedicoWebPatientsSection(patients: _filteredPatients),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _showNewPlanDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo plan'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _showReportDialog,
                  icon: const Icon(Icons.download),
                  label: const Text('Generar reporte'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
