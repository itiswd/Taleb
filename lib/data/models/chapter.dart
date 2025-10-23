class Chapter {
  final int id;
  final int bookId; // المفتاح الأجنبي: يربط الفصل بكتاب معين
  final String title;
  final String content; // نص الفصل/الدرس

  Chapter({
    required this.id,
    required this.bookId,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'bookId': bookId, 'title': title, 'content': content};
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] as int,
      bookId: map['bookId'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }
}
