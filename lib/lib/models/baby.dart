class Baby {
  final String id;
  final String firstname;
  final String lastname;
  final DateTime birthdate;
  final String gender;
  final List<MonthlyMeasurement>? measurements;

  Baby({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.birthdate,
    required this.gender,
    this.measurements,
  });

  factory   Baby.fromJson(Map<String, dynamic> json) {
    return Baby(
      id: json['_id'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      gender: json['gender'] as String,
      measurements: (json['measurements'] as List<dynamic>).map((measurement) => MonthlyMeasurement.fromJson(measurement)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'birthdate': birthdate.toIso8601String(),
      'gender': gender,
      'measurements': measurements?.map((measurement) => measurement.toJson()).toList(),
    };
  }
}

class MonthlyMeasurement {
  final int month;
  final double height;
  final double weight;
  final double headCircumference;

  MonthlyMeasurement({
    required this.month,
    required this.height,
    required this.weight,
    required this.headCircumference,
  });

  factory MonthlyMeasurement.fromJson(Map<String, dynamic> json) {
    return MonthlyMeasurement(
      month:(json['month'] as num).toInt(),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      headCircumference: (json['headCircumference'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'height': height,
      'weight': weight,
      'headCircumference': headCircumference,
    };
  }
}
