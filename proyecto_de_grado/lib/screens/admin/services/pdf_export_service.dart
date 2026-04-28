import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PdfExportService {
  static Future<void> generateReport({
    required String title,
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required List<String> columns,
    required double totalAdherence,
  }) async {
    try {
      // Solicitar permisos de almacenamiento
      await _requestStoragePermission();
      
      // Crear documento PDF
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
                    'VitaSenior - Reporte de Cumplimiento',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    title,
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Fecha de generación: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Tasa de Cumplimiento Global:',
                          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '$totalAdherence%',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: totalAdherence >= 80 ? PdfColors.green : PdfColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Detalle de Reportes',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                ],
              ),
            ),
            if (data.isNotEmpty)
              pw.Table.fromTextArray(
                headers: headers,
                data: data.map((item) => columns.map((col) => item[col] ?? '').toList()).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Nota: Este reporte es generado automáticamente por el sistema VitaSenior.',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
            pw.Text(
              'Para más información, contacte al administrador.',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        ),
      );
      
      // Guardar en Documents (más confiable)
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/Reportes');
      
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      final fileName = 'reporte_global_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${downloadsDir.path}/$fileName');
      
      // Guardar el PDF
      await file.writeAsBytes(await pdf.save());
      
      print('✅ PDF guardado exitosamente en: ${file.path}');
      
      // Mostrar diálogo de éxito con opciones
      await _showSuccessDialog(file);
      
    } catch (e) {
      print('❌ Error al generar PDF: $e');
      rethrow;
    }
  }
  
  static Future<void> generateDetailedReport({
    required String userName,
    required String role,
    required List<Map<String, dynamic>> medicationHistory,
    required double adherence,
  }) async {
    try {
      await _requestStoragePermission();
      
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'VitaSenior - Reporte Individual',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Usuario: $userName', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('Rol: $role', style: pw.TextStyle(fontSize: 14)),
              pw.Text('Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: adherence >= 80 ? PdfColors.green100 : PdfColors.orange100,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  'Tasa de adherencia: $adherence%',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Historial de Medicamentos:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              if (medicationHistory.isNotEmpty)
                pw.Table.fromTextArray(
                  headers: ['Medicamento', 'Hora', 'Estado', 'Fecha'],
                  data: medicationHistory.map((item) => [
                    item['medicine'] ?? '',
                    item['time'] ?? '',
                    item['status'] ?? '',
                    item['date'] ?? '',
                  ]).toList(),
                  border: pw.TableBorder.all(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Nota: Este reporte es generado automáticamente por el sistema VitaSenior.',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
              pw.Text(
                'Para más información, contacte al administrador.',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ],
          ),
        ),
      );
      
      // Guardar en Documents
      final directory = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${directory.path}/Reportes');
      
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }
      
      final fileName = 'reporte_${userName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${reportsDir.path}/$fileName');
      
      await file.writeAsBytes(await pdf.save());
      
      print('✅ PDF guardado exitosamente en: ${file.path}');
      
      await _showSuccessDialog(file);
      
    } catch (e) {
      print('❌ Error al generar PDF detallado: $e');
      rethrow;
    }
  }
  
  static Future<void> _showSuccessDialog(File file) async {
    // Mostrar diálogo de éxito (esto debe llamarse desde un contexto)
    // Como es un servicio estático, usaremos print y el método sharePdf
    print('PDF generado exitosamente: ${file.path}');
  }
  
  static Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        print('✅ Permiso de almacenamiento concedido');
      } else {
        print('⚠️ Permiso de almacenamiento denegado');
      }
    }
  }
  
  // Método para compartir el PDF
  static Future<void> sharePdf(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Reporte VitaSenior - Cumplimiento de medicamentos',
      );
      print('✅ PDF compartido exitosamente');
    } catch (e) {
      print('❌ Error al compartir PDF: $e');
    }
  }
  
  // Método para obtener la lista de reportes guardados
  static Future<List<File>> getSavedReports() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${directory.path}/Reportes');
      
      if (!await reportsDir.exists()) {
        return [];
      }
      
      final files = await reportsDir.list().toList();
      return files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
    } catch (e) {
      print('❌ Error al obtener reportes guardados: $e');
      return [];
    }
  }
  
  // Método para eliminar un reporte
  static Future<bool> deleteReport(File file) async {
    try {
      await file.delete();
      print('✅ Reporte eliminado: ${file.path}');
      return true;
    } catch (e) {
      print('❌ Error al eliminar reporte: $e');
      return false;
    }
  }
  
  // Método para abrir un PDF
  static Future<void> openPdf(File file) async {
    try {
      final result = await OpenFile.open(file.path);
      if (result.type == ResultType.done) {
        print('✅ PDF abierto exitosamente');
      } else {
        print('⚠️ No se pudo abrir el PDF');
      }
    } catch (e) {
      print('❌ Error al abrir PDF: $e');
    }
  }
}