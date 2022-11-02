import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GeneratePdf {
  static Future generatePdfNotes(String body) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Text(body, style: const pw.TextStyle(fontSize: 15))
          ]));
        }));

    return pdf.save();
    // Page
  }

  static Future generatePdfImages(String title, String body,
      BuildContext context, List<String> images) async {
    final pdf = pw.Document();

    for (var element in images) {
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
                child: pw.Image(pw.MemoryImage(base64Decode(element))));
          }));
    }

    return pdf.save();
  }
}
