import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import './models/medical_models.dart';
import './services/medical_service.dart';
import './widgets/patient_card.dart';
import './widgets/patient_detail_dialog.dart';
import './widgets/generate_report_dialog.dart';
import '../auth/login_screen.dart';

class DashboardMedicoScreen extends StatefulWidget {
  const DashboardMedicoScreen({super.key});

  @override
  State<DashboardMedicoScreen> createState() => _DashboardMedicoScreenState();
}

class _DashboardMedicoScreenState extends State<DashboardMedicoScreen> {
  final List<Patient> _patients = MedicalService.getPatients();
  String _searchQuery = '';
  String _filterRisk = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  List<Patient> get _filteredPatients {
    var filtered = _patients;
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.diagnosis.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_filterRisk != 'Todos') {
      final riskLevel = _filterRisk == 'Bajo' ? RiskLevel.low : 
                        _filterRisk == 'Medio' ? RiskLevel.medium : RiskLevel.high;
      filtered = filtered.where((p) => p.riskLevel == riskLevel).toList();
    }
    
    return filtered;
  }

  double get _globalAdherence {
    if (_patients.isEmpty) return 0;
    return _patients.map((p) => p.adherence).reduce((a, b) => a + b) / _patients.length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => GenerateReportDialog(
        patients: _patients,
        globalAdherence: _globalAdherence,
      ),
    );
  }

  void _showNewPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Plan de Tratamiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Seleccionar Paciente',
                border: OutlineInputBorder(),
              ),
              items: _patients.map((patient) {
                return DropdownMenuItem(
                  value: patient.id,
                  child: Text(patient.name),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dosis',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horario',
                border: OutlineInputBorder(),
                hintText: 'Ej: 08:00, 14:00, 20:00',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Plan de tratamiento creado exitosamente')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Crear Plan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar paciente...',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                        prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterRisk,
                      icon: Icon(Icons.filter_list, color: Colors.white.withValues(alpha: 0.7), size: 20),
                      dropdownColor: Colors.indigo.shade700,
                      style: const TextStyle(color: Colors.white),
                      items: ['Todos', 'Bajo', 'Medio', 'Alto'].map((risk) {
                        return DropdownMenuItem(value: risk, child: Text(risk));
                      }).toList(),
                      onChanged: (value) => setState(() => _filterRisk = value!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de bienvenida
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.userDoctor,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bienvenido, Dr. Roberto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Geriatría • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Estadísticas rápidas
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pacientes',
                    _patients.length.toString(),
                    Icons.people,
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Adherencia Global',
                    '${_globalAdherence.toInt()}%',
                    Icons.trending_up,
                    _globalAdherence >= 80 ? Colors.green : _globalAdherence >= 60 ? Colors.orange : Colors.red,
                  ),
                ),
                if (!isSmallScreen) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Riesgo Alto',
                      _patients.where((p) => p.riskLevel == RiskLevel.high).length.toString(),
                      Icons.warning,
                      Colors.red,
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Asociación familiar/cuidador
            FadeInLeft(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.family_restroom, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seguimiento Familiar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Familiares y cuidadores pueden monitorear el progreso',
                            style: TextStyle(fontSize: 12, color: Colors.teal.shade700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Activo',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de pacientes
            FadeInLeft(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mis Pacientes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${_filteredPatients.length} pacientes',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            if (_filteredPatients.isEmpty)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No se encontraron pacientes',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else
              ..._filteredPatients.asMap().entries.map((entry) {
                final index = entry.key;
                final patient = entry.value;
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PatientCard(
                      patient: patient,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PatientDetailDialog(patient: patient),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            
            const SizedBox(height: 24),
            
            // Acciones rápidas
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade50, Colors.indigo.shade100],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Column(
                  children: [
                    const FaIcon(FontAwesomeIcons.fileMedical, color: Colors.indigo, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      'Reportes Clínicos',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Descarga informes consolidados de adherencia',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.indigo, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _generateReport,
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Generar Reporte'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FadeIn(
        child: FloatingActionButton.extended(
          onPressed: _showNewPlanDialog,
          backgroundColor: Colors.indigo,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Nuevo Plan', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}