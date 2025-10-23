import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taleb/data/models/plan_item.dart';
import 'package:taleb/data/models/study_plan.dart';

import '../models/book.dart';
import '../models/chapter.dart';

class DbHelper {
  static Database? _database;
  static const String dbName = 'talib_ilm.db';
  static const int dbVersion = 1;

  // أسماء الجداول
  static const String bookTable = 'books';
  static const String chapterTable = 'chapters';
  // الجداول الجديدة
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
    // تحديد مسار قاعدة البيانات
    String path = join(await getDatabasesPath(), dbName);

    // فتح قاعدة البيانات أو إنشائها إذا لم تكن موجودة
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  // دالة لإنشاء الجداول عند أول تشغيل
  Future<void> _onCreate(Database db, int version) async {
    // ... (جداول الكتب والفصول كما هي) ...

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

  // دالة لإدخال بيانات الكتب والفصول (للتجربة)
  Future<void> _insertInitialData(Database db) async {
    // ... (إدخال الكتاب والفصول كما هو) ...

    // إدخال خطة تجريبية (الخطة ID: 1)
    final testPlan = StudyPlan(
      id: 1,
      name: 'متن التوحيد للمبتدئين',
      description: 'دراسة مبسطة في العقيدة',
      category: 'عقيدة',
    );
    await db.insert(planTable, testPlan.toMap());

    // ربط فصول الكتاب التجريبي (ID: 1) بالخطة
    final planItem1 = PlanItem(
      id: 1,
      planId: 1,
      chapterId: 1,
      chapterTitle: 'مقدمة في التوحيد',
      bookTitle: 'الرسالة التوحيدية',
    );
    final planItem2 = PlanItem(
      id: 2,
      planId: 1,
      chapterId: 2,
      chapterTitle: 'تعريف العقيدة',
      bookTitle: 'الرسالة التوحيدية',
    );

    await db.insert(planItemTable, planItem1.toMap());
    await db.insert(planItemTable, planItem2.toMap());
  }

  // ---------------------------------------------
  // دالة أساسية لجلب كل الكتب
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(bookTable);

    // تحويل القائمة من Map إلى قائمة من كائنات Book
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // دالة أساسية لجلب فصول كتاب معين
  Future<List<Chapter>> getChaptersForBook(int bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      chapterTable,
      where: 'bookId = ?',
      whereArgs: [bookId],
      orderBy: 'id ASC', // الترتيب حسب ID الفصل
    );

    return List.generate(maps.length, (i) => Chapter.fromMap(maps[i]));
  }

  // ---------------------------------------------
  // جلب جميع الخطط
  Future<List<StudyPlan>> getAllStudyPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(planTable);
    return List.generate(maps.length, (i) => StudyPlan.fromMap(maps[i]));
  }

  // جلب عناصر خطة معينة
  Future<List<PlanItem>> getPlanItemsForPlan(int planId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      planItemTable,
      where: 'planId = ?',
      whereArgs: [planId],
      orderBy: 'id ASC',
    );
    return List.generate(maps.length, (i) => PlanItem.fromMap(maps[i]));
  }

  // دالة لحفظ/إنشاء خطة جديدة
  Future<int> insertStudyPlan(StudyPlan plan) async {
    final db = await database;
    return await db.insert(planTable, plan.toMap());
  }

  // دالة لحفظ عناصر خطة
  Future<void> insertPlanItem(PlanItem item) async {
    final db = await database;
    await db.insert(
      planItemTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
