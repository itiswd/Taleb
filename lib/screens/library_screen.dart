// lib/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import 'category_books_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 الحصول على الـ Provider دون الاستماع للتغييرات
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('المصنفات'), centerTitle: true),
      // 💡 نستخدم FutureBuilder لتشغيل عملية جلب التصنيفات
      body: FutureBuilder<List<String>>(
        // تشغيل دالة جلب التصنيفات التي قد تحتاج لتحميل الكتب أولاً
        future: bookProvider.getUniqueCategories(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // حالة التحميل الأولي
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // حالة وجود خطأ في جلب البيانات
            return Center(
              child: Text('حدث خطأ أثناء جلب المصنفات: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // حالة عدم وجود بيانات
            return const Center(child: Text('عفواً، لا توجد مصنفات متاحة.'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.folder, color: Colors.teal),
                  title: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryBooksScreen(category: category),
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
