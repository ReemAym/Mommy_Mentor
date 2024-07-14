class Advice {
  final String title;
  final String content;
  final int age;
  final String id;

  Advice({required this.title, required this.content, required this.age, required this.id});

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      age: json['age'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'age': age,
      'id': id,
    };
  }
}
