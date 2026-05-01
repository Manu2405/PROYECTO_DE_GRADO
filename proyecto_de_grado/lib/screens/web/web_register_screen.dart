import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/theme/app_theme.dart';
import '../auth/services/auth_service.dart';

class WebRegisterScreen extends StatefulWidget {
  const WebRegisterScreen({super.key});

  @override
  State<WebRegisterScreen> createState() => _WebRegisterScreenState();
}

class _WebRegisterScreenState extends State<WebRegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _role = 'Familiar/Cuidador';
  bool _loading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;
  
  // Usar XFile que funciona en todas las plataformas
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 500,
      );
      if (image != null) {
        setState(() {
          _profileImage = image;
        });
      }
    } catch (e) {
      _showErrorDialog('Error al seleccionar imagen', 'No se pudo cargar la imagen seleccionada: ${e.toString()}');
    }
  }

  Future<void> _showErrorDialog(String message, String? specificError) async {
    _animationController.forward(from: 0.0);
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.error_outline, color: Colors.white, size: 48),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error de Registro',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                      height: 1.4,
                                    ),
                                  ),
                                  if (specificError != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline, color: Colors.red[400], size: 18),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              specificError,
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Entendido', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
      },
    );
  }

  Future<void> _showSuccessDialog(String message) async {
    _animationController.forward(from: 0.0);
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.successColor, AppTheme.successColor.withValues(alpha: 0.8)],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 52),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '¡Registro Exitoso!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.successColor),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Redirigiendo al login...',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.successColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Esto se cerrará automáticamente',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Colors.grey[500],
                                      ),
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
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        role: _role,
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      
      if (!mounted) return;
      
      await _showSuccessDialog('Tu cuenta web fue creada correctamente. Serás redirigido al login.');
      
      if (mounted) {
        // Redirigir al login después de 1 segundo
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/web/login');
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = '';
      String specificError = '';
      
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'El correo electrónico ya está registrado.';
        specificError = 'Por favor utiliza otro correo o inicia sesión.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'El formato del correo electrónico no es válido.';
        specificError = 'El correo debe tener un formato como: usuario@dominio.com';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'La contraseña es muy débil.';
        specificError = 'La contraseña debe tener al menos 6 caracteres.';
      } else {
        errorMessage = 'Error al registrar usuario.';
        specificError = e.toString();
      }
      
      await _showErrorDialog(errorMessage, specificError);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildProfileImage() {
    if (_profileImage != null) {
      // XFile funciona en web y móvil
      return ClipOval(
        child: Image.network(
          _profileImage!.path,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppTheme.primaryColor,
              ),
            );
          },
        ),
      );
    }
    
    // Placeholder cuando no hay imagen
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.add_a_photo,
        size: 32,
        color: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            // Columna izquierda - Información
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(-50 * (1 - value), 0),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.health_and_safety, color: Colors.white, size: 48),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(-50 * (1 - value), 0),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Text(
                        'Crear una cuenta',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(-50 * (1 - value), 0),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Text(
                        'Regístrate para comenzar a monitorear el bienestar de tus pacientes y generar reportes profesionales.',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInfoCard(
                      'Monitoreo en Tiempo Real',
                      'Visualiza el estado de salud de tus pacientes al instante',
                      Icons.monitor_heart,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Reportes Automáticos',
                      'Genera y comparte reportes PDF detallados',
                      Icons.picture_as_pdf,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Alertas Inteligentes',
                      'Recibe notificaciones ante cualquier anomalía',
                      Icons.notifications_active,
                    ),
                  ],
                ),
              ),
            ),
            // Columna derecha - Formulario de registro
            Expanded(
              flex: 1,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(50 * (1 - value), 0),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Crear Cuenta',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Completa tus datos para comenzar',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Foto de perfil
                              GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildProfileImage(),
                                      const SizedBox(height: 8),
                                      Text(
                                        _profileImage != null 
                                            ? 'Cambiar foto de perfil' 
                                            : 'Agregar foto de perfil',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      if (kIsWeb)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'PNG, JPG hasta 5MB',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Nombre y apellido en fila
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final compact = constraints.maxWidth < 640;
                                  return compact
                                      ? Column(
                                          children: [
                                            _buildTextField(_nameController, 'Nombre', Icons.person_outline),
                                            const SizedBox(height: 12),
                                            _buildTextField(_lastNameController, 'Apellido', Icons.person_outline),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(child: _buildTextField(_nameController, 'Nombre', Icons.person_outline)),
                                            const SizedBox(width: 12),
                                            Expanded(child: _buildTextField(_lastNameController, 'Apellido', Icons.person_outline)),
                                          ],
                                        );
                                },
                              ),
                              const SizedBox(height: 12),
                              
                              _buildTextField(_emailController, 'Correo Electrónico', Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Ingrese su correo';
                                  if (!v.contains('@') || !v.contains('.')) return 'Correo inválido';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              
                              _buildTextField(_phoneController, 'Teléfono (opcional)', Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 12),
                              
                              // Selector de rol
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _role,
                                  decoration: InputDecoration(
                                    labelText: 'Rol',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    prefixIcon: Icon(Icons.assignment_ind, color: AppTheme.primaryColor),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Familiar/Cuidador', child: Text('Familiar/Cuidador')),
                                    DropdownMenuItem(value: 'Médico', child: Text('Médico')),
                                    DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
                                  ],
                                  onChanged: (value) => setState(() => _role = value ?? 'Familiar/Cuidador'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              _buildTextField(_passwordController, 'Contraseña', Icons.lock_outline,
                                obscureText: _obscure,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Ingrese contraseña';
                                  if (v.length < 6) return 'Mínimo 6 caracteres';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              
                              _buildTextField(_confirmController, 'Confirmar Contraseña', Icons.lock_outline,
                                obscureText: _obscureConfirm,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                                ),
                                validator: (v) => v != _passwordController.text ? 'Las contraseñas no coinciden' : null,
                              ),
                              const SizedBox(height: 24),
                              
                              // Botón de registro
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _loading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Crear Cuenta',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      '¿Ya tienes cuenta?',
                                      style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Botón de login
                              SizedBox(
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context, '/web/login');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppTheme.primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Iniciar Sesión',
                                    style: GoogleFonts.inter(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator ?? (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(-20 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}