import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '/../../core/theme/app_theme.dart';

class AdminWebDashboardSection extends StatefulWidget {
  final Map<String, dynamic> stats;
  final bool isDarkMode;

  const AdminWebDashboardSection({
    super.key,
    required this.stats,
    this.isDarkMode = false,
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
    final backgroundColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final cardColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    
    int crossAxisCount = 4;
    if (isSmallScreen) crossAxisCount = 1;
    if (isMediumScreen) crossAxisCount = 2;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, const Color(0xFF0EA5E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.dashboard, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 24 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bienvenido al panel de administración',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickStat('${widget.stats['totalUsuarios']}', 'Usuarios'),
                      _buildQuickStat('${widget.stats['usuariosActivos']}', 'Activos'),
                      _buildQuickStat('${widget.stats['tasaAdherencia']}%', 'Adherencia'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.4,
            children: [
              _buildEnhancedStatCard(
                'Total Usuarios',
                widget.stats['totalUsuarios'].toString(),
                Icons.people_alt,
                Colors.blue,
                '+12%',
                'Usuarios registrados',
              ),
              _buildEnhancedStatCard(
                'Usuarios Activos',
                widget.stats['usuariosActivos'].toString(),
                Icons.person,
                Colors.green,
                '+8%',
                'Usuarios activos hoy',
              ),
              _buildEnhancedStatCard(
                'Pacientes',
                widget.stats['pacientes'].toString(),
                Icons.health_and_safety,
                Colors.orange,
                '+5%',
                'Pacientes atendidos',
              ),
              _buildEnhancedStatCard(
                'Médicos',
                widget.stats['medicos'].toString(),
                Icons.medical_services,
                Colors.purple,
                '+3%',
                'Médicos registrados',
              ),
              _buildEnhancedStatCard(
                'Familiares',
                widget.stats['familiares'].toString(),
                Icons.family_restroom,
                Colors.teal,
                '+10%',
                'Familiares conectados',
              ),
              _buildEnhancedStatCard(
                'Reportes Generados',
                widget.stats['reportesGenerados'].toString(),
                Icons.picture_as_pdf,
                Colors.red,
                '+15%',
                'Reportes este mes',
              ),
              _buildEnhancedStatCard(
                'Alertas',
                widget.stats['alertasUltimoMes'].toString(),
                Icons.notifications_active,
                Colors.amber,
                '+2%',
                'Alertas este mes',
              ),
              _buildEnhancedStatCard(
                'Tasa de Adherencia',
                '${widget.stats['tasaAdherencia']}%',
                Icons.trending_up,
                Colors.indigo,
                '+4%',
                'Adherencia medicamentos',
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(24),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.show_chart, color: AppTheme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Estadísticas y Tendencias',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildChartSelector('Usuarios', 0, Colors.blue),
                    const SizedBox(width: 12),
                    _buildChartSelector('Actividad', 1, Colors.green),
                    const SizedBox(width: 12),
                    _buildChartSelector('Alertas', 2, Colors.red),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 400,
                  child: _buildSelectedChart(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(24),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.pie_chart, color: AppTheme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Distribución de Usuarios',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
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
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(24),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.history, color: AppTheme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Actividad Reciente',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRecentActivityItem(
                  'Nuevo usuario registrado',
                  'Ana Pérez se unió a la plataforma',
                  'Hace 5 minutos',
                  Icons.person_add,
                  Colors.green,
                ),
                _buildRecentActivityItem(
                  'Reporte generado',
                  'Se generó un reporte de actividad',
                  'Hace 1 hora',
                  Icons.picture_as_pdf,
                  Colors.red,
                ),
                _buildRecentActivityItem(
                  'Alerta médica',
                  'Paciente requiere atención',
                  'Hace 2 horas',
                  Icons.notifications_active,
                  Colors.orange,
                ),
                _buildRecentActivityItem(
                  'Actualización de perfil',
                  'Dr. Ruiz actualizó su información',
                  'Hace 3 horas',
                  Icons.edit,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String trend,
    String subtitle,
  ) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    final cardColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    
    return Container(
      padding: const EdgeInsets.all(20),
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
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: GoogleFonts.inter(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: widget.isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityItem(
    String title,
    String description,
    String time,
    IconData icon,
    Color color,
  ) {
    final bgColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[50];
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    final borderColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: widget.isDarkMode ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSelector(String label, int index, Color color) {
    final isSelected = _selectedChartIndex == index;
    final bgColor = widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.grey[100];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (widget.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : (widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
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
        return _buildLineChart(_usuariosData, 'Crecimiento de Usuarios', Colors.blue);
      case 1:
        return _buildLineChart(_actividadData, 'Tasa de Actividad (%)', Colors.green);
      case 2:
        return _buildLineChart(_alertasData, 'Alertas por Mes', Colors.red);
      default:
        return _buildLineChart(_usuariosData, 'Crecimiento de Usuarios', Colors.blue);
    }
  }

  Widget _buildLineChart(List<FlSpot> data, String title, Color color) {
    final textColor = widget.isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final gridColor = widget.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 200,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: gridColor,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: gridColor,
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
                          style: TextStyle(fontSize: 10, color: textColor),
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
                        style: TextStyle(fontSize: 10, color: textColor),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: gridColor, width: 1),
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
                        color: widget.isDarkMode ? Colors.grey[900]! : Colors.white,
                        strokeWidth: 2,
                        strokeColor: color,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withValues(alpha: 0.1),
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
            color: Colors.orange,
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: widget.stats['medicos']?.toDouble() ?? 85,
            title: 'Médicos',
            color: Colors.purple,
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: widget.stats['familiares']?.toDouble() ?? 700,
            title: 'Familiares',
            color: Colors.teal,
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
      ),
    );
  }

  Widget _buildPieChartLegend() {
    final textColor = widget.isDarkMode ? Colors.white : Colors.grey[800];
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem('Pacientes', Colors.orange, widget.stats['pacientes']),
        const SizedBox(height: 12),
        _buildLegendItem('Médicos', Colors.purple, widget.stats['medicos']),
        const SizedBox(height: 12),
        _buildLegendItem('Familiares', Colors.teal, widget.stats['familiares']),
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
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            Text(
              value.toString(),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.grey[800],
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