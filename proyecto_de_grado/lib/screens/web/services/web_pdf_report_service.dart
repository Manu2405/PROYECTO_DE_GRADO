import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class WebPdfReportService {
  static Future<void> generateMedicalReport({
    required List<Map<String, String>> patients,
    required double globalAdherence,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'VitaSenior - Reporte Clinico',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Adherencia global: ${globalAdherence.toStringAsFixed(1)}%'),
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: const ['Paciente', 'Diagnostico', 'Riesgo', 'Adherencia'],
            data: patients
                .map((p) => [p['name'] ?? '', p['diagnosis'] ?? '', p['risk'] ?? '', '${p['adherence'] ?? ''}%'])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> generateAdminUsersReport({
    required List<Map<String, String>> users,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'VitaSenior - Reporte de Usuarios',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: const ['Nombre', 'Email', 'Rol', 'Estado'],
            data: users.map((u) => [u['nombre'] ?? '', u['email'] ?? '', u['rol'] ?? '', u['estado'] ?? '']).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> generateFamilyAdherenceReport({
    required String familyName,
    required List<Map<String, String>> history,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'VitaSenior - Reporte Familiar',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Responsable: $familyName'),
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: const ['Medicamento', 'Hora', 'Estado'],
            data: history.map((h) => [h['med'] ?? '', h['time'] ?? '', h['status'] ?? '']).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
