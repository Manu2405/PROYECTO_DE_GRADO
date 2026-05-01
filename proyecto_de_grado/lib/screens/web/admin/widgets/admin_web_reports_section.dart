import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class AdminWebReportsSection extends StatefulWidget {
  final Map<String, dynamic> stats;
  final Function(String reportType) onGeneratePdf;
  final bool isDarkMode;

  const AdminWebReportsSection({
    super.key,
    required this.stats,
    required this.onGeneratePdf,
    this.isDarkMode = false,
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
    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isGenerating = false;
    });
    
    widget.onGeneratePdf(_selectedReportType);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final isMediumScreen = screenWidth >= 800 && screenWidth < 1200;
    final cardColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isSmallScreen
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.bar_chart,
                              color: Colors.white,
                              size: 32,
                            ),
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
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Genera reportes personalizados de la plataforma',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: secondaryTextColor,
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
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.bar_chart,
                              color: Colors.white,
                              size: 32,
                            ),
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
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Genera reportes personalizados de la plataforma',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 32),
              
              isSmallScreen
                  ? Column(
                      children: [
                        _buildQuickStatCard(
                          'Usuarios',
                          widget.stats['totalUsuarios']?.toString() ?? '0',
                          Icons.people,
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildQuickStatCard(
                          'Actividad',
                          widget.stats['actividadTotal']?.toString() ?? '0',
                          Icons.trending_up,
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildQuickStatCard(
                          'Alertas',
                          widget.stats['alertasActivas']?.toString() ?? '0',
                          Icons.notifications_active,
                          Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _buildQuickStatCard(
                          'Reportes',
                          widget.stats['reportesGenerados']?.toString() ?? '0',
                          Icons.description,
                          Colors.purple,
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
                              : (constraints.maxWidth - 48) / 4,
                          child: _buildQuickStatCard(
                            'Usuarios',
                            widget.stats['totalUsuarios']?.toString() ?? '0',
                            Icons.people,
                            Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: isMediumScreen 
                              ? (constraints.maxWidth - 48) / 2 
                              : (constraints.maxWidth - 48) / 4,
                          child: _buildQuickStatCard(
                            'Actividad',
                            widget.stats['actividadTotal']?.toString() ?? '0',
                            Icons.trending_up,
                            Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: isMediumScreen 
                              ? (constraints.maxWidth - 48) / 2 
                              : (constraints.maxWidth - 48) / 4,
                          child: _buildQuickStatCard(
                            'Alertas',
                            widget.stats['alertasActivas']?.toString() ?? '0',
                            Icons.notifications_active,
                            Colors.orange,
                          ),
                        ),
                        SizedBox(
                          width: isMediumScreen 
                              ? (constraints.maxWidth - 48) / 2 
                              : (constraints.maxWidth - 48) / 4,
                          child: _buildQuickStatCard(
                            'Reportes',
                            widget.stats['reportesGenerados']?.toString() ?? '0',
                            Icons.description,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 32),
              
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description_outlined, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
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
                          Icons.people,
                          Colors.blue,
                          isSmallScreen,
                        ),
                        _buildReportOption(
                          'actividad',
                          'Reporte de Actividad',
                          'Estadísticas de uso y sesiones',
                          Icons.analytics,
                          Colors.green,
                          isSmallScreen,
                        ),
                        _buildReportOption(
                          'salud',
                          'Reporte de Salud',
                          'Indicadores de salud y adherencia',
                          Icons.monitor_heart,
                          Colors.red,
                          isSmallScreen,
                        ),
                        _buildReportOption(
                          'alertas',
                          'Reporte de Alertas',
                          'Alertas generadas y su estado',
                          Icons.notifications_active,
                          Colors.orange,
                          isSmallScreen,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rango de fechas',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          isSmallScreen
                              ? Column(
                                  children: [
                                    _buildDateSelector('Fecha inicio', Icons.calendar_today, true),
                                    const SizedBox(height: 12),
                                    _buildDateSelector('Fecha fin', Icons.calendar_today, false),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: _buildDateSelector('Fecha inicio', Icons.calendar_today, true),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildDateSelector('Fecha fin', Icons.calendar_today, false),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isGenerating ? null : _generateReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
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
                                  Icon(Icons.picture_as_pdf, size: isSmallScreen ? 18 : 20),
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
    );
  }

  Widget _buildQuickStatCard(String label, String value, IconData icon, Color color) {
    final cardColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
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
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
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
    final bgColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50];
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : (widget.isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
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
                            color: textColor,
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle, color: color, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
    final borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppTheme.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          setState(() {
            if (isInicio) {
              _fechaInicio = date;
            } else {
              _fechaFin = date;
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: selectedDate != null ? textColor : (widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 20, color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}