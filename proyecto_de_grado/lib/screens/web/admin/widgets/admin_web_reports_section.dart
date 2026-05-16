import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class AdminWebReportsSection extends StatefulWidget {
  final Map<String, dynamic> stats;
  final Function(String reportType, DateTime? fechaInicio, DateTime? fechaFin) onGeneratePdf;

  const AdminWebReportsSection({
    super.key,
    required this.stats,
    required this.onGeneratePdf,
  });

  @override
  State<AdminWebReportsSection> createState() => _AdminWebReportsSectionState();
}

class _AdminWebReportsSectionState extends State<AdminWebReportsSection> {
  String _selectedReportType = 'usuarios';
  bool _isGenerating = false;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _generateReport() async {
    if (_isGenerating) return;
    
    setState(() {
      _isGenerating = true;
    });

    // Simular proceso de generación
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Llamar al callback con los datos seleccionados
    widget.onGeneratePdf(_selectedReportType, _fechaInicio, _fechaFin);
    
    if (mounted) {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _resetDates() {
    setState(() {
      _fechaInicio = null;
      _fechaFin = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final isMediumScreen = screenWidth >= 800 && screenWidth < 1200;
    
    // Colores del login
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
    
    return Container(
      decoration: BoxDecoration(gradient: bgGradient),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con gradiente
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: isSmallScreen
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 36),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Reportes y Estadísticas',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Genera reportes personalizados de la plataforma',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 40),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reportes y Estadísticas',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Genera reportes personalizados de la plataforma',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                
                const SizedBox(height: 32),
                
                // Grid de estadísticas rápidas
                isSmallScreen
                    ? Column(
                        children: [
                          _buildQuickStatCard(
                            'Usuarios',
                            widget.stats['totalUsuarios']?.toString() ?? '1250',
                            Icons.people_rounded,
                            const Color(0xFF0EA5E9),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickStatCard(
                            'Reportes Generados',
                            widget.stats['reportesGenerados']?.toString() ?? '3450',
                            Icons.picture_as_pdf_rounded,
                            const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickStatCard(
                            'Alertas',
                            widget.stats['alertasUltimoMes']?.toString() ?? '128',
                            Icons.notifications_active_rounded,
                            const Color(0xFFF59E0B),
                          ),
                          const SizedBox(height: 12),
                          _buildQuickStatCard(
                            'Adherencia',
                            '${widget.stats['tasaAdherencia']?.toString() ?? '87'}%',
                            Icons.trending_up_rounded,
                            const Color(0xFF10B981),
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: isMediumScreen 
                                ? (constraints.maxWidth - 48) / 2 
                                : (constraints.maxWidth - 64) / 4,
                            child: _buildQuickStatCard(
                              'Usuarios',
                              widget.stats['totalUsuarios']?.toString() ?? '1250',
                              Icons.people_rounded,
                              const Color(0xFF0EA5E9),
                            ),
                          ),
                          SizedBox(
                            width: isMediumScreen 
                                ? (constraints.maxWidth - 48) / 2 
                                : (constraints.maxWidth - 64) / 4,
                            child: _buildQuickStatCard(
                              'Reportes Generados',
                              widget.stats['reportesGenerados']?.toString() ?? '3450',
                              Icons.picture_as_pdf_rounded,
                              const Color(0xFFEF4444),
                            ),
                          ),
                          SizedBox(
                            width: isMediumScreen 
                                ? (constraints.maxWidth - 48) / 2 
                                : (constraints.maxWidth - 64) / 4,
                            child: _buildQuickStatCard(
                              'Alertas',
                              widget.stats['alertasUltimoMes']?.toString() ?? '128',
                              Icons.notifications_active_rounded,
                              const Color(0xFFF59E0B),
                            ),
                          ),
                          SizedBox(
                            width: isMediumScreen 
                                ? (constraints.maxWidth - 48) / 2 
                                : (constraints.maxWidth - 64) / 4,
                            child: _buildQuickStatCard(
                              'Adherencia',
                              '${widget.stats['tasaAdherencia']?.toString() ?? '87'}%',
                              Icons.trending_up_rounded,
                              const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                
                const SizedBox(height: 32),
                
                // Configuración del reporte
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.description_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Configuración del Reporte',
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Opciones de reporte
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isSmallScreen ? 1 : (isMediumScreen ? 2 : 4),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isSmallScreen ? 3 : 2.5,
                        children: [
                          _buildReportOption(
                            'usuarios',
                            'Reporte de Usuarios',
                            'Usuarios registrados, roles y actividad',
                            Icons.people_rounded,
                            const Color(0xFF0EA5E9),
                            isSmallScreen,
                          ),
                          _buildReportOption(
                            'actividad',
                            'Reporte de Actividad',
                            'Estadísticas de uso y sesiones',
                            Icons.analytics_rounded,
                            const Color(0xFF10B981),
                            isSmallScreen,
                          ),
                          _buildReportOption(
                            'salud',
                            'Reporte de Salud',
                            'Indicadores de salud y adherencia',
                            Icons.monitor_heart_rounded,
                            const Color(0xFFEF4444),
                            isSmallScreen,
                          ),
                          _buildReportOption(
                            'alertas',
                            'Reporte de Alertas',
                            'Alertas generadas y su estado',
                            Icons.notifications_active_rounded,
                            const Color(0xFFF59E0B),
                            isSmallScreen,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Rango de fechas
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1929).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range_rounded, color: AppTheme.primaryColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Rango de fechas (opcional)',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const Spacer(),
                                if (_fechaInicio != null || _fechaFin != null)
                                  TextButton(
                                    onPressed: _resetDates,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      minimumSize: Size.zero,
                                    ),
                                    child: Text(
                                      'Limpiar',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFFEF4444),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            isSmallScreen
                                ? Column(
                                    children: [
                                      _buildDateSelector('Fecha inicio', Icons.calendar_today_rounded, true),
                                      const SizedBox(height: 12),
                                      _buildDateSelector('Fecha fin', Icons.calendar_today_rounded, false),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: _buildDateSelector('Fecha inicio', Icons.calendar_today_rounded, true),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildDateSelector('Fecha fin', Icons.calendar_today_rounded, false),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Botón generar reporte
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isGenerating ? null : _generateReport,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _isGenerating
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Generando reporte...',
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.picture_as_pdf_rounded, size: isSmallScreen ? 18 : 20),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Generar Reporte en PDF',
                                      style: GoogleFonts.inter(
                                        fontSize: isSmallScreen ? 14 : 16,
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2B3D).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
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
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(String type, String title, String description, IconData icon, Color color, bool isSmallScreen) {
    final isSelected = _selectedReportType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFF0A1929).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, IconData icon, bool isInicio) {
    final selectedDate = isInicio ? _fechaInicio : _fechaFin;
    
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppTheme.primaryColor,
                  surface: Color(0xFF0F2B3D),
                ),
                dialogBackgroundColor: const Color(0xFF0F2B3D),
              ),
              child: child!,
            );
          },
        );
        if (date != null && mounted) {
          setState(() {
            if (isInicio) {
              _fechaInicio = date;
              // Si la fecha fin es anterior a la fecha inicio, resetear fecha fin
              if (_fechaFin != null && _fechaFin!.isBefore(date)) {
                _fechaFin = null;
              }
            } else {
              // Validar que la fecha fin no sea anterior a la fecha inicio
              if (_fechaInicio != null && date.isBefore(_fechaInicio!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La fecha fin no puede ser anterior a la fecha inicio'),
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                );
                return;
              }
              _fechaFin = date;
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1929).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: selectedDate != null ? Colors.white : Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, size: 20, color: Colors.white.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}