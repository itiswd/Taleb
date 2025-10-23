import 'package:flutter/material.dart';

class BookReaderScreen extends StatelessWidget {
  const BookReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: const Center(child: Text('Book Reader')),
    );
  }
}
