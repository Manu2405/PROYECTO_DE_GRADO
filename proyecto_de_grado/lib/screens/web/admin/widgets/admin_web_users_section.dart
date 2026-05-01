import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../../../core/theme/app_theme.dart';

class AdminWebUsersSection extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final VoidCallback onCreateUser;
  final Function(Map<String, dynamic>) onEditUser;
  final Function(Map<String, dynamic>) onDeleteUser;
  final bool isDarkMode;

  const AdminWebUsersSection({
    super.key,
    required this.users,
    required this.onCreateUser,
    required this.onEditUser,
    required this.onDeleteUser,
    this.isDarkMode = false,
  });

  @override
  State<AdminWebUsersSection> createState() => _AdminWebUsersSectionState();
}

class _AdminWebUsersSectionState extends State<AdminWebUsersSection> {
  Map<String, dynamic>? _selectedUser;
  bool _showDetails = false;

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

  @override
  Widget build(BuildContext context) {
    // Colores según modo oscuro/claro
    final bgColor = widget.isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final tableBgColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final tableHeaderColor = widget.isDarkMode 
        ? AppTheme.primaryColor.withValues(alpha: 0.2) 
        : AppTheme.primaryColor.withValues(alpha: 0.05);
    final footerBgColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50];
    final borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    final modalBgColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final modalTextColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    final modalSecondaryTextColor = widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final detailItemBgColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : AppTheme.primaryColor.withValues(alpha: 0.1);
    final buttonBgColor = widget.isDarkMode ? const Color(0xFF3D3D3D) : Colors.grey[300];
    final buttonTextColor = widget.isDarkMode ? Colors.white : Colors.grey[800];

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gestión de Usuarios',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Administra todos los usuarios de la plataforma',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: widget.onCreateUser,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Nuevo Usuario'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tabla de usuarios
            Container(
              decoration: BoxDecoration(
                color: tableBgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) => tableHeaderColor,
                    ),
                    dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (states) => widget.isDarkMode ? const Color(0xFF252525) : Colors.white,
                    ),
                    dataRowMaxHeight: 70,
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
                                  backgroundColor:
                                      AppTheme.primaryColor.withValues(alpha: 0.1),
                                  child: Text(
                                    user['nombre'][0],
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  user['nombre'],
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(user['email'], style: TextStyle(color: textColor))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getRoleColor(user['rol'])
                                    .withValues(alpha: 0.1),
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
                          DataCell(Text(user['telefono'] ?? 'No especificado', style: TextStyle(color: textColor))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(user['estado'])
                                    .withValues(alpha: 0.1),
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
                                  icon: const Icon(Icons.visibility_outlined),
                                  color: Colors.teal,
                                  tooltip: 'Ver detalles',
                                ),
                                IconButton(
                                  onPressed: () => widget.onEditUser(user),
                                  icon: const Icon(Icons.edit_outlined),
                                  color: Colors.blue,
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  onPressed: () => widget.onDeleteUser(user),
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red,
                                  tooltip: 'Eliminar',
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
                borderRadius: BorderRadius.circular(12),
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

        // Panel de detalles del usuario (modal lateral) - CON MODO OSCURO
        if (_showDetails && _selectedUser != null)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _closeDetails,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withValues(alpha: 0.5),
                child: GestureDetector(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: modalBgColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header del modal
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    _selectedUser!['nombre'][0],
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedUser!['nombre'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _selectedUser!['rol'],
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: _closeDetails,
                                  icon: const Icon(Icons.close),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          // Contenido del modal
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailSection(
                                    'Información Personal',
                                    Icons.person_outline,
                                    [
                                      _buildDetailItem(
                                        'Nombre completo',
                                        _selectedUser!['nombre'],
                                        Icons.badge,
                                      ),
                                      _buildDetailItem(
                                        'Email',
                                        _selectedUser!['email'],
                                        Icons.email_outlined,
                                      ),
                                      _buildDetailItem(
                                        'Teléfono',
                                        _selectedUser!['telefono'] ??
                                            'No especificado',
                                        Icons.phone_outlined,
                                      ),
                                      _buildDetailItem(
                                        'Estado',
                                        _selectedUser!['estado'],
                                        Icons.circle,
                                        color: _getStatusColor(
                                            _selectedUser!['estado']),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildDetailSection(
                                    'Información de la Cuenta',
                                    Icons.account_circle_outlined,
                                    [
                                      _buildDetailItem(
                                        'Rol',
                                        _selectedUser!['rol'],
                                        Icons.assignment_ind_outlined,
                                      ),
                                      _buildDetailItem(
                                        'Fecha de registro',
                                        _formatDate(_selectedUser!['fechaRegistro']),
                                        Icons.calendar_today,
                                      ),
                                      _buildDetailItem(
                                        'Último acceso',
                                        _selectedUser!['ultimoAcceso'] ??
                                            'Nunca',
                                        Icons.history,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildDetailSection(
                                    'Métricas',
                                    Icons.analytics_outlined,
                                    [
                                      _buildDetailItem(
                                        'Total de consultas',
                                        _selectedUser!['totalConsultas']?.toString() ?? '0',
                                        Icons.medical_information,
                                      ),
                                      _buildDetailItem(
                                        'Recetas generadas',
                                        _selectedUser!['recetasGeneradas']?.toString() ?? '0',
                                        Icons.description_outlined,
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
                                  color: borderColor,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      _closeDetails();
                                      widget.onEditUser(_selectedUser!);
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Editar Usuario'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      side: const BorderSide(color: Colors.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _closeDetails,
                                    icon: const Icon(Icons.close),
                                    label: const Text('Cerrar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonBgColor,
                                      foregroundColor: buttonTextColor,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
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
      ],
    );
  }

  Widget _buildDetailSection(String title, IconData icon, List<Widget> children) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
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
    final labelColor = widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final valueColor = widget.isDarkMode ? Colors.white : (color ?? Colors.grey[900]);
    final iconBgColor = widget.isDarkMode 
        ? AppTheme.primaryColor.withValues(alpha: 0.2) 
        : AppTheme.primaryColor.withValues(alpha: 0.1);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
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
                    fontSize: 12,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Médico':
        return Colors.blue;
      case 'Familiar/Cuidador':
        return Colors.green;
      case 'Adulto Mayor':
        return Colors.orange;
      case 'Administrador':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Activo':
        return Colors.green;
      case 'Inactivo':
        return Colors.orange;
      case 'Suspendido':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}