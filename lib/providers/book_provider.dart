// lib/providers/book_provider.dart

import 'package:flutter/foundation.dart';

import '../data/database/db_helper.dart';
import '../data/models/book.dart';

class BookProvider with ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  BookProvider() {
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _dbHelper.getAllBooks();
    } catch (e) {
      debugPrint('Error fetching books: $e');
      _books = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // دالة لجلب تصنيفات الكتب الفريدة
  Future<List<String>> getUniqueCategories() async {
    if (_books.isEmpty) {
      await fetchBooks();
    }
    // 💡 فلترة وإزالة المكرر وعرضها كقائمة
    return _books.map((e) => e.category).toSet().toList();
  }

  // دالة لعرض الكتب حسب التصنيف
  Future<List<Book>> filterBooksByCategory(String category) async {
    return await _dbHelper.getBooksByCategory(category);
  }
}
