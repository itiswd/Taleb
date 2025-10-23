import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text('Category'),
    );
  }
}
