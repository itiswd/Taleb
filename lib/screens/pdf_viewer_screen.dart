// lib/screens/pdf_viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:taleb/utils/file_helper.dart';

class PdfViewerScreen extends StatefulWidget {
  final String assetPath;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // نسخ ملف الـ Asset إلى مسار محلي قبل العرض
    getFileFromAsset(widget.assetPath)
        .then((file) {
          if (mounted) {
            setState(() {
              localPath = file.path;
              _isLoading = false;
            });
          }
        })
        .catchError((e) {
          if (mounted) {
            setState(() {
              localPath = null;
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل تحميل ملف PDF: ${e.toString()}')),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
          ? PDFView(
              filePath: localPath,

              // 💡 التعديلات لفرض التمرير العمودي:
              enableSwipe: true, // السماح بالسحب
              swipeHorizontal: false, // ⬅️ تعطيل السحب الأفقي
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              defaultPage: 0,
              fitEachPage: true,
            )
          : const Center(child: Text('عذراً، لم يتم تحميل ملف PDF.')),
    );
  }
}
