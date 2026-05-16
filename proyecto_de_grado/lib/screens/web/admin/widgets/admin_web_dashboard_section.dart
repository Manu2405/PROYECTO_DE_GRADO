import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '/../../core/theme/app_theme.dart';

class AdminWebDashboardSection extends StatefulWidget {
  final Map<String, dynamic> stats;

  const AdminWebDashboardSection({
    super.key,
    required this.stats,
  });

  @override
  State<AdminWebDashboardSection> createState() => _AdminWebDashboardSectionState();
}

class _AdminWebDashboardSectionState extends State<AdminWebDashboardSection> {
  int _selectedChartIndex = 0;
  
  final List<FlSpot> _usuariosData = [
    const FlSpot(1, 800),
    const FlSpot(2, 950),
    const FlSpot(3, 1100),
    const FlSpot(4, 1050),
    const FlSpot(5, 1180),
    const FlSpot(6, 1250),
  ];
  
  final List<FlSpot> _actividadData = [
    const FlSpot(1, 65),
    const FlSpot(2, 70),
    const FlSpot(3, 75),
    const FlSpot(4, 82),
    const FlSpot(5, 85),
    const FlSpot(6, 87),
  ];
  
  final List<FlSpot> _alertasData = [
    const FlSpot(1, 45),
    const FlSpot(2, 38),
    const FlSpot(3, 52),
    const FlSpot(4, 48),
    const FlSpot(5, 35),
    const FlSpot(6, 28),
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    final isMediumScreen = MediaQuery.of(context).size.width >= 800 && MediaQuery.of(context).size.width < 1200;
    
    int crossAxisCount = 4;
    if (isSmallScreen) crossAxisCount = 1;
    if (isMediumScreen) crossAxisCount = 2;

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

    return Container(
      decoration: BoxDecoration(gradient: bgGradient),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner con gradiente del login
            Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.all(24),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel de Administración',
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bienvenido al panel de control - Visualiza estadísticas y tendencias',
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
            
            const SizedBox(height: 16),
            
            // Grid de estadísticas - Tarjetas con fondo semitransparente
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.3,
                children: [
                  _buildStatCard(
                    'Total Usuarios',
                    widget.stats['totalUsuarios'].toString(),
                    Icons.people_alt_rounded,
                    const Color(0xFF0EA5E9),
                  ),
                  _buildStatCard(
                    'Usuarios Activos',
                    widget.stats['usuariosActivos'].toString(),
                    Icons.person_rounded,
                    const Color(0xFF10B981),
                  ),
                  _buildStatCard(
                    'Pacientes',
                    widget.stats['pacientes'].toString(),
                    Icons.health_and_safety_rounded,
                    const Color(0xFFF59E0B),
                  ),
                  _buildStatCard(
                    'Médicos',
                    widget.stats['medicos'].toString(),
                    Icons.medical_services_rounded,
                    const Color(0xFF8B5CF6),
                  ),
                  _buildStatCard(
                    'Familiares',
                    widget.stats['familiares'].toString(),
                    Icons.family_restroom_rounded,
                    const Color(0xFF14B8A6),
                  ),
                  _buildStatCard(
                    'Reportes Generados',
                    widget.stats['reportesGenerados'].toString(),
                    Icons.picture_as_pdf_rounded,
                    const Color(0xFFEF4444),
                  ),
                  _buildStatCard(
                    'Alertas',
                    widget.stats['alertasUltimoMes'].toString(),
                    Icons.notifications_active_rounded,
                    const Color(0xFFFBBF24),
                  ),
                  _buildStatCard(
                    'Tasa de Adherencia',
                    '${widget.stats['tasaAdherencia']}%',
                    Icons.trending_up_rounded,
                    const Color(0xFF6366F1),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Gráfico de tendencias - Fondo semitransparente
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2B3D).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                          child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Estadísticas y Tendencias',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildChartSelector('Usuarios', 0, const Color(0xFF0EA5E9)),
                        const SizedBox(width: 12),
                        _buildChartSelector('Actividad', 1, const Color(0xFF10B981)),
                        const SizedBox(width: 12),
                        _buildChartSelector('Alertas', 2, const Color(0xFFEF4444)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 350,
                      child: _buildSelectedChart(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Gráfico de pastel - Distribución de usuarios
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2B3D).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                          child: const Icon(Icons.pie_chart_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Distribución de Usuarios',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    isSmallScreen
                        ? Column(
                            children: [
                              SizedBox(
                                height: 250,
                                child: _buildPieChart(),
                              ),
                              const SizedBox(height: 24),
                              _buildPieChartLegend(),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 300,
                                  child: _buildPieChart(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildPieChartLegend(),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Actividad Reciente
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2B3D).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                          child: const Icon(Icons.history_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Actividad Reciente',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildActivityItem(
                      'Nuevo usuario registrado',
                      'Ana Pérez se unió a la plataforma',
                      'Hace 5 minutos',
                      Icons.person_add_rounded,
                      const Color(0xFF10B981),
                    ),
                    _buildActivityItem(
                      'Reporte generado',
                      'Se generó un reporte de actividad mensual',
                      'Hace 1 hora',
                      Icons.picture_as_pdf_rounded,
                      const Color(0xFFEF4444),
                    ),
                    _buildActivityItem(
                      'Alerta médica',
                      'Paciente requiere atención inmediata',
                      'Hace 2 horas',
                      Icons.notifications_active_rounded,
                      const Color(0xFFF59E0B),
                    ),
                    _buildActivityItem(
                      'Actualización de perfil',
                      'Dr. Carlos Ruiz actualizó su información',
                      'Hace 3 horas',
                      Icons.edit_rounded,
                      const Color(0xFF0EA5E9),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2B3D).withValues(alpha: 0.8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String description,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1929).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSelector(String label, int index, Color color) {
    final isSelected = _selectedChartIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFF0A1929),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    switch (_selectedChartIndex) {
      case 0:
        return _buildLineChart(_usuariosData, 'Crecimiento de Usuarios', const Color(0xFF0EA5E9));
      case 1:
        return _buildLineChart(_actividadData, 'Tasa de Actividad (%)', const Color(0xFF10B981));
      case 2:
        return _buildLineChart(_alertasData, 'Alertas por Mes', const Color(0xFFEF4444));
      default:
        return _buildLineChart(_usuariosData, 'Crecimiento de Usuarios', const Color(0xFF0EA5E9));
    }
  }

  Widget _buildLineChart(List<FlSpot> data, String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withValues(alpha: 0.1),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white.withValues(alpha: 0.1),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                      if (value.toInt() - 1 >= 0 && value.toInt() - 1 < months.length) {
                        return Text(
                          months[value.toInt() - 1],
                          style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.5)),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.5)),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              minX: 1,
              maxX: 6,
              minY: 0,
              maxY: _getMaxY(data),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: color,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFF0A1929),
                        strokeWidth: 2,
                        strokeColor: color,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: widget.stats['pacientes']?.toDouble() ?? 450,
            title: 'Pacientes',
            color: const Color(0xFFF59E0B),
            radius: 80,
            titleStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: widget.stats['medicos']?.toDouble() ?? 85,
            title: 'Médicos',
            color: const Color(0xFF8B5CF6),
            radius: 80,
            titleStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: widget.stats['familiares']?.toDouble() ?? 700,
            title: 'Familiares',
            color: const Color(0xFF14B8A6),
            radius: 80,
            titleStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
        pieTouchData: PieTouchData(enabled: false),
      ),
    );
  }

  Widget _buildPieChartLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem('Pacientes', const Color(0xFFF59E0B), widget.stats['pacientes']),
        const SizedBox(height: 12),
        _buildLegendItem('Médicos', const Color(0xFF8B5CF6), widget.stats['medicos']),
        const SizedBox(height: 12),
        _buildLegendItem('Familiares', const Color(0xFF14B8A6), widget.stats['familiares']),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, dynamic value) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value.toString(),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _getMaxY(List<FlSpot> data) {
    double maxY = 0;
    for (var spot in data) {
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }
    return maxY + (maxY * 0.2);
  }
}