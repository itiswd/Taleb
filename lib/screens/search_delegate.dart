import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taleb/data/models/chapter.dart';

import '../providers/book_provider.dart';
import 'chapter_reader_screen.dart'; // لفتح الفصل بعد البحث

// يجب تمرير اسم الكتاب لأن الفصل (Chapter) لا يحمل اسم الكتاب
// سنقوم بتعديل بسيط هنا: يجب أن نحفظ اسم الكتاب مع الفصل عند البحث.
// لكن لتبسيط العملية الآن، سنفترض أننا سنحصل على اسم الكتاب بشكل غير مباشر،
// أو سنقوم بتمرير اسم كتاب افتراضي.

class ChapterSearchDelegate extends SearchDelegate<String> {
  // تصميم واجهة البحث (تبحث تلقائياً عند الكتابة)

  @override
  String? get searchFieldLabel => 'البحث في محتوى و عناوين الكتب...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    // التأكد من أن الثيم يدعم الاتجاه RTL داخل نافذة البحث
    return Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.copyWith(
        titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  // الأفعال (Actions) على يمين شريط البحث (مسح النص)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  // الأفعال (Leading) على يسار شريط البحث (العودة)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  // اقتراحات البحث (تظهر عند عدم وجود نص أو نص قصير)
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('اكتب كلمة للبحث في المكتبة...'));
  }

  // في ملف lib/screens/search_delegate.dart

  @override
  Widget buildResults(BuildContext context) {
    // الحصول على Provider بدون استماع للتغييرات
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    // استخدام FutureBuilder لتشغيل دالة البحث غير المتزامنة
    return FutureBuilder<List<Chapter>>(
      // هنا يتم استدعاء دالة البحث مباشرة
      future: bookProvider.performSearch(query),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // حالة التحميل
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // حالة وجود خطأ
          return Center(child: Text('حدث خطأ أثناء البحث: ${snapshot.error}'));
        }

        // النتائج النهائية
        final List<Chapter> results = snapshot.data ?? [];

        if (results.isEmpty) {
          return Center(child: Text('لا توجد نتائج مطابقة لـ: "$query"'));
        }

        // عرض النتائج
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final chapter = results[index];

            return ListTile(
              leading: const Icon(Icons.search, color: Colors.grey),
              title: Text(
                chapter.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'الكتاب ID: ${chapter.bookId} | جزء من المحتوى: ${chapter.content.substring(0, chapter.content.length > 50 ? 50 : chapter.content.length)}...',
              ),
              onTap: () {
                // الانتقال إلى شاشة القراءة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChapterReaderScreen(
                      chapter: chapter,
                      bookTitle: 'نتيجة بحث (كتاب ${chapter.bookId})',
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
