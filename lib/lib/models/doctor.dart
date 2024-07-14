// class Doctor {
//   final String firstname;
//   final String lastname;
//   final String phone;
//   final String specialization;
//   final String degree;
//   final String workPlace;
//   final String email;
//   final String password;
//   final String id;

//   Doctor({
//     required this.firstname,
//     required this.lastname,
//     required this.phone,
//     required this.specialization,
//     required this.degree,
//     required this.workPlace,
//     required this.email,
//     required this.password,
//     required this.id,
//   });

//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       firstname: json['firstName'] as String,
//       lastname: json['lastName'] as String,
//       phone: json['phone'] as String,
//       specialization: json['specialization'] as String,
//       degree: json['degree'] as String,
//       workPlace: json['workPlace'] as String,
//       email: json['email'] as String,
//       password: json['password'] as String,
//       id: json['_id'] as String,
//     );
//   }
// }

class Doctor {
  final String firstname;
  final String lastname;
  final String phone;
  final String specialization;
  final String degree;
  final String workPlace;
  final String email;
  final String password;
  final String id;
  final String token;
  final bool? online;

  Doctor({
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.specialization,
    required this.degree,
    required this.workPlace,
    required this.email,
    required this.password,
    required this.id,
    required this.token,
    this.online,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      firstname: json['firstName'] as String,
      lastname: json['lastName'] as String,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String,
      degree: json['degree'] as String,
      workPlace: json['workPlace'] as String,
      email: json['email'] as String,
      password: json['password'] ?? '', /////*******edit */
      id: json['_id'] as String,
      token: json['token'] as String,
      online: json['online'] ?? false,
    );
  }
}
