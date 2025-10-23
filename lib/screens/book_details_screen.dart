// lib/screens/book_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/book.dart';
import '../data/models/chapter.dart';
import '../providers/book_provider.dart';
import 'chapter_reader_screen.dart';
import 'pdf_viewer_screen.dart'; // ⬅️ استيراد شاشة عارض PDF

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // نستخدم FutureBuilder لجلب فصول الكتاب
    return Scaffold(
      appBar: AppBar(title: Text(book.title), centerTitle: true),
      body: Column(
        children: [
          // 💡 القسم الأول: زر عرض الكتاب بصيغة PDF (إذا كان المسار موجوداً)
          if (book.pdfPath != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(
                  'عرض الكتاب كاملاً بصيغة PDF',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        assetPath: book.pdfPath!,
                        title: book.title,
                      ),
                    ),
                  );
                },
              ),
            ),

          // 💡 القسم الثاني: عنوان قائمة الفصول النصية
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.format_list_bulleted, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'تصفح الفصول النصية المنسقة:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),

          // 💡 القسم الثالث: قائمة الفصول (قابلة للتوسع)
          Expanded(
            child: FutureBuilder<List<Chapter>>(
              // نستدعي جلب الفصول من Provider
              future: Provider.of<BookProvider>(
                context,
                listen: false,
              ).getChaptersForBook(book.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('حدث خطأ في جلب الفصول: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('لا توجد فصول نصية لهذا الكتاب بعد.'),
                  );
                }

                final chapters = snapshot.data!;
                return ListView.builder(
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.bookmark_border,
                          color: Colors.teal,
                        ),
                        title: Text(
                          chapter.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          // الانتقال إلى شاشة القراءة النصية
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapterReaderScreen(
                                chapter: chapter,
                                bookTitle: book.title,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
