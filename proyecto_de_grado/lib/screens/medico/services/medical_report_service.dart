import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../models/medical_models.dart';

class MedicalReportService {
  static Future<void> generateConsolidatedReport(
    List<Patient> patients,
    double globalAdherence,
  ) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'VitaSenior - Reporte Clínico Consolidado',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.indigo,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Fecha de generación: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                  ),
                  pw.SizedBox(height: 20),
                  
                  pw.Container(
                    padding: pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.indigo50,
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Resumen General',
                          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total de Pacientes:', style: pw.TextStyle(fontSize: 14)),
                            pw.Text('${patients.length}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Adherencia Global:', style: pw.TextStyle(fontSize: 14)),
                            pw.Text(
                              '${globalAdherence.toInt()}%',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: globalAdherence >= 80 ? PdfColors.green : PdfColors.orange,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Pacientes con Riesgo Alto:', style: pw.TextStyle(fontSize: 14)),
                            pw.Text(
                              '${patients.where((p) => p.riskLevel == RiskLevel.high).length}',
                              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Detalle de Pacientes',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                ],
              ),
            ),
            pw.Table.fromTextArray(
              headers: ['Paciente', 'Edad', 'Diagnóstico', 'Adherencia', 'Riesgo'],
              data: patients.map((p) => [
                p.name,
                '${p.age}',
                p.diagnosis,
                '${p.adherence.toInt()}%',
                p.getRiskText(),
              ]).toList(),
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: PdfColors.indigo),
              cellAlignment: pw.Alignment.centerLeft,
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Nota: Este reporte ha sido generado automáticamente por el sistema VitaSenior.',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        ),
      );
      
      await _savePdf(pdf, 'reporte_consolidado');
      
    } catch (e) {
      rethrow;
    }
  }
  
  static Future<void> generatePatientReport(Patient patient) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'VitaSenior - Reporte Individual',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text('Información del Paciente', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    _buildInfoRow('Nombre:', patient.name),
                    _buildInfoRow('Edad:', '${patient.age} años'),
                    _buildInfoRow('Última visita:', patient.lastVisit),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: patient.adherence >= 80 ? PdfColors.green100 : PdfColors.red100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text('Adherencia al Tratamiento', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          '${patient.adherence.toInt()}%',
                          style: pw.TextStyle(
                            fontSize: 36,
                            fontWeight: pw.FontWeight.bold,
                            color: patient.adherence >= 80 ? PdfColors.green : PdfColors.red,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.LinearProgressIndicator(
                      value: patient.adherence / 100,
                      backgroundColor: PdfColors.grey300,
                      valueColor: patient.adherence >= 80 
                          ? PdfColors.green 
                          : patient.adherence >= 60 
                              ? PdfColors.orange 
                              : PdfColors.red,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Medicamentos', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Medicamento', 'Dosis', 'Horario', 'Estado'],
                data: patient.medications.map((m) => [
                  m.name,
                  m.dosage,
                  m.schedule,
                  m.isActive ? 'Activo' : 'Inactivo',
                ]).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Contactos', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              _buildInfoRow('Familiar:', patient.familyContact ?? 'No registrado'),
              _buildInfoRow('Cuidador:', patient.caregiver ?? 'No asignado'),
            ],
          ),
        ),
      );
      
      await _savePdf(pdf, 'reporte_${patient.name.replaceAll(' ', '_')}');
      
    } catch (e) {
      rethrow;
    }
  }
  
  static Future<void> _savePdf(pw.Document pdf, String baseName) async {
    final directory = await getApplicationDocumentsDirectory();
    final reportsDir = Directory('${directory.path}/ReportesMedicos');
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }
    
    final fileName = '${baseName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${reportsDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    
    await OpenFile.open(file.path);
  }
  
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 120, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        pw.Expanded(child: pw.Text(value)),
        pw.SizedBox(height: 8),
      ],
    );
  }
  
  // Métodos adicionales
  static Future<void> openPdf(File file) async {
    try {
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        print('No se pudo abrir el PDF');
      }
    } catch (e) {
      print('Error al abrir PDF: $e');
    }
  }
  
  static Future<void> sharePdf(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '📊 Reporte clínico generado por VitaSenior\n\nAdjunto encontrará el reporte detallado del paciente.',
      );
    } catch (e) {
      print('Error al compartir PDF: $e');
    }
  }
  
  static Future<void> printPdf(File file) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => file.readAsBytes(),
      );
    } catch (e) {
      print('Error al imprimir PDF: $e');
    }
  }
  
  static Future<List<File>> getSavedReports() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${directory.path}/ReportesMedicos');
      
      if (!await reportsDir.exists()) {
        return [];
      }
      
      final files = await reportsDir.list().toList();
      return files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
    } catch (e) {
      print('Error al obtener reportes: $e');
      return [];
    }
  }
}