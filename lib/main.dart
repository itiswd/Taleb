import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taleb/providers/book_provider.dart';

// الدالة الرئيسية لتشغيل التطبيق
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()..fetchAllBooks()),
        // يمكن إضافة Provider للـ Study Plans هنا لاحقاً
      ],
      child: Taleb(),
    ),
  );
}

// الـ Widget الأساسي للتطبيق
class Taleb extends StatelessWidget {
  const Taleb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 1. إعداد الثيم (Theme) - لون أساسي ومريح للعين
      title: 'تطبيق طالب العلم',
      theme: ThemeData(
        primarySwatch: Colors.teal, // لون إسلامي مريح
        // تمكين اللغة العربية كاتجاه افتراضي
        fontFamily: 'Cairo', // يمكنك اختيار خط عربي مناسب لاحقاً
        textTheme: const TextTheme(
          // إعدادات الخطوط
        ),
      ),
      // إعداد الاتجاه الافتراضي ليكون من اليمين لليسار (RTL)
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      // الصفحة الرئيسية (سننشئها في الخطوة التالية)
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Placeholder للصفحة الرئيسية (ستكون نقطة البداية)
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Consumer للاستماع للتغييرات في BookProvider
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('مكتبة طالب العلم'),
            centerTitle: true,
            // سنضيف هنا أيقونة للبحث والتصنيفات لاحقاً
          ),
          body: bookProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookProvider.books.isEmpty
              ? const Center(child: Text('لا توجد كتب في المكتبة.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: bookProvider.books.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.books[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.menu_book,
                          color: Colors.teal,
                        ),
                        title: Text(
                          book.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'المؤلف: ${book.author} | التصنيف: ${book.category}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // **هنا سننتقل إلى شاشة عرض فصول الكتاب (الخطوة القادمة)**
                          debugPrint('Clicked on: ${book.title}');
                          // مثال:
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)));
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
