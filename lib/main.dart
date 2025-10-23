// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/book_provider.dart';
import 'screens/library_screen.dart';

void main() {
  // التأكد من تهيئة Flutter قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider(), // ⬅️ فقط BookProvider
      child: const Taleb(),
    ),
  );
}

class Taleb extends StatelessWidget {
  const Taleb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مكتبة طالب العلم PDF',
      debugShowCheckedModeBanner: false,
      // دعم اللغة العربية
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
      ],
      locale: const Locale('ar', ''),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(centerTitle: true),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Cairo'), // يمكنك تغيير الخط هنا
          bodyMedium: TextStyle(fontFamily: 'Cairo'),
        ),
      ),
      home: const LibraryScreen(), // ⬅️ شاشة المكتبة هي الشاشة الرئيسية
    );
  }
}
