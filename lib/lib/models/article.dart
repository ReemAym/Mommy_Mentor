class Article {
  final String title;
  final String category;
  final String content;
  final DateTime date;
  final String token;
  final String id;
  Article({
    required this.title,
    required this.category,
    required this.content,
    DateTime? date,
    this.token = '',
    required this.id,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'content': content,
      'date': date.toIso8601String(),
      'token': token,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'],
      title: json['title'],
      category: json['category'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }
}
