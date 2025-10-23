// lib/utils/file_helper.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getFileFromAsset(String assetPath) async {
  // جلب المجلد المؤقت للتطبيق
  final dir = await getTemporaryDirectory();
  // إنشاء اسم للملف في المجلد المؤقت
  final file = File('${dir.path}/temp_pdf.pdf');

  try {
    // تحميل الملف كبايتات من الأصول
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    // كتابة البايتات إلى المسار المؤقت
    await file.writeAsBytes(bytes, flush: true);
  } catch (e) {
    // معالجة الخطأ
    debugPrint("Error copying asset to local storage: $e");
    throw Exception("Could not load PDF asset.");
  }

  return file;
}
