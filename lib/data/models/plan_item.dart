class PlanItem {
  final int id;
  final int planId; // يربط البند بالخطة
  final int chapterId; // يربط البند بفصل الكتاب
  final String chapterTitle; // لتسهيل العرض
  final String bookTitle; // لتسهيل العرض
  bool isCompleted; // حالة الإنجاز (تم قراءته أم لا)

  PlanItem({
    required this.id,
    required this.planId,
    required this.chapterId,
    required this.chapterTitle,
    required this.bookTitle,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planId': planId,
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'bookTitle': bookTitle,
      'isCompleted': isCompleted ? 1 : 0, // SQLite لا يدعم Boolean مباشرة
    };
  }

  factory PlanItem.fromMap(Map<String, dynamic> map) {
    return PlanItem(
      id: map['id'] as int,
      planId: map['planId'] as int,
      chapterId: map['chapterId'] as int,
      chapterTitle: map['chapterTitle'] as String,
      bookTitle: map['bookTitle'] as String,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
