// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/book_provider.dart';
import 'screens/library_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final bookProvider = BookProvider();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    bookProvider.fetchBooks();
  });

  runApp(
    ChangeNotifierProvider.value(
      value: bookProvider,
      child: const TalibAlmApp(),
    ),
  );
}

class TalibAlmApp extends StatelessWidget {
  const TalibAlmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'طالب',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', '')],
      locale: const Locale('ar', ''),

      // 💡 التعديلات الرئيسية على الثيم
      theme: ThemeData(
        // الألوان
        primaryColor: const Color(0xFF004D40), // أخضر داكن (Dark Teal)
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.teal, // اللون الأساسي
            ).copyWith(
              secondary: const Color(0xFF4DB6AC), // لون التمييز
              surface: const Color(0xFFF9F9F9), // خلفية فاتحة ومريحة
            ),

        // الخطوط (Cairo هو الخط الافتراضي لكل النصوص)
        fontFamily: 'Cairo',
        textTheme: const TextTheme(
          // ضبط الأحجام الافتراضية للخطوط
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          bodyMedium: TextStyle(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 18),
        ),

        // شريط التطبيق (AppBar)
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: const Color(0xFF004D40), // لون شريط التطبيق
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        // الأزرار المرتفعة (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF004D40), // لون الزر
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // البطاقات (Cards)
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: const LibraryScreen(),
    );
  }
}
