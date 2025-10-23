import 'package:flutter/material.dart';

import '../data/database/db_helper.dart';
import '../data/models/book.dart';
import '../data/models/chapter.dart';

class BookProvider with ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  List<Book> _books = [];
  bool _isLoading = true;

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
