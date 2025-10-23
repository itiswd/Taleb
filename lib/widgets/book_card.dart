import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Book Title'),
        subtitle: const Text('Author'),
      ),
    );
  }
}
