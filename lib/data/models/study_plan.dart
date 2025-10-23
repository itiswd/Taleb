class StudyPlan {
  final int id;
  final String name; // مثل: خطة المبتدئين في الفقه
  final String description;

  // لغة الخطة (اختياري)
  final String category; // مثل: متون، منهج متكامل

  StudyPlan({
    required this.id,
    required this.name,
    this.description = '',
    this.category = 'منهج متكامل',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
    };
  }

  factory StudyPlan.fromMap(Map<String, dynamic> map) {
    return StudyPlan(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
    );
  }
}
