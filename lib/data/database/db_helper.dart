// lib/data/database/db_helper.dart

import 'dart:convert';

import 'package:flutter/foundation.dart'; // لاستخدام debugPrint
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import '../models/plan_item.dart';
import '../models/study_plan.dart';

class DbHelper {
  static Database? _database;
  static const String dbName = 'talib_ilm.db';
  static const int dbVersion = 4; // 💡 تم تحديث الإصدار إلى 3

  // أسماء الجداول
  static const String bookTable = 'books';
  static const String chapterTable = 'chapters';
  static const String planTable = 'study_plans';
  static const String planItemTable = 'plan_items';

  // دالة للحصول على نسخة من قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // دالة لتهيئة (إنشاء) قاعدة البيانات
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      // يمكن إضافة onUpgrade هنا للتعامل مع التحديثات المستقبلية
      // onUpgrade: _onUpgrade,
    );
  }

  // دالة لإنشاء الجداول عند أول تشغيل (أو عند زيادة dbVersion)
  Future<void> _onCreate(Database db, int version) async {
    // 1. جدول الكتب (books)
    await db.execute('''
      CREATE TABLE $bookTable (
        id INTEGER PRIMARY KEY,
        title TEXT,
        author TEXT,
        category TEXT
      )
    ''');

    // 2. جدول الفصول (chapters)
    await db.execute('''
      CREATE TABLE $chapterTable (
        id INTEGER PRIMARY KEY,
        bookId INTEGER,
        title TEXT,
        content TEXT,
        FOREIGN KEY (bookId) REFERENCES $bookTable (id)
      )
    ''');

    // 3. جدول الخطط (study_plans)
    await db.execute('''
      CREATE TABLE $planTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        category TEXT
      )
    ''');

    // 4. جدول عناصر الخطة (plan_items)
    await db.execute('''
      CREATE TABLE $planItemTable (
        id INTEGER PRIMARY KEY,
        planId INTEGER,
        chapterId INTEGER,
        chapterTitle TEXT, 
        bookTitle TEXT,
        isCompleted INTEGER, 
        FOREIGN KEY (planId) REFERENCES $planTable (id)
      )
    ''');

    await _insertInitialData(db);
  }

  // دالة لإدخال بيانات الكتب والفصول من ملف JSON
  Future<void> _insertInitialData(Database db) async {
    debugPrint('--- بدء إدخال البيانات الأولية من JSON ---');

    try {
      final String response = await rootBundle.loadString('assets/books.json');
      final List<dynamic> booksData = json.decode(response);
      debugPrint('عدد الكتب المحملة: ${booksData.length}');

      // التكرار على كل كتاب وفصل لإدخالهما
      for (var bookMap in booksData) {
        if (bookMap == null || bookMap.isEmpty) continue; // تخطي إذا كان فارغاً

        final bookId = bookMap['id'] as int?;
        if (bookId == null ||
            bookMap['title'] == null ||
            bookMap['author'] == null) {
          debugPrint(
            'تنبيه: تم تخطي كتاب بياناته غير مكتملة (ID, Title, or Author).',
          );
          continue;
        }

        // إدخال الكتاب
        await db.insert(bookTable, {
          'id': bookId,
          'title': bookMap['title'],
          'author': bookMap['author'],
          'category': bookMap['category'] ?? 'عام',
        });
        debugPrint('تم إدخال الكتاب: ${bookMap['title']}');

        // إدخال الفصول
        final List<dynamic>? chapters = bookMap['chapters'];
        if (chapters != null && chapters.isNotEmpty) {
          for (var chapterMap in chapters) {
            if (chapterMap == null || chapterMap.isEmpty) continue;

            final chapterId = chapterMap['id'] as int?;
            if (chapterId == null ||
                chapterMap['title'] == null ||
                chapterMap['content'] == null) {
              debugPrint('تنبيه: تم تخطي فصل بياناته غير مكتملة.');
              continue;
            }

            await db.insert(chapterTable, {
              'id': chapterId,
              'bookId': bookId,
              'title': chapterMap['title'],
              'content': chapterMap['content'],
            });
          }
        }
      }

      // ---------------- خطة تجريبية (للتأكد من عمل الخطط) ----------------
      const int planId = 10;
      await db.insert(planTable, {
        'id': planId,
        'name': 'خطة عقيدة ولغة (تلقائية)',
        'description': 'دراسة متون التوحيد والأجرومية من JSON',
        'category': 'منهج متكامل',
      });

      // ربط فصل من كتاب التوحيد بالخطة (نفترض ID=1 و Chapter ID=1 موجودين)
      await db.insert(planItemTable, {
        'id': 101,
        'planId': planId,
        'chapterId': 1,
        'chapterTitle': 'الباب الأول: أهمية التوحيد',
        'bookTitle': 'كتاب التوحيد للمبتدئين',
        'isCompleted': 0,
      });
      // -----------------------------------------------------------------

      debugPrint('--- انتهاء إدخال البيانات الأولية بنجاح ---');
    } catch (e) {
      debugPrint('خطأ فادح في إدخال البيانات الأولية (تحقق من JSON): $e');
      // إذا حدث خطأ هنا، قد لا يتمكن التطبيق من العمل
    }
  }

  // ---------------------------------------------
  // دوال جلب البيانات
  // ---------------------------------------------

  // دالة أساسية لجلب كل الكتب
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(bookTable);
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  // دالة أساسية لجلب فصول كتاب معين
  Future<List<Chapter>> getChaptersForBook(int bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      chapterTable,
      where: 'bookId = ?',
      whereArgs: [bookId],
      orderBy: 'id ASC',
    );
    return List.generate(maps.length, (i) => Chapter.fromMap(maps[i]));
  }

  // دالة البحث الشامل
  Future<List<Chapter>> searchChapters(String query) async {
    final db = await database;
    final safeQuery = '%$query%';

    final List<Map<String, dynamic>> maps = await db.query(
      chapterTable,
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: [safeQuery, safeQuery],
      orderBy: 'bookId ASC, id ASC',
    );

    return List.generate(maps.length, (i) => Chapter.fromMap(maps[i]));
  }

  // دالة لجلب الكتب حسب التصنيف
  Future<List<Book>> getBooksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      bookTable,
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  // ---------------- خطط طالب العلم ----------------
  // جلب جميع الخطط
  Future<List<StudyPlan>> getAllStudyPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(planTable);
    return List.generate(maps.length, (i) => StudyPlan.fromMap(maps[i]));
  }

  // جلب عناصر خطة معينة
  Future<List<PlanItem>> getItemsForPlan(int planId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      planItemTable,
      where: 'planId = ?',
      whereArgs: [planId],
      orderBy: 'id ASC',
    );
    return List.generate(maps.length, (i) => PlanItem.fromMap(maps[i]));
  }

  // دالة لتحديث حالة إنجاز بند معين في الخطة
  Future<void> updatePlanItemCompletion(
    int planItemId,
    bool isCompleted,
  ) async {
    final db = await database;
    await db.update(
      planItemTable,
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [planItemId],
    );
  }
}
