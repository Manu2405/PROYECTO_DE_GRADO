import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../core/theme/app_theme.dart';
import '../auth/services/auth_service.dart';
import '../auth/models/user_auth_model.dart';

class WebProfileScreen extends StatefulWidget {
  const WebProfileScreen({super.key});

  @override
  State<WebProfileScreen> createState() => _WebProfileScreenState();
}

class _WebProfileScreenState extends State<WebProfileScreen> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  late NotificationPreferences _notificationsPrefs;
  
  bool _editing = false;
  bool _saving = false;
  bool _isHoveringEdit = false;
  Uint8List? _selectedImageBytes;
  String? _photoUrl;
  bool _isUploadingPhoto = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone ?? '';
      _notificationsPrefs = user.notificationPreferences;
      _photoUrl = user.photoUrl;
    }
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Mostrar modal para editar foto
  Future<void> _showEditPhotoModal() async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicador de arrastre
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Editar foto de perfil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Divider(height: 1),
                
                // Vista previa de la foto actual
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primaryColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _getAvatarPreview(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Foto actual',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Opciones
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt, color: AppTheme.primaryColor, size: 22),
                  ),
                  title: const Text('Tomar foto'),
                  subtitle: const Text('Usar la cámara del dispositivo'),
                  onTap: () {
                    Navigator.pop(context);
                    _updatePhoto(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library, color: AppTheme.primaryColor, size: 22),
                  ),
                  title: const Text('Seleccionar de galería'),
                  subtitle: const Text('Elegir una imagen existente'),
                  onTap: () {
                    Navigator.pop(context);
                    _updatePhoto(ImageSource.gallery);
                  },
                ),
                if (_selectedImageBytes != null || (_photoUrl != null && _photoUrl!.isNotEmpty))
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                    ),
                    title: const Text('Eliminar foto'),
                    subtitle: const Text('Volver a la imagen por defecto'),
                    onTap: () {
                      Navigator.pop(context);
                      _deletePhoto();
                    },
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAvatarPreview() {
    if (_isUploadingPhoto) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }
    
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 40),
      );
    }
    
    if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      return Image.network(
        _photoUrl!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 40),
      );
    }
    
    final user = AuthService.currentUser;
    return Container(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          user?.initials ?? 'U',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Future<void> _updatePhoto(ImageSource source) async {
    setState(() => _isUploadingPhoto = true);
    
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        setState(() {
          _selectedImageBytes = bytes;
          _photoUrl = null;
        });
        
        if (mounted) {
          await _showSuccessDialog('Foto de perfil actualizada correctamente');
        }
      }
    } catch (e) {
      if (mounted) {
        await _showErrorDialog('Error al seleccionar la imagen: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  Future<void> _deletePhoto() async {
    setState(() => _isUploadingPhoto = true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      setState(() {
        _selectedImageBytes = null;
        _photoUrl = null;
      });
      
      if (mounted) {
        await _showSuccessDialog('Foto de perfil eliminada');
      }
    } catch (e) {
      if (mounted) {
        await _showErrorDialog('Error al eliminar la foto: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  Future<void> _save() async {
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
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      await AuthService.updateProfile(
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      
      if (!mounted) return;
      
      setState(() {
        _editing = false;
        _saving = false;
      });
      
      await _showSuccessDialog('Perfil actualizado correctamente');
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      await _showErrorDialog('Error al actualizar: ${e.toString()}');
    }
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_outline, color: Colors.red, size: 40),
                    ),
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
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_outline, color: AppTheme.successColor, size: 40),
                    ),
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
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
                    ),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A1929),
                const Color(0xFF0F2B3D),
              ],
            ),
          ),
        ),
      ),
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
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 600),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Container(
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
                                          // Avatar con opción de edición modal
                                          Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              _buildAvatar(user),
                                              // Botón de edición (si está en modo edición)
                                              if (_editing)
                                                MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: _showEditPhotoModal,
                                                    child: Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withValues(alpha: 0.2),
                                                            blurRadius: 8,
                                                          ),
                                                        ],
                                                      ),
                                                      child: _isUploadingPhoto
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: AppTheme.primaryColor,
                                                              ),
                                                            )
                                                          : const Icon(
                                                              Icons.edit,
                                                              color: AppTheme.primaryColor,
                                                              size: 20,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          AnimatedDefaultTextStyle(
                                            duration: const Duration(milliseconds: 300),
                                            style: GoogleFonts.poppins(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            child: Text(user.fullName),
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
                                          if (_editing)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 12),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.edit_note, color: Colors.white70, size: 14),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Haz clic en el icono ✎ para cambiar tu foto',
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Contenido del perfil
                                    Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            child: Text(
                                              'Información Personal',
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ..._buildAnimatedInfoRows(user),
                                          const SizedBox(height: 32),
                                          Divider(color: Colors.grey[200]),
                                          const SizedBox(height: 32),
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            child: Row(
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
                                          ),
                                          const SizedBox(height: 20),
                                          ..._buildAnimatedNotificationSwitches(),
                                          const SizedBox(height: 32),
                                          Divider(color: Colors.grey[200]),
                                          const SizedBox(height: 24),
                                          _buildAnimatedActionButtons(),
                                        ],
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
    );
  }

  List<Widget> _buildAnimatedInfoRows(UserAuthModel user) {
    final rows = [
      _buildAnimatedInfoRow('Correo Electrónico', user.email, Icons.email_outlined, enabled: false),
      _buildAnimatedInfoRow('Nombre', user.name, Icons.person_outline, controller: _nameController, enabled: _editing),
      _buildAnimatedInfoRow('Apellido', user.lastName, Icons.person_outline, controller: _lastNameController, enabled: _editing),
      _buildAnimatedInfoRow('Teléfono', user.phone ?? 'No especificado', Icons.phone_outlined, controller: _phoneController, enabled: _editing, isPhone: true),
      _buildAnimatedInfoRow('Miembro desde', _formatDate(user.createdAt), Icons.calendar_today_outlined, enabled: false),
    ];
    
    return List.generate(rows.length, (index) {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 300 + (index * 50)),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: rows[index],
        ),
      );
    });
  }

  Widget _buildAnimatedInfoRow(
    String label,
    String value,
    IconData icon, {
    TextEditingController? controller,
    bool enabled = false,
    bool isPhone = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.grey[200]!,
          width: enabled ? 1.5 : 1,
        ),
        boxShadow: enabled ? [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : [],
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
                      style: GoogleFonts.inter(fontSize: 14),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Ingrese $label',
                      ),
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

  List<Widget> _buildAnimatedNotificationSwitches() {
    final switches = [
      _buildNotificationSwitch(
        'Recordatorios de medicamentos',
        'Recibe alertas para la toma de medicamentos',
        Icons.medication,
        _notificationsPrefs.medicationReminders,
        (value) {
          setState(() {
            _notificationsPrefs = _notificationsPrefs.copyWith(medicationReminders: value);
          });
        },
        enabled: _editing,
      ),
      _buildNotificationSwitch(
        'Recordatorios de citas',
        'Notificaciones sobre citas médicas programadas',
        Icons.calendar_today,
        _notificationsPrefs.appointmentReminders,
        (value) {
          setState(() {
            _notificationsPrefs = _notificationsPrefs.copyWith(appointmentReminders: value);
          });
        },
        enabled: _editing,
      ),
      _buildNotificationSwitch(
        'Alertas de reportes',
        'Notificaciones cuando se generen nuevos reportes',
        Icons.picture_as_pdf,
        _notificationsPrefs.reportAlerts,
        (value) {
          setState(() {
            _notificationsPrefs = _notificationsPrefs.copyWith(reportAlerts: value);
          });
        },
        enabled: _editing,
      ),
      _buildNotificationSwitch(
        'Actualizaciones familiares',
        'Recibe información sobre el progreso',
        Icons.family_restroom,
        _notificationsPrefs.familyUpdates,
        (value) {
          setState(() {
            _notificationsPrefs = _notificationsPrefs.copyWith(familyUpdates: value);
          });
        },
        enabled: _editing,
      ),
    ];
    
    return List.generate(switches.length, (index) {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 300 + (index * 50)),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: switches[index],
        ),
      );
    });
  }

  Widget _buildNotificationSwitch(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged, {
    bool enabled = true,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.grey[200]!,
          width: enabled ? 1.5 : 1,
        ),
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

  Widget _buildAnimatedActionButtons() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          if (_editing) ...[
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHoveringEdit = true),
                onExit: (_) => setState(() => _isHoveringEdit = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(_isHoveringEdit ? 1.02 : 1.0),
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : () {
                      setState(() {
                        _editing = false;
                        final user = AuthService.currentUser;
                        if (user != null) {
                          _nameController.text = user.name;
                          _lastNameController.text = user.lastName;
                          _phoneController.text = user.phone ?? '';
                          _notificationsPrefs = user.notificationPreferences;
                          _selectedImageBytes = null;
                          _photoUrl = user.photoUrl;
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
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHoveringEdit = true),
                onExit: (_) => setState(() => _isHoveringEdit = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(_isHoveringEdit ? 1.02 : 1.0),
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
              ),
            ),
          ] else ...[
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHoveringEdit = true),
                onExit: (_) => setState(() => _isHoveringEdit = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(_isHoveringEdit ? 1.02 : 1.0),
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
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHoveringEdit = true),
                onExit: (_) => setState(() => _isHoveringEdit = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(_isHoveringEdit ? 1.02 : 1.0),
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
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(UserAuthModel user) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: _isUploadingPhoto
            ? Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
              )
            : _selectedImageBytes != null
                ? Image.memory(
                    _selectedImageBytes!,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                    errorBuilder: (_, __, ___) => _buildDefaultAvatar(user),
                  )
                : _photoUrl != null && _photoUrl!.isNotEmpty
                    ? Image.network(
                        _photoUrl!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                        errorBuilder: (_, __, ___) => _buildDefaultAvatar(user),
                      )
                    : _buildDefaultAvatar(user),
      ),
    );
  }

  Widget _buildDefaultAvatar(UserAuthModel user) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFE0E7FF)],
        ),
      ),
      child: CircleAvatar(
        radius: 60,
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

  String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}