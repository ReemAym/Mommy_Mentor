class Vaccine {
  final String vaccinename;
  final String administrationMethod;
  final String dosage;
  final List<String> diseases;
  final int age;
  final String id;

  Vaccine({
    required this.vaccinename,
    required this.administrationMethod,
    required this.dosage,
    required this.diseases,
    required this.age,
    required this.id
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      age: json['age']??'',
      id: json['_id'] ??'' ,
      vaccinename: json['vaccine'] ?? '',
      administrationMethod: json['adminstrationMethod'] ?? '',
      dosage: json['dosage'] ?? '',
      diseases: json['diseases'] != null
          ? List<String>.from(json['diseases'])
          : <String>[],
    );
  }
}
