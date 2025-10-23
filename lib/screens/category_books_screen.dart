import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/book.dart';
import '../providers/book_provider.dart';
import 'book_details_screen.dart';

class CategoryBooksScreen extends StatelessWidget {
  final String category;

  const CategoryBooksScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('مصنف: $category'), centerTitle: true),
      body: FutureBuilder<List<Book>>(
        // جلب الكتب المفلترة
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
            padding: const EdgeInsets.all(8.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.teal),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('المؤلف: ${book.author}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // الانتقال لصفحة تفاصيل الكتاب
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
