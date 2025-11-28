import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../shared/domain/models/project.dart';
import '../../../../shared/domain/models/client.dart';
import '../../../clients/presentation/providers/clients_provider.dart';
import '../../../../l10n/app_localizations.dart';

class ExportPdfButton extends ConsumerWidget {
  final Project project;
  final String clientId;

  const ExportPdfButton({
    super.key,
    required this.project,
    required this.clientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      icon: const Icon(Icons.picture_as_pdf),
      tooltip: l10n.exportPdf,
      onPressed: () => _exportToPdf(context, ref),
    );
  }

  Future<void> _exportToPdf(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final clientAsync = await ref.read(clientProvider(clientId).future);

      if (clientAsync == null) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorLoadingClient),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final pdf = await _generatePdf(project, clientAsync);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
          name: 'project_checklist_${clientAsync.name}_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorExportingPdf}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<pw.Document> _generatePdf(Project project, Client client) async {
    final pdf = pw.Document();

    // Use Hebrew-compatible fonts
    pw.ThemeData theme;
    try {
      // Use Noto Sans Hebrew for proper Hebrew text rendering
      theme = pw.ThemeData.withFont(
        base: await PdfGoogleFonts.notoSansHebrewRegular(),
        bold: await PdfGoogleFonts.notoSansHebrewBold(),
      );
    } catch (e) {
      // Fallback to regular Noto Sans if Hebrew fonts fail
      try {
        theme = pw.ThemeData.withFont(
          base: await PdfGoogleFonts.notoSansRegular(),
          bold: await PdfGoogleFonts.notoSansBold(),
        );
      } catch (e2) {
        // Last resort fallback
        theme = pw.ThemeData(
          defaultTextStyle: const pw.TextStyle(fontSize: 12),
        );
      }
    }

    pdf.addPage(
      pw.MultiPage(
        theme: theme,
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'רשימת משימות פרויקט',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'נוצר בתאריך: ${_formatDate(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Client Information
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'פרטי לקוח',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text('שם: ${client.name}'),
                      ),
                      pw.Expanded(
                        child: pw.Text('ת.ז: ${client.idNumber}'),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text('כתובת הנכס: ${client.propertyAddress}'),
                  pw.SizedBox(height: 5),
                  pw.Text('ועדה מטפלת: ${client.handlingCommittee}'),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Project Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                border: pw.Border.all(color: PdfColors.green200),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'התקדמות כללית: ${(project.overallCompletionPercentage * 100).round()}%',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    'נוצר: ${_formatDate(project.createdAt)}',
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            // Project Stages
            ...project.stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              return _buildStagePdf(stage, index + 1);
            }),
          ];
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildStagePdf(ProjectStage stage, int stageNumber) {
    final completionPercentage = stage.completionPercentage;
    final isComplete = completionPercentage == 1.0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Stage Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: isComplete ? PdfColors.green100 : PdfColors.grey100,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(8),
              topRight: pw.Radius.circular(8),
            ),
            border: pw.Border.all(
              color: isComplete ? PdfColors.green300 : PdfColors.grey300,
            ),
          ),
          child: pw.Row(
            children: [
              pw.Container(
                width: 40,
                height: 40,
                decoration: pw.BoxDecoration(
                  color: isComplete ? PdfColors.green : PdfColors.grey,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    isComplete ? 'V' : '$stageNumber',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: isComplete ? 20 : 16,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      stage.title,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${(completionPercentage * 100).round()}% הושלם',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: isComplete ? PdfColors.green700 : PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stage Items
        pw.Container(
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.only(
              bottomLeft: pw.Radius.circular(8),
              bottomRight: pw.Radius.circular(8),
            ),
          ),
          child: pw.Column(
            children: stage.items.map((item) {
              if (item.isTextOnly) {
                return pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey200),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Text('i', style: const pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Text(
                          item.title,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.blue700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey200),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          width: 16,
                          height: 16,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: item.isCompleted ? PdfColors.green : PdfColors.grey,
                              width: 2,
                            ),
                            color: item.isCompleted ? PdfColors.green : PdfColors.white,
                          ),
                          child: item.isCompleted
                              ? pw.Center(
                                  child: pw.Text(
                                    'V',
                                    style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                )
                              : pw.SizedBox(),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Expanded(
                          child: pw.Text(
                            item.title,
                            style: pw.TextStyle(
                              fontSize: 12,
                              decoration: item.isCompleted
                                  ? pw.TextDecoration.lineThrough
                                  : pw.TextDecoration.none,
                              color: item.isCompleted ? PdfColors.grey600 : PdfColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (item.notes.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.only(right: 24),
                        child: pw.Text(
                          'הערות: ${item.notes}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        pw.SizedBox(height: 20),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}