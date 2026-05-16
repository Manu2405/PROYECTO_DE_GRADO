import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '/../../../core/theme/app_theme.dart';

// ==================== AdminWebUsersSection ====================

class AdminWebUsersSection extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final VoidCallback onCreateUser;
  final Function(Map<String, dynamic>) onEditUser;
  final Function(Map<String, dynamic>) onDeleteUser;

  const AdminWebUsersSection({
    super.key,
    required this.users,
    required this.onCreateUser,
    required this.onEditUser,
    required this.onDeleteUser,
  });

  @override
  State<AdminWebUsersSection> createState() => _AdminWebUsersSectionState();
}

class _AdminWebUsersSectionState extends State<AdminWebUsersSection> {
  Map<String, dynamic>? _selectedUser;
  bool _showDetails = false;
  bool _showDeleteConfirm = false;
  Map<String, dynamic>? _userToDelete;

  void _viewUserDetails(Map<String, dynamic> user) {
    setState(() {
      _selectedUser = user;
      _showDetails = true;
    });
  }

  void _closeDetails() {
    setState(() {
      _showDetails = false;
      _selectedUser = null;
    });
  }

  void _openEditFromDetails() {
    final user = _selectedUser;
    _closeDetails();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (user != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => UserFormModal(
            user: user,
            onSave: (updatedUser) {
              widget.onEditUser(updatedUser);
            },
          ),
        );
      }
    });
  }

  void _confirmDelete(Map<String, dynamic> user) {
    setState(() {
      _userToDelete = user;
      _showDeleteConfirm = true;
    });
  }

  void _closeDeleteConfirm() {
    setState(() {
      _showDeleteConfirm = false;
      _userToDelete = null;
    });
  }

  void _executeDelete() {
    if (_userToDelete != null) {
      widget.onDeleteUser(_userToDelete!);
      _closeDeleteConfirm();
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'No especificado';
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }
    if (date is String) {
      return date;
    }
    return 'No especificado';
  }

  String _getInitials(String nombre) {
    if (nombre.isEmpty) return '?';
    final parts = nombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bgGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0A1929),
        Color(0xFF0F2B3D),
        Color(0xFF1A3A4F),
        Color(0xFF1A1A2E),
      ],
    );
    
    final textColor = Colors.white;
    final secondaryTextColor = Colors.white.withOpacity(0.7);
    final tableBgColor = const Color(0xFF0F2B3D).withOpacity(0.6);
    final tableHeaderColor = AppTheme.primaryColor.withOpacity(0.2);
    final footerBgColor = const Color(0xFF0A1929).withOpacity(0.5);
    final borderColor = Colors.white.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(gradient: bgGradient),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con gradiente
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.people_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestión de Usuarios',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Administra todos los usuarios de la plataforma',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => UserFormModal(
                            onSave: (userData) {
                              widget.onCreateUser();
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Nuevo Usuario'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tabla de usuarios
              Container(
                decoration: BoxDecoration(
                  color: tableBgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) => tableHeaderColor,
                      ),
                      dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) => Colors.transparent,
                      ),
                      dividerThickness: 0,
                      dataRowMaxHeight: 70,
                      headingTextStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      dataTextStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      columns: const [
                        DataColumn(label: Text('Usuario')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Rol')),
                        DataColumn(label: Text('Teléfono')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: widget.users.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: _getRoleColor(user['rol'])
                                        .withOpacity(0.2),
                                    backgroundImage: user['photoBytes'] != null
                                        ? MemoryImage(user['photoBytes'])
                                        : null,
                                    child: user['photoBytes'] == null
                                        ? Text(
                                            _getInitials(user['nombre']),
                                            style: TextStyle(
                                              color: _getRoleColor(user['rol']),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    user['nombre'],
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(user['email'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(user['rol'])
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  user['rol'],
                                  style: TextStyle(
                                    color: _getRoleColor(user['rol']),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(user['telefono'] ?? 'No especificado')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(user['estado'])
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  user['estado'],
                                  style: TextStyle(
                                    color: _getStatusColor(user['estado']),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _viewUserDetails(user),
                                    icon: const Icon(Icons.visibility_rounded),
                                    color: const Color(0xFF14B8A6),
                                    tooltip: 'Ver detalles',
                                    iconSize: 20,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => UserFormModal(
                                          user: user,
                                          onSave: (updatedUser) {
                                            widget.onEditUser(updatedUser);
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit_rounded),
                                    color: const Color(0xFF0EA5E9),
                                    tooltip: 'Editar',
                                    iconSize: 20,
                                  ),
                                  IconButton(
                                    onPressed: () => _confirmDelete(user),
                                    icon: const Icon(Icons.delete_rounded),
                                    color: const Color(0xFFEF4444),
                                    tooltip: 'Eliminar',
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Footer con totales
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: footerBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total de usuarios: ${widget.users.length}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Mostrando ${widget.users.length} registros',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Panel de detalles del usuario (modal lateral con foto)
          if (_showDetails && _selectedUser != null)
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _closeDetails,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.7),
                  child: GestureDetector(
                    onTap: () {},
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(MediaQuery.of(context).size.width * 0.4 * (1 - value), 0),
                            child: child,
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0F2B3D),
                                Color(0xFF1A3A4F),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(-5, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header del modal con foto
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      backgroundImage: _selectedUser!['photoBytes'] != null
                                          ? MemoryImage(_selectedUser!['photoBytes'])
                                          : null,
                                      child: _selectedUser!['photoBytes'] == null
                                          ? Text(
                                              _getInitials(_selectedUser!['nombre']),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _selectedUser!['nombre'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              _selectedUser!['rol'],
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _closeDetails,
                                      icon: const Icon(Icons.close_rounded),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),

                              // Contenido del modal (scrollable)
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailSection(
                                        'Foto de Perfil',
                                        Icons.photo_camera_rounded,
                                        [
                                          Container(
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundColor: Colors.white.withOpacity(0.1),
                                                  backgroundImage: _selectedUser!['photoBytes'] != null
                                                      ? MemoryImage(_selectedUser!['photoBytes'])
                                                      : null,
                                                  child: _selectedUser!['photoBytes'] == null
                                                      ? Text(
                                                          _getInitials(_selectedUser!['nombre']),
                                                          style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppTheme.primaryColor,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.camera_alt, size: 14, color: Colors.white.withOpacity(0.5)),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Foto de perfil',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: Colors.white.withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      _buildDetailSection(
                                        'Información Personal',
                                        Icons.person_outline_rounded,
                                        [
                                          _buildDetailItem(
                                            'Nombre completo',
                                            _selectedUser!['nombre'],
                                            Icons.badge_rounded,
                                          ),
                                          _buildDetailItem(
                                            'Email',
                                            _selectedUser!['email'],
                                            Icons.email_outlined,
                                          ),
                                          _buildDetailItem(
                                            'Teléfono',
                                            _selectedUser!['telefono'] ?? 'No especificado',
                                            Icons.phone_outlined,
                                          ),
                                          _buildDetailItem(
                                            'Estado',
                                            _selectedUser!['estado'],
                                            Icons.circle_rounded,
                                            color: _getStatusColor(_selectedUser!['estado']),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      _buildDetailSection(
                                        'Información de la Cuenta',
                                        Icons.account_circle_rounded,
                                        [
                                          _buildDetailItem(
                                            'Rol',
                                            _selectedUser!['rol'],
                                            Icons.assignment_ind_rounded,
                                          ),
                                          _buildDetailItem(
                                            'Fecha de registro',
                                            _formatDate(_selectedUser!['fechaRegistro']),
                                            Icons.calendar_today_rounded,
                                          ),
                                          _buildDetailItem(
                                            'Último acceso',
                                            _selectedUser!['ultimoAcceso'] ?? 'Nunca',
                                            Icons.history_rounded,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      _buildDetailSection(
                                        'Métricas',
                                        Icons.analytics_rounded,
                                        [
                                          _buildDetailItem(
                                            'Total de consultas',
                                            _selectedUser!['totalConsultas']?.toString() ?? '0',
                                            Icons.medical_information_rounded,
                                          ),
                                          _buildDetailItem(
                                            'Recetas generadas',
                                            _selectedUser!['recetasGeneradas']?.toString() ?? '0',
                                            Icons.description_rounded,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Botones de acción
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _openEditFromDetails,
                                        icon: const Icon(Icons.edit_rounded, size: 18),
                                        label: const Text('Editar Usuario'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF0EA5E9),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          side: const BorderSide(color: Color(0xFF0EA5E9)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _closeDetails,
                                        icon: const Icon(Icons.close_rounded, size: 18),
                                        label: const Text('Cerrar'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0A1929),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 0,
                                        ),
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
              ),
            ),

          // Modal de confirmación de eliminación con foto
          if (_showDeleteConfirm && _userToDelete != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _closeDeleteConfirm,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0F2B3D),
                                Color(0xFF1A3A4F),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Foto del usuario a eliminar
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                backgroundImage: _userToDelete!['photoBytes'] != null
                                    ? MemoryImage(_userToDelete!['photoBytes'])
                                    : null,
                                child: _userToDelete!['photoBytes'] == null
                                    ? Text(
                                        _getInitials(_userToDelete!['nombre']),
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Eliminar Usuario',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '¿Estás seguro de que deseas eliminar a',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"${_userToDelete!['nombre']}"?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Esta acción no se puede deshacer.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _closeDeleteConfirm,
                                      icon: const Icon(Icons.close_rounded, size: 18),
                                      label: const Text('Cancelar'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _executeDelete,
                                      icon: const Icon(Icons.delete_rounded, size: 18),
                                      label: const Text('Eliminar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
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
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1929).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: color ?? Colors.white,
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Médico':
        return const Color(0xFF0EA5E9);
      case 'Familiar/Cuidador':
        return const Color(0xFF10B981);
      case 'Adulto Mayor':
        return const Color(0xFFF59E0B);
      case 'Administrador':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Activo':
        return const Color(0xFF10B981);
      case 'Inactivo':
        return const Color(0xFFF59E0B);
      case 'Suspendido':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }
}

// ==================== UserFormModal CON CÁMARA FUNCIONAL ====================

class UserFormModal extends StatefulWidget {
  final Map<String, dynamic>? user;
  final Function(Map<String, dynamic>) onSave;

  const UserFormModal({super.key, this.user, required this.onSave});

  @override
  State<UserFormModal> createState() => _UserFormModalState();
}

class _UserFormModalState extends State<UserFormModal> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late String _selectedRole;
  late String _selectedStatus;
  Uint8List? _photoBytes;
  bool _isUploadingPhoto = false;
  bool _isDeletingPhoto = false;

  final List<String> _roles = ['Médico', 'Familiar/Cuidador', 'Adulto Mayor', 'Administrador'];
  final List<String> _statuses = ['Activo', 'Inactivo', 'Suspendido'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?['nombre'] ?? '');
    _emailController = TextEditingController(text: widget.user?['email'] ?? '');
    _phoneController = TextEditingController(text: widget.user?['telefono'] ?? '');
    _selectedRole = widget.user?['rol'] ?? _roles[0];
    _selectedStatus = widget.user?['estado'] ?? _statuses[0];
    _photoBytes = widget.user?['photoBytes'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _getInitials(String nombre) {
    if (nombre.isEmpty) return 'U';
    final parts = nombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre[0].toUpperCase();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Activo':
        return const Color(0xFF10B981);
      case 'Inactivo':
        return const Color(0xFFF59E0B);
      case 'Suspendido':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  // Tomar foto usando la cámara
  Future<void> _takePhoto() async {
    setState(() => _isUploadingPhoto = true);
    
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _photoBytes = bytes;
          _isUploadingPhoto = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto capturada correctamente'),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() => _isUploadingPhoto = false);
      }
    } catch (e) {
      setState(() => _isUploadingPhoto = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al tomar la foto: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Seleccionar de galería
  Future<void> _selectFromGallery() async {
    setState(() => _isUploadingPhoto = true);
    
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _photoBytes = bytes;
          _isUploadingPhoto = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto seleccionada correctamente'),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() => _isUploadingPhoto = false);
      }
    } catch (e) {
      setState(() => _isUploadingPhoto = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar la imagen: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deletePhoto() async {
    setState(() => _isDeletingPhoto = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _photoBytes = null;
      _isDeletingPhoto = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto eliminada correctamente'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F2B3D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Foto de perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF0EA5E9)),
                title: const Text('Tomar foto', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Usar la cámara del dispositivo', style: TextStyle(color: Colors.white54)),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF0EA5E9)),
                title: const Text('Seleccionar de galería', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Elegir una imagen existente', style: TextStyle(color: Colors.white54)),
                onTap: () {
                  Navigator.pop(context);
                  _selectFromGallery();
                },
              ),
              if (_photoBytes != null || widget.user?['photoBytes'] != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Eliminar foto', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Volver a la imagen por defecto', style: TextStyle(color: Colors.white54)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2B3D), Color(0xFF1A3A4F)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.user == null ? Icons.person_add_rounded : Icons.edit_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.user == null ? 'Crear Usuario' : 'Editar Usuario',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Campo de foto - Avatar con cámara
              Center(
                child: GestureDetector(
                  onTap: _showPhotoOptions,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Avatar circular
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0A1929),
                              border: Border.all(color: AppTheme.primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _isUploadingPhoto || _isDeletingPhoto
                                  ? Container(
                                      color: const Color(0xFF0A1929),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                        ),
                                      ),
                                    )
                                  : _photoBytes != null
                                      ? Image.memory(
                                          _photoBytes!,
                                          fit: BoxFit.cover,
                                          width: 120,
                                          height: 120,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.error,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : widget.user?['photoBytes'] != null
                                          ? Image.memory(
                                              widget.user!['photoBytes'],
                                              fit: BoxFit.cover,
                                              width: 120,
                                              height: 120,
                                              errorBuilder: (_, __, ___) => const Icon(
                                                Icons.error,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [AppTheme.primaryColor.withOpacity(0.3), Colors.blue.withOpacity(0.1)],
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _getInitials(_nameController.text.isEmpty ? 'U' : _nameController.text),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                            ),
                          ),
                          // Botón de cámara para editar foto
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Toca la foto para cambiarla',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Línea divisoria
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 24),
              
              // Campos del formulario
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.phone_outlined, color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                dropdownColor: const Color(0xFF0F2B3D),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Rol',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.assignment_ind_outlined, color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                dropdownColor: const Color(0xFF0F2B3D),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Estado',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.circle_outlined, color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStatusColor(status),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(status),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Línea divisoria
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 24),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor ingresa el nombre')),
                          );
                          return;
                        }
                        if (_emailController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor ingresa el email')),
                          );
                          return;
                        }
                        final userData = {
                          'nombre': _nameController.text.trim(),
                          'email': _emailController.text.trim(),
                          'telefono': _phoneController.text.trim(),
                          'rol': _selectedRole,
                          'estado': _selectedStatus,
                          'photoBytes': _photoBytes,
                        };
                        widget.onSave(userData);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Guardar'),
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
}