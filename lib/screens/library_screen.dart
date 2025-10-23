// lib/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import 'category_books_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('المصنفات')),
      body: FutureBuilder<List<String>>(
        future: bookProvider.getUniqueCategories(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('حدث خطأ أثناء جلب المصنفات: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('عفواً، لا توجد مصنفات متاحة.'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 4, // 💡 رفع مستوى الظل
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  leading: const Icon(
                    Icons.folder_special,
                    color: Color(0xFF4DB6AC),
                    size: 30,
                  ), // لون أيقونة مميز
                  title: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor, // لون النص الأساسي
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
