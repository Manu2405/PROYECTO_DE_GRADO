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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
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
        builder: (context, setLocalState) => ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              backgroundColor: const Color(0xFF0F2B3D), // Color del login
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Crear Nuevo Usuario',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: nombreController,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
                        hintText: 'Ej: Juan Pérez',
                        hintStyle: GoogleFonts.inter(color: Colors.white54),
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        hintText: 'usuario@ejemplo.com',
                        hintStyle: GoogleFonts.inter(color: Colors.white54),
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: telefonoController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        hintText: '+34 123 456 789',
                        hintStyle: GoogleFonts.inter(color: Colors.white54),
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      dropdownColor: const Color(0xFF0F2B3D),
                      decoration: InputDecoration(
                        labelText: 'Rol',
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.assignment_ind_rounded, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                      items: const [
                        'Familiar/Cuidador',
                        'Médico',
                        'Adulto Mayor',
                        'Administrador'
                      ].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                      onChanged: (value) => setLocalState(() => selectedRole = value!),
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      dropdownColor: const Color(0xFF0F2B3D),
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.badge_rounded, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                      items: const [
                        'Activo',
                        'Inactivo',
                        'Suspendido'
                      ].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                      onChanged: (value) => setLocalState(() => selectedStatus = value!),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                            ),
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text(
                              'Crear Usuario',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: const Color(0xFF0F2B3D),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.error_outline_rounded, color: Colors.red, size: 52),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text('Aceptar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: const Color(0xFF0F2B3D),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppTheme.successColor, size: 52),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '¡Éxito!',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text('Aceptar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
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
        builder: (context, setLocalState) => ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              backgroundColor: const Color(0xFF0F2B3D),
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.orange, Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Editar Usuario',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: nombreController,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: emailController,
                      enabled: false,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white54),
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.white54),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: telefonoController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                      dropdownColor: const Color(0xFF0F2B3D),
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        labelStyle: GoogleFonts.inter(color: Colors.white70),
                        prefixIcon: Icon(Icons.badge_rounded, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0A1929).withValues(alpha: 0.5),
                      ),
                      items: const [
                        'Activo',
                        'Inactivo',
                        'Suspendido'
                      ].map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                      onChanged: (value) => setLocalState(() => selectedStatus = value!),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                            ),
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text(
                              'Actualizar',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: const Color(0xFF0F2B3D),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 52),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Eliminar Usuario',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¿Estás seguro de que deseas eliminar a ${user['nombre']}?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Cancelar',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          ),
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Eliminar',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Función para generar reporte PDF
  void _handleGeneratePdf(String reportType, DateTime? fechaInicio, DateTime? fechaFin) {
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
      case 'actividad':
        print('Reporte de actividad con fechas: $fechaInicio - $fechaFin');
        break;
      case 'salud':
        print('Reporte de salud con fechas: $fechaInicio - $fechaFin');
        break;
      case 'alertas':
        print('Reporte de alertas con fechas: $fechaInicio - $fechaFin');
        break;
      default:
        print('Tipo de reporte no reconocido: $reportType');
    }
    _showSuccessDialog('Reporte de $reportType generado exitosamente');
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
        return AdminWebDashboardSection(stats: _stats);
      case 1:
        return AdminWebReportsSection(
          stats: _stats,
          onGeneratePdf: _handleGeneratePdf,
        );
      case 2:
        return AdminWebUsersSection(
          users: _users,
          onCreateUser: _showCreateUserDialog,
          onEditUser: _showEditUserDialog,
          onDeleteUser: _showDeleteUserDialog,
        );
      case 3:
        return const AdminWebManagementSection();
      default:
        return AdminWebDashboardSection(stats: _stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1929),
              Color(0xFF0F2B3D),
              Color(0xFF1A3A4F),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: WebRoleScaffold(
          title: 'Panel de Administración',
          sidebarHeader: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
              ),
              borderRadius: BorderRadius.only(
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: AppTheme.primaryColor, size: 40),
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
            WebSidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
            WebSidebarItem(icon: Icons.report_rounded, label: 'Reportes'),
            WebSidebarItem(icon: Icons.people_rounded, label: 'Usuarios'),
            WebSidebarItem(icon: Icons.settings_rounded, label: 'Gestión'),
          ],
          selectedIndex: _selectedIndex,
          onSelectItem: (index) => setState(() => _selectedIndex = index),
          onProfile: _showProfile,
          onLogout: () {
            showDialog(
              context: context,
              builder: (context) => ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: const Color(0xFF0F2B3D),
                    title: Text(
                      'Cerrar Sesión',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    content: Text(
                      '¿Estás seguro de que deseas cerrar sesión?',
                      style: GoogleFonts.inter(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white70),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/web/welcome'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Cerrar Sesión',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          body: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: _buildSection(),
            ),
          ),
        ),
      ),
    );
  }
}