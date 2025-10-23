// في ملف lib/screens/study_plans_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plan_provider.dart';
import 'plan_details_screen.dart'; // سننشئها في الخطوة 7.7

class StudyPlansScreen extends StatelessWidget {
  const StudyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخطط الدراسية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // **هنا سننتقل إلى شاشة إنشاء خطة جديدة لاحقاً**
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ميزة إنشاء خطة جديدة قادمة!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<PlanProvider>(
        builder: (context, planProvider, child) {
          if (planProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (planProvider.plans.isEmpty) {
            return const Center(child: Text('لا توجد خطط دراسية حالياً.'));
          }

          return ListView.builder(
            itemCount: planProvider.plans.length,
            itemBuilder: (context, index) {
              final plan = planProvider.plans[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.school, color: Colors.teal),
                  title: Text(
                    plan.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(plan.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // الانتقال إلى تفاصيل الخطة
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanDetailsScreen(plan: plan),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
