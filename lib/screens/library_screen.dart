// في ملف lib/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taleb/screens/category_books_screen.dart';
import 'package:taleb/screens/search_delegate.dart';

import '../providers/book_provider.dart';
import 'book_details_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكتبة والمصنفات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    ChapterSearchDelegate(), // استخدام الديليجيت الذي أنشأناه
              );
            },
          ),
          // زر المصنفات
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () {
              // هنا سنفتح نافذة المصنفات (الخطوة القادمة)
              _showCategoriesSheet(context);
            },
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (bookProvider.books.isEmpty) {
            return const Center(child: Text('لا توجد كتب في المكتبة.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: bookProvider.books.length,
            itemBuilder: (context, index) {
              final book = bookProvider.books[index];
              return Card(
                // ... (نفس تصميم البطاقة السابق) ...
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.teal),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'المؤلف: ${book.author} | التصنيف: ${book.category}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
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

  void _showCategoriesSheet(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<List<String>>(
          future: bookProvider.getUniqueCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final categories = snapshot.data ?? [];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'اختر مصنفاً',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // عرض المصنفات كقائمة
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        leading: const Icon(Icons.category, color: Colors.teal),
                        title: Text(category),
                        onTap: () {
                          Navigator.pop(context); // إغلاق النافذة
                          // الانتقال إلى شاشة عرض كتب المصنف المحدد
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryBooksScreen(category: category),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
