import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Plan Title'),
        subtitle: const Text('Description'),
      ),
    );
  }
}
