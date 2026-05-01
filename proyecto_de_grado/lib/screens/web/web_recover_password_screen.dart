import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../auth/services/auth_service.dart';

class WebRecoverPasswordScreen extends StatefulWidget {
  const WebRecoverPasswordScreen({super.key});

  @override
  State<WebRecoverPasswordScreen> createState() => _WebRecoverPasswordScreenState();
}

class _WebRecoverPasswordScreenState extends State<WebRecoverPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
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
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _showSuccessDialog(String message) async {
    _animationController.forward(from: 0.0);
    
    // Cerrar automáticamente después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/web/login');
      }
    });
    
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
                        // Cabecera con gradiente
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
                                  child: const Icon(Icons.email_outlined, color: Colors.white, size: 52),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '¡Correo Enviado!',
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
                        // Contenido
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
                              // Indicador de carga
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
                      // Cabecera con gradiente
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
                                'Error al recuperar',
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
                      // Contenido
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

  Future<void> _recover() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _loading = true);
    try {
      await AuthService.recoverPassword(_emailController.text.trim());
      if (!mounted) return;
      await _showSuccessDialog('Hemos enviado un enlace de recuperación a ${_emailController.text.trim()}. Revisa tu bandeja de entrada.');
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = '';
      String specificError = '';
      
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No encontramos una cuenta con este correo electrónico.';
        specificError = 'Verifica que el correo esté escrito correctamente.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'El formato del correo electrónico no es válido.';
        specificError = 'El correo debe tener un formato como: usuario@dominio.com';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Demasiados intentos.';
        specificError = 'Por favor espera unos minutos antes de intentar nuevamente.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Error de conexión.';
        specificError = 'Verifica tu conexión a internet e intenta nuevamente.';
      } else {
        errorMessage = 'Error al enviar el correo de recuperación.';
        specificError = e.toString();
      }
      
      await _showErrorDialog(errorMessage, specificError);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
            // Columna izquierda - Información (igual que el login)
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
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.poppins(
                          fontSize: 42,
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
                        'No te preocupes, te ayudaremos a recuperar el acceso a tu cuenta en unos simples pasos.',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInfoCard(
                      'Instrucciones al correo',
                      'Te enviaremos un enlace seguro para restablecer tu contraseña',
                      Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Enlace temporal',
                      'El enlace será válido por 24 horas por seguridad',
                      Icons.timer_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Soporte disponible',
                      '¿Problemas? Contacta con nuestro equipo de soporte',
                      Icons.support_agent,
                    ),
                  ],
                ),
              ),
            ),
            // Columna derecha - Formulario de recuperación
            Expanded(
              flex: 1,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
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
                        padding: const EdgeInsets.all(40),
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
                              // Icono de recuperación
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.lock_reset, color: Colors.white, size: 40),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Recuperar Contraseña',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              // Email field
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.inter(fontSize: 16),
                                decoration: InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  hintText: 'usuario@ejemplo.com',
                                  hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                                  prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor),
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor ingrese su correo electrónico';
                                  }
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Ingrese un correo electrónico válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              // Send button
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _recover,
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
                                          'Enviar Enlace de Recuperación',
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
                                      '¿Recordaste tu contraseña?',
                                      style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Back to login button
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_back, color: AppTheme.primaryColor, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Volver al Inicio de Sesión',
                                        style: GoogleFonts.inter(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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