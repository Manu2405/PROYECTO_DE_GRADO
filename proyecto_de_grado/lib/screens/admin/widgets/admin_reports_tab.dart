import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_theme.dart';
import '../services/pdf_export_service.dart';

class AdminReportsTab extends StatelessWidget {
  const AdminReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen de cumplimiento
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    '📊 Reportes de Cumplimiento',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tasa de cumplimiento global: 88%',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _exportGlobalReport(context),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar Reporte Global'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Reportes por usuario
          FadeInLeft(
            child: Text(
              'Reportes por Usuario',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildUserReportCard(
            'Carlos Pérez',
            'Adulto Mayor',
            '85%',
            Colors.teal,
            Icons.elderly,
            context,
          ),
          const SizedBox(height: 10),
          _buildUserReportCard(
            'Ana Rodríguez',
            'Adulto Mayor',
            '92%',
            Colors.green,
            Icons.elderly,
            context,
          ),
          const SizedBox(height: 10),
          _buildUserReportCard(
            'Luis Martínez',
            'Adulto Mayor',
            '76%',
            Colors.orange,
            Icons.elderly,
            context,
          ),
          
          const SizedBox(height: 24),
          
          // Historial de tomas
          FadeInLeft(
            delay: const Duration(milliseconds: 400),
            child: Text(
              'Historial de Tomas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHistoryRow('Losartán 50mg', '14:30', 'Tomado', Colors.green),
                    const Divider(),
                    _buildHistoryRow('Metformina 850mg', '20:00', 'Pendiente', Colors.orange),
                    const Divider(),
                    _buildHistoryRow('Aspirina 100mg', '08:00', 'Tomado', Colors.green),
                    const Divider(),
                    _buildHistoryRow('Paracetamol 500mg', '22:00', 'No tomado', Colors.red),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildUserReportCard(String name, String role, String adherence, Color color, IconData icon, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(role, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$adherence de adherencia',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, size: 20),
              onPressed: () => _exportUserReport(context, name, role, adherence),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHistoryRow(String medicine, String time, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(medicine, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(time, textAlign: TextAlign.center)),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _exportGlobalReport(BuildContext context) async {
    try {
      // Mostrar loading con animación
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _LoadingDialog(),
      );
      
      final reportData = [
        {'usuario': 'Carlos Pérez', 'rol': 'Adulto Mayor', 'adherencia': '85%', 'medicamentos': '3'},
        {'usuario': 'Ana Rodríguez', 'rol': 'Adulto Mayor', 'adherencia': '92%', 'medicamentos': '4'},
        {'usuario': 'Luis Martínez', 'rol': 'Adulto Mayor', 'adherencia': '76%', 'medicamentos': '2'},
        {'usuario': 'María López', 'rol': 'Familiar', 'adherencia': '95%', 'medicamentos': '0'},
      ];
      
      await PdfExportService.generateReport(
        title: 'Reporte de Cumplimiento - Hogar "La Casa del Abuelo"',
        data: reportData,
        headers: ['Usuario', 'Rol', 'Adherencia', 'Medicamentos Activos'],
        columns: ['usuario', 'rol', 'adherencia', 'medicamentos'],
        totalAdherence: 88.0,
      );
      
      // Cerrar loading
      if (context.mounted) {
        Navigator.pop(context);
        
        // Obtener reportes guardados
        final reports = await PdfExportService.getSavedReports();
        
        if (reports.isNotEmpty && context.mounted) {
          final latestReport = reports.last;
          
          // Mostrar diálogo de éxito animado y moderno
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => _SuccessDialog(
              reportName: latestReport.path.split('/').last,
              reportFile: latestReport,
              isGlobal: true,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reporte PDF generado exitosamente')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el reporte: $e')),
        );
      }
    }
  }
  
  Future<void> _exportUserReport(BuildContext context, String name, String role, String adherence) async {
    try {
      // Mostrar loading con animación
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _LoadingDialog(),
      );
      
      // Datos de ejemplo para el historial de medicamentos
      final medicationHistory = [
        {'medicine': 'Losartán 50mg', 'time': '14:30', 'status': 'Tomado', 'date': DateTime.now().toString()},
        {'medicine': 'Metformina 850mg', 'time': '20:00', 'status': 'Pendiente', 'date': DateTime.now().toString()},
        {'medicine': 'Aspirina 100mg', 'time': '08:00', 'status': 'Tomado', 'date': DateTime.now().toString()},
      ];
      
      await PdfExportService.generateDetailedReport(
        userName: name,
        role: role,
        medicationHistory: medicationHistory,
        adherence: double.parse(adherence.replaceAll('%', '')),
      );
      
      // Cerrar loading
      if (context.mounted) {
        Navigator.pop(context);
        
        // Obtener reportes guardados
        final reports = await PdfExportService.getSavedReports();
        
        if (reports.isNotEmpty && context.mounted) {
          final latestReport = reports.last;
          
          // Mostrar diálogo de éxito animado y moderno
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => _SuccessDialog(
              reportName: latestReport.path.split('/').last,
              reportFile: latestReport,
              userName: name,
              isGlobal: false,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reporte PDF de $name generado exitosamente')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el reporte de $name: $e')),
        );
      }
    }
  }
}

// Diálogo de carga animado
class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInDown(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Generando reporte...',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Por favor espera',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Diálogo de éxito animado y moderno
class _SuccessDialog extends StatelessWidget {
  final String reportName;
  final String? userName;
  final bool isGlobal;
  final File reportFile;

  const _SuccessDialog({
    required this.reportName,
    required this.reportFile,
    this.userName,
    this.isGlobal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInDown(
        child: ElasticIn(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animación de check
                ElasticIn(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Título
                Text(
                  isGlobal ? '¡Reporte Global Listo!' : '¡Reporte Generado!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtítulo
                if (!isGlobal && userName != null)
                  Text(
                    'Reporte de $userName',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                const SizedBox(height: 16),
                // Tarjeta de información del archivo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf,
                        size: 40,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reportName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 12, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'Guardado exitosamente',
                              style: TextStyle(fontSize: 10, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: FadeInLeft(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Cerrar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 100),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await PdfExportService.openPdf(reportFile);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text('Ver PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Botón compartir
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await PdfExportService.sharePdf(reportFile);
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Compartir PDF'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
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