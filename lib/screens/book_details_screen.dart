import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/book.dart';
import '../data/models/chapter.dart';
import '../providers/book_provider.dart';
import 'chapter_reader_screen.dart'; // سننشئها في الخطوة 6.2

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // نستخدم FutureBuilder لجلب فصول الكتاب مرة واحدة فقط
    return Scaffold(
      appBar: AppBar(title: Text(book.title), centerTitle: true),
      body: FutureBuilder<List<Chapter>>(
        future: Provider.of<BookProvider>(
          context,
          listen: false,
        ).getChaptersForBook(book.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // حالة التحميل
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // حالة وجود خطأ
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // حالة عدم وجود فصول
            return const Center(child: Text('لا توجد فصول لهذا الكتاب بعد.'));
          }

          // حالة عرض البيانات
          final chapters = snapshot.data!;
          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                    // الانتقال إلى شاشة القراءة
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterReaderScreen(
                          chapter: chapter,
                          bookTitle: book.title, // لتسهيل العرض في شاشة القراءة
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
    );
  }
}
