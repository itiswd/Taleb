// lib/screens/category_books_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/book.dart';
import '../providers/book_provider.dart';
import 'pdf_viewer_screen.dart';

class CategoryBooksScreen extends StatelessWidget {
  final String category;

  const CategoryBooksScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('مصنف: $category')),
      body: FutureBuilder<List<Book>>(
        future: bookProvider.filterBooksByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد كتب في مصنف "$category"'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Icon(
                    Icons.menu_book,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  title: Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'المؤلف: ${book.author}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // الانتقال مباشرة لعارض PDF
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerScreen(
                          assetPath: book.pdfPath,
                          title: book.title,
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
