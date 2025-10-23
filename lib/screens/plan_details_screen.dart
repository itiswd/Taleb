import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/plan_item.dart';
import '../data/models/study_plan.dart';
import '../providers/plan_provider.dart';

class PlanDetailsScreen extends StatelessWidget {
  final StudyPlan plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    // نستخدم FutureBuilder لجلب بنود الخطة، و Consumer لتحديث حالة الإنجاز
    return Scaffold(
      appBar: AppBar(title: Text(plan.name), centerTitle: true),
      body: FutureBuilder<List<PlanItem>>(
        future: Provider.of<PlanProvider>(
          context,
          listen: false,
        ).getItemsForPlan(plan.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('هذه الخطة لا تحتوي على بنود دراسية.'),
            );
          }

          final items = snapshot.data!;
          // حساب نسبة الإنجاز
          final completedCount = items.where((item) => item.isCompleted).length;
          final totalCount = items.length;
          final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // شريط التقدم
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التقدم: ${(progress * 100).toStringAsFixed(0)}% ($completedCount/$totalCount)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.teal,
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Consumer<PlanProvider>(
                  builder: (context, planProvider, child) {
                    // نستخدم items الأصلية (المجلوبة من FutureBuilder)
                    // ونعتمد على PlanProvider لتحديث حالة isCompleted
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.chapterTitle),
                          subtitle: Text('الكتاب: ${item.bookTitle}'),
                          trailing: Checkbox(
                            value: item.isCompleted,
                            onChanged: (bool? newValue) {
                              if (newValue != null) {
                                // تحديث حالة الإنجاز في قاعدة البيانات و الـ Provider
                                planProvider.toggleItemCompletion(item);
                                // يجب إعادة تحميل شريط التقدم
                                (context as Element).markNeedsBuild();
                              }
                            },
                          ),
                          onTap: () {
                            // هنا يمكنك ربطها بشاشة القراءة لفتح الفصل مباشرة
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'سيتم فتح فصل: ${item.chapterTitle}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
