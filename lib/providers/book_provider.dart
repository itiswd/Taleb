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
    // 💡 تم حذف fetchBooks(); لمنع خطأ setState() during build
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
      // 💡 لا تستدعي fetchBooks() هنا، بل اعتمد على main.dart لتحميلها مرة واحدة
      // في هذه الحالة، سنعتمد على أن main.dart قام بالتحميل.
      // إذا لم يكن التحميل قد اكتمل بعد (رغم محاولة main.dart)،
      // سنعيد المحاولة هنا أو ننتظر حتى تكتمل قائمة الكتب.
      // لأغراض التصحيح: سنقوم بالجلب مباشرة من قاعدة البيانات إذا كانت القائمة فارغة
      _books = await _dbHelper.getAllBooks();
    }

    // فلترة وإزالة المكرر
    return _books.map((e) => e.category).toSet().toList();
  }

  // دالة لعرض الكتب حسب التصنيف
  Future<List<Book>> filterBooksByCategory(String category) async {
    return await _dbHelper.getBooksByCategory(category);
  }
}
