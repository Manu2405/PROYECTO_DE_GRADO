import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'admin/widgets/admin_web_dashboard_section.dart';
import 'admin/widgets/admin_web_reports_section.dart';
import 'admin/widgets/admin_web_users_section.dart';
import 'admin/widgets/admin_web_management_section.dart';
import 'services/web_pdf_report_service.dart';
import 'widgets/web_role_components.dart';

class DashboardAdminWebScreen extends StatefulWidget {
  const DashboardAdminWebScreen({super.key});

  @override
  State<DashboardAdminWebScreen> createState() => _DashboardAdminWebScreenState();
}

class _DashboardAdminWebScreenState extends State<DashboardAdminWebScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isDarkMode = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Map<String, dynamic>> _users = [
    {
      'nombre': 'Ana Pérez',
      'email': 'ana@vitasenior.com',
      'rol': 'Familiar/Cuidador',
      'estado': 'Activo',
      'fechaRegistro': DateTime(2024, 1, 15),
      'telefono': '+34 612 345 678'
    },
    {
      'nombre': 'Dr. Carlos Ruiz',
      'email': 'ruiz@vitasenior.com',
      'rol': 'Médico',
      'estado': 'Activo',
      'fechaRegistro': DateTime(2024, 2, 20),
      'telefono': '+34 623 456 789'
    },
    {
      'nombre': 'María González',
      'email': 'maria@vitasenior.com',
      'rol': 'Adulto Mayor',
      'estado': 'Activo',
      'fechaRegistro': DateTime(2024, 3, 10),
      'telefono': '+34 634 567 890'
    },
    {
      'nombre': 'Pedro Martínez',
      'email': 'pedro@vitasenior.com',
      'rol': 'Familiar/Cuidador',
      'estado': 'Inactivo',
      'fechaRegistro': DateTime(2024, 4, 5),
      'telefono': '+34 645 678 901'
    },
  ];

  // Estadísticas del dashboard
  final Map<String, dynamic> _stats = {
    'totalUsuarios': 1250,
    'usuariosActivos': 1180,
    'pacientes': 450,
    'medicos': 85,
    'familiares': 700,
    'reportesGenerados': 3450,
    'alertasUltimoMes': 128,
    'tasaAdherencia': 87,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showProfile() {
    Navigator.pushNamed(context, '/web/profile');
  }

  void _showCreateUserDialog() {
    final nombreController = TextEditingController();
    final emailController = TextEditingController();
    final telefonoController = TextEditingController();
    String selectedRole = 'Familiar/Cuidador';
    String selectedStatus = 'Activo';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_add, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Crear Nuevo Usuario',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    hintText: 'Ej: Juan Pérez',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    hintText: 'usuario@ejemplo.com',
                    prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    hintText: '+34 123 456 789',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Rol',
                    prefixIcon: Icon(Icons.assignment_ind, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: const [
                    'Familiar/Cuidador',
                    'Médico',
                    'Adulto Mayor',
                    'Administrador'
                  ].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                  onChanged: (value) => setLocalState(() => selectedRole = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    prefixIcon: Icon(Icons.badge, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: const [
                    'Activo',
                    'Inactivo',
                    'Suspendido'
                  ].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                  onChanged: (value) => setLocalState(() => selectedStatus = value!),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nombreController.text.isEmpty || emailController.text.isEmpty) {
                            _showErrorDialog('Por favor complete todos los campos obligatorios');
                            return;
                          }
                          setState(() {
                            _users.insert(0, {
                              'nombre': nombreController.text,
                              'email': emailController.text,
                              'telefono': telefonoController.text.isEmpty ? 'No especificado' : telefonoController.text,
                              'rol': selectedRole,
                              'estado': selectedStatus,
                              'fechaRegistro': DateTime.now(),
                            });
                          });
                          Navigator.pop(context);
                          _showSuccessDialog('Usuario creado exitosamente');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Crear Usuario'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline, color: Colors.red, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppTheme.successColor, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                '¡Éxito!',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    final nombreController = TextEditingController(text: user['nombre']);
    final emailController = TextEditingController(text: user['email']);
    final telefonoController = TextEditingController(text: user['telefono'] ?? '');
    String selectedStatus = user['estado'];

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Editar Usuario',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    prefixIcon: Icon(Icons.badge, color: AppTheme.primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: const [
                    'Activo',
                    'Inactivo',
                    'Suspendido'
                  ].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                  onChanged: (value) => setLocalState(() => selectedStatus = value!),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final index = _users.indexWhere((u) => u['email'] == user['email']);
                            if (index != -1) {
                              _users[index]['nombre'] = nombreController.text;
                              _users[index]['telefono'] = telefonoController.text;
                              _users[index]['estado'] = selectedStatus;
                            }
                          });
                          Navigator.pop(context);
                          _showSuccessDialog('Usuario actualizado exitosamente');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Actualizar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber, color: Colors.red, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Eliminar Usuario',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '¿Estás seguro de que deseas eliminar a ${user['nombre']}?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _users.removeWhere((u) => u['email'] == user['email']);
                        });
                        Navigator.pop(context);
                        _showSuccessDialog('Usuario eliminado exitosamente');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Eliminar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return AdminWebDashboardSection(stats: _stats, isDarkMode: _isDarkMode);
      case 1:
        return AdminWebReportsSection(
          stats: _stats,
          isDarkMode: _isDarkMode,
          onGeneratePdf: (String reportType) {
            switch (reportType) {
              case 'usuarios':
                WebPdfReportService.generateAdminUsersReport(
                  users: _users.map((user) => {
                    'nombre': user['nombre'].toString(),
                    'email': user['email'].toString(),
                    'rol': user['rol'].toString(),
                    'estado': user['estado'].toString(),
                  }).toList(),
                );
                break;
              default:
                print('Tipo de reporte no reconocido: $reportType');
            }
            _showSuccessDialog('Reporte de $reportType generado exitosamente');
          },
        );
      case 2:
        return AdminWebUsersSection(
          users: _users,
          isDarkMode: _isDarkMode,
          onCreateUser: _showCreateUserDialog,
          onEditUser: _showEditUserDialog,
          onDeleteUser: _showDeleteUserDialog,
        );
      case 3:
        return AdminWebManagementSection(isDarkMode: _isDarkMode);
      default:
        return AdminWebDashboardSection(stats: _stats, isDarkMode: _isDarkMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDarkMode
                ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2D2D2D),
                    const Color(0xFF1A1A1A),
                  ]
                : [
                    const Color(0xFF0A1929),
                    const Color(0xFF0F2B3D),
                    const Color(0xFF1A3A4F),
                    Colors.grey[900]!,
                  ],
          ),
        ),
        child: WebRoleScaffold(
          title: 'Panel de Administración - Web',
          isDarkMode: _isDarkMode,
          onToggleTheme: _toggleTheme,
          sidebarHeader: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, const Color(0xFF0EA5E9)],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.admin_panel_settings, color: AppTheme.primaryColor, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Super Admin',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Administrador Principal',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          sidebarItems: const [
            WebSidebarItem(icon: Icons.dashboard, label: 'Dashboard'),
            WebSidebarItem(icon: Icons.report, label: 'Reportes'),
            WebSidebarItem(icon: Icons.people, label: 'Usuarios'),
            WebSidebarItem(icon: Icons.settings, label: 'Gestión'),
          ],
          selectedIndex: _selectedIndex,
          onSelectItem: (index) => setState(() => _selectedIndex = index),
          onProfile: _showProfile,
          onLogout: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text('Cerrar Sesión'),
                content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/web/welcome'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildSection(),
          ),
        ),
      ),
    );
  }
}