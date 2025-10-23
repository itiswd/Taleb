import 'package:flutter/material.dart';

import '../data/database/db_helper.dart';
import '../data/models/plan_item.dart';
import '../data/models/study_plan.dart';

class PlanProvider with ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  List<StudyPlan> _plans = [];
  bool _isLoading = true;

  List<StudyPlan> get plans => _plans;
  bool get isLoading => _isLoading;

  Future<void> fetchAllPlans() async {
    _isLoading = true;
    notifyListeners();

    try {
      _plans = await _dbHelper.getAllStudyPlans();
    } catch (e) {
      debugPrint('Error fetching study plans: $e');
      _plans = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<PlanItem>> getItemsForPlan(int planId) async {
    return await _dbHelper.getItemsForPlan(planId);
  }

  // تحديث حالة إنجاز بند
  Future<void> toggleItemCompletion(PlanItem item) async {
    item.isCompleted = !item.isCompleted;
    await _dbHelper.updatePlanItemCompletion(item.id, item.isCompleted);
    // قد لا نحتاج notifyListeners هنا إذا كنا سنعيد جلب البيانات في شاشة الخطة، لكن من المفيد إضافتها
    notifyListeners();
  }
}
