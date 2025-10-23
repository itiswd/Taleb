// lib/data/database/db_helper.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';

class DbHelper {
  static Database? _database;
  static const String dbName = 'talib_ilm.db';
  static const int dbVersion = 8; // ⬅️ الإصدار الجديد لضمان إعادة البناء

  // أسماء الجداول
  static const String bookTable = 'books';
  // ❌ حذف: chapterTable, planTable, planItemTable

  // دالة للحصول على نسخة من قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  // دالة لإنشاء الجداول (جدول الكتب فقط)
  Future<void> _onCreate(Database db, int version) async {
    // 1. جدول الكتب (books)
    await db.execute('''
      CREATE TABLE $bookTable (
        id INTEGER PRIMARY KEY,
        title TEXT,
        author TEXT,
        category TEXT,
        pdfPath TEXT NOT NULL
      )
    ''');

    // ❌ حذف: إنشاء جداول الفصول والخطط

    await _insertInitialData(db);
  }

  // دالة لإدخال بيانات الكتب من ملف JSON
  Future<void> _insertInitialData(Database db) async {
    debugPrint('--- بدء إدخال بيانات PDF الأولية من JSON ---');

    try {
      final String response = await rootBundle.loadString(
        'assets/pdfs/books_data.json',
      );
      final List<dynamic> booksData = json.decode(response);

      for (var bookMap in booksData) {
        if (bookMap == null || bookMap.isEmpty) continue;

        final bookId = bookMap['id'] as int?;
        if (bookId == null ||
            bookMap['title'] == null ||
            bookMap['pdfPath'] == null) {
          debugPrint('تنبيه: تم تخطي كتاب بيانات PDF غير مكتملة.');
          continue;
        }

        await db.insert(bookTable, {
          'id': bookId,
          'title': bookMap['title'],
          'author': bookMap['author'] ?? 'مجهول',
          'category': bookMap['category'] ?? 'عام',
          'pdfPath': bookMap['pdfPath'],
        });
        debugPrint('تم إدخال الكتاب: ${bookMap['title']}');
      }
    } catch (e) {
      debugPrint('خطأ فادح في إدخال البيانات الأولية (تحقق من JSON): $e');
    }
  }

  // ---------------------------------------------
  // دوال جلب البيانات (الأساسية)
  // ---------------------------------------------

  // دالة لجلب كل الكتب
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(bookTable);
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  // دالة لجلب الكتب حسب التصنيف (المصنفات)
  Future<List<Book>> getBooksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      bookTable,
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }
}
