// lib/models/receiver.dart
class Receiver {
  late final String id;
  late final String name;
  late final String model;
  late final bool online;

  Receiver({
    required this.id,
    required this.name,
    required this.model,
    required this.online,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json['_id'],
      name: json['name'],
      model: json['model'], //model  Baby or Doctor
      online: json['online'],
    );
  }
}
