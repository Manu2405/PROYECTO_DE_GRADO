import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../../../core/theme/app_theme.dart';

class AdminWebManagementSection extends StatelessWidget {
  const AdminWebManagementSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    final isLargeScreen = screenWidth >= 900 && screenWidth < 1200;
    final isExtraLarge = screenWidth >= 1200;
    
    // Colores del login (fondo oscuro)
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
    
    final cardColor = const Color(0xFF0F2B3D).withValues(alpha: 0.6);
    final borderColor = Colors.white.withValues(alpha: 0.1);
    final textColor = Colors.white;
    final secondaryTextColor = Colors.white.withValues(alpha: 0.7);
    
    // Ajustar número de columnas según el tamaño
    int crossAxisCount = 1;
    double childAspectRatio = 1.2;
    
    if (isSmallScreen) {
      crossAxisCount = 1;
      childAspectRatio = 1.1;
    } else if (isMediumScreen) {
      crossAxisCount = 2;
      childAspectRatio = 1.2;
    } else if (isLargeScreen) {
      crossAxisCount = 3;
      childAspectRatio = 1.3;
    } else if (isExtraLarge) {
      crossAxisCount = 3;
      childAspectRatio = 1.4;
    }
    
    // Ajustar padding según tamaño
    final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
    final fontSizeTitle = isSmallScreen ? 20.0 : 28.0;
    final fontSizeSubtitle = isSmallScreen ? 12.0 : 14.0;

    return Container(
      decoration: BoxDecoration(gradient: bgGradient),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado responsivo
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Container(
                padding: EdgeInsets.all(horizontalPadding),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Icon(Icons.settings_rounded, color: Colors.white, size: isSmallScreen ? 24 : 28),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Configuración y Gestión',
                            style: GoogleFonts.poppins(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            'Administra la configuración global de la plataforma',
                            style: GoogleFonts.inter(
                              fontSize: fontSizeSubtitle,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: isSmallScreen ? 24 : 32),
            
            // Grid de tarjetas responsivo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isSmallScreen ? 12 : 20,
                  mainAxisSpacing: isSmallScreen ? 12 : 20,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final cards = [
                    {'title': 'Configuración General', 'description': 'Ajustes globales de la plataforma', 'icon': Icons.settings_rounded, 'color': const Color(0xFF0EA5E9)},
                    {'title': 'Roles y Permisos', 'description': 'Gestiona los roles y permisos de usuarios', 'icon': Icons.security_rounded, 'color': const Color(0xFF10B981)},
                    {'title': 'Notificaciones', 'description': 'Configura las notificaciones del sistema', 'icon': Icons.notifications_rounded, 'color': const Color(0xFFF59E0B)},
                    {'title': 'Respaldos', 'description': 'Gestiona los respaldos de datos', 'icon': Icons.backup_rounded, 'color': const Color(0xFF8B5CF6)},
                    {'title': 'Auditoría', 'description': 'Registro de actividades del sistema', 'icon': Icons.history_rounded, 'color': const Color(0xFFEF4444)},
                    {'title': 'Mantenimiento', 'description': 'Herramientas de mantenimiento', 'icon': Icons.build_rounded, 'color': const Color(0xFF14B8A6)},
                  ];
                  return _buildManagementCard(
                    cards[index]['title'] as String,
                    cards[index]['description'] as String,
                    cards[index]['icon'] as IconData,
                    cards[index]['color'] as Color,
                    () => _showComingSoonDialog(context, cards[index]['title'] as String),
                    isSmallScreen,
                  );
                },
              ),
            ),
            
            SizedBox(height: isSmallScreen ? 24 : 32),
            
            // Sección de estado del sistema responsiva
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                padding: EdgeInsets.all(horizontalPadding),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado del Sistema',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Wrap(
                      spacing: isSmallScreen ? 12 : 20,
                      runSpacing: isSmallScreen ? 12 : 20,
                      alignment: WrapAlignment.start,
                      children: [
                        _buildSystemStatus('Versión', '3.0.0', Icons.info_outline_rounded, null, isSmallScreen),
                        _buildSystemStatus('Última Actualización', '15/01/2024', Icons.update_rounded, null, isSmallScreen),
                        _buildSystemStatus('Estado', 'Operativo', Icons.check_circle_rounded, const Color(0xFF10B981), isSmallScreen),
                        _buildSystemStatus('Espacio Usado', '45%', Icons.storage_rounded, null, isSmallScreen),
                        _buildSystemStatus('Base de Datos', 'Conectada', Icons.cloud_queue_rounded, const Color(0xFF10B981), isSmallScreen),
                        _buildSystemStatus('API', 'Online', Icons.api_rounded, const Color(0xFF10B981), isSmallScreen),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: isSmallScreen ? 16 : 24),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(String title, String description, IconData icon, Color color, VoidCallback onTap, bool isSmallScreen) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2B3D).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono con gradiente
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: isSmallScreen ? 24 : 28),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: isSmallScreen ? 11 : 12,
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Row(
              children: [
                Text(
                  'Configurar',
                  style: GoogleFonts.inter(
                    fontSize: isSmallScreen ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 2 : 4),
                Icon(Icons.arrow_forward_rounded, size: isSmallScreen ? 12 : 14, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatus(String label, String value, IconData icon, Color? color, bool isSmallScreen) {
    final iconColor = color ?? Colors.white.withValues(alpha: 0.5);
    final valueColor = color ?? Colors.white;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1929).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 16 : 20, color: iconColor),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 10 : 11,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20)),
        backgroundColor: const Color(0xFF0F2B3D),
        child: Container(
          width: isSmallScreen ? double.infinity : 400,
          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0EA5E9), AppTheme.primaryColor],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.construction_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Próximamente',
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'La función "$feature" estará disponible pronto',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.white.withValues(alpha: 0.7),
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
                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Entendido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}