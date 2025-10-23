import 'package:flutter/material.dart';

class StudyPlansScreen extends StatelessWidget {
  const StudyPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Plans')),
      body: const Center(child: Text('Study Plans')),
    );
  }
}
