import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../auth/services/auth_service.dart';
import '../auth/models/user_auth_model.dart';

class WebProfileScreen extends StatefulWidget {
  const WebProfileScreen({super.key});

  @override
  State<WebProfileScreen> createState() => _WebProfileScreenState();
}

class _WebProfileScreenState extends State<WebProfileScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  late NotificationPreferences _notificationsPrefs;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone ?? '';
      _notificationsPrefs = user.notificationPreferences;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // Validaciones
    if (_nameController.text.trim().isEmpty) {
      await _showErrorDialog('Por favor ingresa tu nombre');
      return;
    }
    if (_lastNameController.text.trim().isEmpty) {
      await _showErrorDialog('Por favor ingresa tu apellido');
      return;
    }
    if (_nameController.text.trim().length < 2) {
      await _showErrorDialog('El nombre debe tener al menos 2 caracteres');
      return;
    }
    if (_lastNameController.text.trim().length < 2) {
      await _showErrorDialog('El apellido debe tener al menos 2 caracteres');
      return;
    }

    setState(() => _saving = true);
    try {
      await AuthService.updateProfile(
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      
      // Nota: Las preferencias de notificaciones se actualizan localmente
      // En una implementación real, deberías tener un método en AuthService
      // para persistir estas preferencias en el backend
      
      if (!mounted) return;
      setState(() => _editing = false);
      await _showSuccessDialog('Perfil actualizado correctamente');
    } catch (e) {
      if (!mounted) return;
      await _showErrorDialog('Error al actualizar: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_outline, color: Colors.red, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Entendido', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSuccessDialog(String message) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline, color: AppTheme.successColor, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  '¡Éxito!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Continuar', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Estás seguro que deseas cerrar sesión?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          AuthService.logout();
                          Navigator.pushNamedAndRemoveUntil(context, '/web/welcome', (_) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cerrar Sesión'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A1929),
              const Color(0xFF0F2B3D),
              const Color(0xFF1A3A4F),
              Colors.grey[900]!,
            ],
          ),
        ),
        child: user == null
            ? const Center(child: Text('No hay usuario en sesión', style: TextStyle(color: Colors.white)))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        // Tarjeta de perfil principal
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header con foto de perfil
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Avatar
                                    _buildAvatar(user),
                                    const SizedBox(height: 20),
                                    Text(
                                      user.fullName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        user.role,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (user.emailVerified) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.verified, color: Colors.green[300], size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Email verificado',
                                            style: GoogleFonts.inter(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // Contenido del perfil
                              Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Información personal
                                    Text(
                                      'Información Personal',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildInfoRow(
                                      'Correo Electrónico',
                                      user.email,
                                      Icons.email_outlined,
                                      enabled: false,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      'Nombre',
                                      user.name,
                                      Icons.person_outline,
                                      controller: _nameController,
                                      enabled: _editing,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      'Apellido',
                                      user.lastName,
                                      Icons.person_outline,
                                      controller: _lastNameController,
                                      enabled: _editing,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      'Teléfono',
                                      user.phone ?? 'No especificado',
                                      Icons.phone_outlined,
                                      controller: _phoneController,
                                      enabled: _editing,
                                      isPhone: true,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInfoRow(
                                      'Miembro desde',
                                      _formatDate(user.createdAt),
                                      Icons.calendar_today_outlined,
                                      enabled: false,
                                    ),
                                    
                                    const SizedBox(height: 32),
                                    Divider(color: Colors.grey[200]),
                                    const SizedBox(height: 32),
                                    
                                    // Preferencias de notificaciones
                                    Row(
                                      children: [
                                        Icon(Icons.notifications_outlined, color: AppTheme.primaryColor),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Preferencias de Notificaciones',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildNotificationSwitch(
                                      'Recordatorios de medicamentos',
                                      'Recibe alertas para la toma de medicamentos',
                                      Icons.medication,
                                      _notificationsPrefs.medicationReminders,
                                      (value) {
                                        setState(() {
                                          _notificationsPrefs = _notificationsPrefs.copyWith(
                                            medicationReminders: value,
                                          );
                                        });
                                      },
                                      enabled: _editing,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildNotificationSwitch(
                                      'Recordatorios de citas',
                                      'Notificaciones sobre citas médicas programadas',
                                      Icons.calendar_today,
                                      _notificationsPrefs.appointmentReminders,
                                      (value) {
                                        setState(() {
                                          _notificationsPrefs = _notificationsPrefs.copyWith(
                                            appointmentReminders: value,
                                          );
                                        });
                                      },
                                      enabled: _editing,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildNotificationSwitch(
                                      'Alertas de reportes',
                                      'Notificaciones cuando se generen nuevos reportes',
                                      Icons.picture_as_pdf,
                                      _notificationsPrefs.reportAlerts,
                                      (value) {
                                        setState(() {
                                          _notificationsPrefs = _notificationsPrefs.copyWith(
                                            reportAlerts: value,
                                          );
                                        });
                                      },
                                      enabled: _editing,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildNotificationSwitch(
                                      'Actualizaciones familiares',
                                      'Recibe información sobre el progreso',
                                      Icons.family_restroom,
                                      _notificationsPrefs.familyUpdates,
                                      (value) {
                                        setState(() {
                                          _notificationsPrefs = _notificationsPrefs.copyWith(
                                            familyUpdates: value,
                                          );
                                        });
                                      },
                                      enabled: _editing,
                                    ),
                                    
                                    const SizedBox(height: 32),
                                    Divider(color: Colors.grey[200]),
                                    const SizedBox(height: 24),
                                    
                                    // Botones de acción
                                    Row(
                                      children: [
                                        if (_editing) ...[
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: _saving ? null : () {
                                                setState(() {
                                                  _editing = false;
                                                  // Resetear valores
                                                  final user = AuthService.currentUser;
                                                  if (user != null) {
                                                    _nameController.text = user.name;
                                                    _lastNameController.text = user.lastName;
                                                    _phoneController.text = user.phone ?? '';
                                                    _notificationsPrefs = user.notificationPreferences;
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.close),
                                              label: const Text('Cancelar'),
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: _saving ? null : _save,
                                              icon: _saving
                                                  ? const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: CircularProgressIndicator(strokeWidth: 2),
                                                    )
                                                  : const Icon(Icons.save),
                                              label: Text(_saving ? 'Guardando...' : 'Guardar Cambios'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.primaryColor,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () => setState(() => _editing = true),
                                              icon: const Icon(Icons.edit),
                                              label: const Text('Editar Perfil'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.primaryColor,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: _showLogoutDialog,
                                              icon: const Icon(Icons.logout),
                                              label: const Text('Cerrar Sesión'),
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(color: Colors.red),
                                                foregroundColor: Colors.red,
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

  Widget _buildAvatar(UserAuthModel user) {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(user.photoUrl!),
        onBackgroundImageError: (_, __) {
          // Si hay error al cargar la imagen, mostrar iniciales
        },
      );
    }
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFE0E7FF)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 58,
        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
        child: Text(
          user.initials,
          style: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    TextEditingController? controller,
    bool enabled = false,
    bool isPhone = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (controller != null && enabled)
                  TextFormField(
                    controller: controller,
                    keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Ingrese $label',
                    ),
                  )
                else
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged, {
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppTheme.primaryColor,
            activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}