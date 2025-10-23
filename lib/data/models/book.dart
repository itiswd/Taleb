// lib/data/models/book.dart

class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final String pdfPath; // مسار الـ PDF داخل مجلد assets

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.pdfPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'pdfPath': pdfPath,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'] as String,
      author: map['author'] as String,
      category: map['category'] as String,
      pdfPath: map['pdfPath'] as String,
    );
  }
}
