import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../adulto_mayor/dashboard_adulto_screen.dart';
import '../familiar_cuidador/dashboard_familiar_screen.dart';
import '../medico/dashboard_medico_screen.dart';
import '../admin/dashboard_admin_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Decoración de fondo
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -80,
                        left: -80,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            FadeInDown(
                              child: Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.health_and_safety,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            FadeInDown(
                              delay: const Duration(milliseconds: 200),
                              child: Text(
                                'VitaSenior',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.12,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [AppTheme.primaryColor, Colors.teal],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FadeInDown(
                              delay: const Duration(milliseconds: 300),
                              child: Text(
                                'Cuidado y seguimiento inteligente',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                      letterSpacing: 1,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 40),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 400),
                              child: const Text(
                                '¿Quién eres?',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            FadeInLeft(
                              delay: const Duration(milliseconds: 500),
                              child: Text(
                                'Selecciona tu rol para continuar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            
                            // Grid responsivo que se adapta
                            _buildResponsiveGrid(context),
                            
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Determinar cuántas columnas mostrar según el ancho de pantalla
    int crossAxisCount;
    double childAspectRatio;
    
    if (screenWidth < 600) {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
      childAspectRatio = 1.0;
    } else {
      crossAxisCount = 4;
      childAspectRatio = 0.9;
    }
    
    final gridHeight = (screenHeight * 0.55).clamp(400.0, screenHeight - 300);
    
    final roles = [
      {
        'icon': Icons.elderly,
        'title': 'Adulto Mayor',
        'subtitle': 'Gestiona tus medicamentos',
        'color': AppTheme.primaryColor,
        'gradientColors': [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.8)],
        'onTap': () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdultoScreen()),
        ),
      },
      {
        'icon': Icons.family_restroom,
        'title': 'Familiar',
        'subtitle': 'Cuida a tus seres queridos',
        'color': Colors.teal,
        'gradientColors': [Colors.teal, Colors.teal.shade700],
        'onTap': () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardFamiliarScreen()),
        ),
      },
      {
        'icon': Icons.medical_services,
        'title': 'Médico',
        'subtitle': 'Supervisa tratamientos',
        'color': Colors.indigo,
        'gradientColors': [Colors.indigo, Colors.indigo.shade700],
        'onTap': () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardMedicoScreen()),
        ),
      },
      {
        'icon': Icons.admin_panel_settings,
        'title': 'Administrador',
        'subtitle': 'Gestiona el sistema',
        'color': Colors.blueGrey,
        'gradientColors': [Colors.blueGrey, Colors.blueGrey.shade700],
        'onTap': () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminScreen()),
        ),
      },
    ];
    
    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          return _RoleCard(
            icon: role['icon'] as IconData,
            title: role['title'] as String,
            subtitle: role['subtitle'] as String,
            color: role['color'] as Color,
            gradientColors: role['gradientColors'] as List<Color>,
            onTap: role['onTap'] as VoidCallback,
          );
        },
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    final iconSize = screenWidth < 600 ? 28.0 : 35.0;
    final iconPadding = screenWidth < 600 ? 14.0 : 18.0;
    final fontSize = screenWidth < 600 ? 16.0 : 18.0;
    final subtitleSize = screenWidth < 600 ? 10.0 : 11.0;
    
    return FadeInUp(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ingresar',
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 9,
                        color: color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}