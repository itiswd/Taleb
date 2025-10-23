import 'package:flutter/material.dart';

class BooksListScreen extends StatelessWidget {
  const BooksListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: const Center(child: Text('Books List')),
    );
  }
}
