// في ملف lib/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        // يمكن إضافة زر البحث والتصنيف هنا
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
}
