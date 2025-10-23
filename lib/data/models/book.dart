class Book {
  final int id;
  final String title;
  final String author;
  final String category; // مثل: فقه، عقيدة، حديث

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
  });

  // دالة لتحويل الكائن إلى Map (لإدخاله في قاعدة البيانات)
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'category': category};
  }

  // دالة لإنشاء كائن من Map (لقراءته من قاعدة البيانات)
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'] as String,
      author: map['author'] as String,
      category: map['category'] as String,
    );
  }
}
