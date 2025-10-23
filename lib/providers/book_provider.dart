import 'package:flutter/material.dart';

import '../data/database/db_helper.dart';
import '../data/models/book.dart';
import '../data/models/chapter.dart';

class BookProvider with ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  List<Book> _books = [];
  bool _isLoading = true;
  // متغيرات حالة البحث
  final List<Chapter> _searchResults = [];
  final bool _isSearching = false;

  List<Chapter> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  // دالة البحث الشامل - تجعلها ترجع النتائج فقط ولا تعدّل الحالة الداخلية
  Future<List<Chapter>> performSearch(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _dbHelper.searchChapters(query);
    } catch (e) {
      debugPrint('Error during search: $e');
      return [];
    }
  }

  // دالة لجلب تصنيفات الكتب الفريدة (للمصنفات)
  Future<List<String>> getUniqueCategories() async {
    final books = await _dbHelper
        .getAllBooks(); // أو استخدم قائمة الكتب المحفوظة _books
    return books.map((e) => e.category).toSet().toList();
  }

  // دالة لعرض الكتب حسب التصنيف (نستخدمها في شاشة التصنيفات)
  Future<List<Book>> filterBooksByCategory(String category) async {
    return await _dbHelper.getBooksByCategory(category);
  }

  // Getter للحصول على قائمة الكتب
  List<Book> get books => _books;

  // Getter لحالة التحميل
  bool get isLoading => _isLoading;

  // دالة لجلب جميع الكتب من قاعدة البيانات
  Future<void> fetchAllBooks() async {
    _isLoading = true;
    notifyListeners(); // إعلام الواجهة بأن التحميل بدأ

    try {
      _books = await _dbHelper.getAllBooks();
    } catch (e) {
      // يمكنك هنا إضافة معالجة للأخطاء (Logging)
      debugPrint('Error fetching books: $e');
      _books = [];
    }

    _isLoading = false;
    notifyListeners(); // إعلام الواجهة بانتهاء التحميل وتحديث البيانات
  }

  // دالة لجلب فصول كتاب معين
  Future<List<Chapter>> getChaptersForBook(int bookId) async {
    return await _dbHelper.getChaptersForBook(bookId);
  }

  // سنضيف ميزات أخرى هنا لاحقاً (مثل البحث والتصنيف)
}
