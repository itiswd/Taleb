import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';
import '../models/chapter.dart';

class DbHelper {
  static Database? _database;
  static const String dbName = 'talib_ilm.db';
  static const int dbVersion = 1;

  // أسماء الجداول
  static const String bookTable = 'books';
  static const String chapterTable = 'chapters';

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

    // **ملاحظة:** هنا يمكنك إضافة بيانات الكتب الافتراضية
    await _insertInitialData(db);
  }

  // دالة لإدخال بيانات الكتب والفصول (للتجربة)
  Future<void> _insertInitialData(Database db) async {
    // إدخال كتاب تجريبي
    final testBook = Book(
      id: 1,
      title: 'الرسالة التوحيدية',
      author: 'أحمد',
      category: 'عقيدة',
    );
    await db.insert(bookTable, testBook.toMap());

    // إدخال فصول تجريبية
    final chapter1 = Chapter(
      id: 1,
      bookId: 1,
      title: 'مقدمة في التوحيد',
      content: 'نص الفصل الأول الطويل هنا...',
    );
    final chapter2 = Chapter(
      id: 2,
      bookId: 1,
      title: 'تعريف العقيدة',
      content: 'نص الفصل الثاني الأطول هنا...',
    );

    await db.insert(chapterTable, chapter1.toMap());
    await db.insert(chapterTable, chapter2.toMap());
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
}
