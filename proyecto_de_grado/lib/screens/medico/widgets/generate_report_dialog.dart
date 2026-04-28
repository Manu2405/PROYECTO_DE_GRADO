import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '/core/theme/app_theme.dart';
import '../models/medical_models.dart';
import '../services/medical_report_service.dart';

class GenerateReportDialog extends StatefulWidget {
  final List<Patient> patients;
  final double globalAdherence;

  const GenerateReportDialog({
    super.key,
    required this.patients,
    required this.globalAdherence,
  });

  @override
  State<GenerateReportDialog> createState() => _GenerateReportDialogState();
}

class _GenerateReportDialogState extends State<GenerateReportDialog> {
  bool _isLoading = false;
  File? _generatedFile;
  String? _generatedFileName;

  @override
  void dispose() {
    // Limpiar el estado cuando se cierra el diálogo
    _generatedFile = null;
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono animado
            ElasticIn(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Título
            const Text(
              'Generar Reporte Clínico',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona el tipo de reporte que deseas generar',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            if (_isLoading)
              _buildLoadingWidget()
            else if (_generatedFile != null)
              _buildSuccessWidget()
            else
              _buildOptionsWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsWidget() {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.people_alt,
          title: 'Reporte Consolidado',
          description: 'Informe general de todos los pacientes',
          color: Colors.indigo,
          onTap: () => _generateReport(() => MedicalReportService.generateConsolidatedReport(
            widget.patients,
            widget.globalAdherence,
          )),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          icon: Icons.person,
          title: 'Reporte por Paciente',
          description: 'Seleccionar paciente para informe individual',
          color: Colors.teal,
          onTap: () => _showPatientSelectionDialog(),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ZoomIn(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      children: [
        const SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Generando reporte...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Por favor espera un momento',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  Widget _buildSuccessWidget() {
    return Column(
      children: [
        // Animación de éxito
        ElasticIn(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '¡Reporte Generado!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        
        // Información del archivo
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade50, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              const Icon(Icons.picture_as_pdf, size: 45, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                _generatedFileName ?? 'documento.pdf',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
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
        const SizedBox(height: 20),
        
        // Botones de acción
        Row(
          children: [
            Expanded(
              child: FadeInLeft(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Limpiar estado y cerrar
                    setState(() {
                      _generatedFile = null;
                      _generatedFileName = null;
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Cerrar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FadeInRight(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_generatedFile != null) {
                      await MedicalReportService.openPdf(_generatedFile!);
                    }
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Ver PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (_generatedFile != null) {
                      await MedicalReportService.sharePdf(_generatedFile!);
                    }
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Compartir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    if (_generatedFile != null) {
                      await MedicalReportService.printPdf(_generatedFile!);
                    }
                  },
                  icon: const Icon(Icons.print, size: 18),
                  label: const Text('Imprimir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPatientSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Paciente'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.patients.length,
            itemBuilder: (context, index) {
              final patient = widget.patients[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: patient.getRiskColor().withValues(alpha: 0.1),
                  child: Text(
                    patient.getInitials(),
                    style: TextStyle(color: patient.getRiskColor()),
                  ),
                ),
                title: Text(patient.name),
                subtitle: Text('Adherencia: ${patient.adherence.toInt()}%'),
                trailing: Icon(Icons.chevron_right, color: patient.getRiskColor()),
                onTap: () {
                  Navigator.pop(context);
                  _generateReport(() => MedicalReportService.generatePatientReport(patient));
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateReport(Future<void> Function() reportFunction) async {
    setState(() {
      _isLoading = true;
      _generatedFile = null;
      _generatedFileName = null;
    });

    try {
      await reportFunction();
      
      // Pequeña pausa para asegurar que el archivo se guarde
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Obtener el último archivo generado
      final reports = await MedicalReportService.getSavedReports();
      if (reports.isNotEmpty && mounted) {
        setState(() {
          _generatedFile = reports.last;
          _generatedFileName = reports.last.path.split('/').last;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte generado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el reporte: $e')),
        );
      }
    }
  }
}