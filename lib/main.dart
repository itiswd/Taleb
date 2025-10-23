import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taleb/providers/book_provider.dart';
import 'package:taleb/providers/plan_provider.dart';
import 'package:taleb/screens/main_screen.dart';

// الدالة الرئيسية لتشغيل التطبيق
void main() {
  runApp(
    MultiProvider(
      providers: [
        // جلب الكتب عند البداية
        ChangeNotifierProvider(create: (_) => BookProvider()..fetchAllBooks()),
        // جلب الخطط عند البداية
        ChangeNotifierProvider(create: (_) => PlanProvider()..fetchAllPlans()),
      ],
      child: const Taleb(),
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
