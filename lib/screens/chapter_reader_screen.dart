import 'package:flutter/material.dart';

import '../data/models/chapter.dart';

class ChapterReaderScreen extends StatefulWidget {
  final Chapter chapter;
  final String bookTitle;

  const ChapterReaderScreen({
    super.key,
    required this.chapter,
    required this.bookTitle,
  });

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  // متغيرات لتخصيص القراءة
  double _fontSize = 18.0;
  bool _isDarkMode = false;

  // دالة لفتح إعدادات القراءة
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إعدادات القراءة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // التحكم بحجم الخط
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('حجم الخط:'),
                  DropdownButton<double>(
                    value: _fontSize,
                    items: const [16.0, 18.0, 20.0, 24.0, 28.0]
                        .map(
                          (size) => DropdownMenuItem(
                            value: size,
                            child: Text(size.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (newSize) {
                      if (newSize != null) {
                        setState(() {
                          _fontSize = newSize;
                        });
                        Navigator.pop(context); // إغلاق الحوار
                      }
                    },
                  ),
                ],
              ),
              // التحكم بالوضع الداكن
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الوضع الليلي:'),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      Navigator.pop(context); // إغلاق الحوار
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان بناءً على الوضع
    final Color backgroundColor = _isDarkMode ? Colors.black87 : Colors.white;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text(widget.bookTitle, style: TextStyle(color: textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الفصل
            Text(
              widget.chapter.title,
              style: TextStyle(
                fontSize: _fontSize + 6, // أكبر قليلاً من النص الأساسي
                fontWeight: FontWeight.bold,
                color: Colors.teal, // لون مميز للعنوان
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Colors.teal),
            const SizedBox(height: 16),
            // محتوى الفصل
            Text(
              widget.chapter.content,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.8, // تباعد مريح للأسطر
                color: textColor,
              ),
              textAlign: TextAlign.justify, // محاذاة النص
            ),
          ],
        ),
      ),
    );
  }
}
