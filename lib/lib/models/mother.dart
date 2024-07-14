import 'baby.dart';

class Mother {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final List<Baby>? babies;
  final String token;
  final int currentIndex;
  final bool? online;

  Mother({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.currentIndex,
    this.babies,
    required this.token,
    this.online,
  });

  factory Mother.fromJson(Map<String, dynamic> json) {
    return Mother(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        address: json['address'] ?? '',
        babies: (json['babies'] as List<dynamic>)
            .map((baby) => Baby.fromJson(baby))
            .toList(),
        token: json['token']??'',
        currentIndex: json['currentIndex'] ?? 0,
        online: json['online']??false);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'babies': babies?.map((measurement) => measurement.toJson()).toList(),
      'token': token,
      'currentIndex': currentIndex,
      'online': online,

    };
  }
}
