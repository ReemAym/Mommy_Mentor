class Appointment {
  final String name;
  final String location;
  final double fees;
  final String time;
  final String doctorId;

  Appointment({
    required this.name,
    required this.location,
    required this.fees,
    required this.time,
    required this.doctorId, 
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      name: json['doctor']['firstName'] + ' ' + json['doctor']['lastName'], // Assuming 'doctorName' is the correct field
      location: json['address'],
      fees: json['fee'].toDouble(),
      time: json['date'], 
      doctorId: json['doctor']['_id'],
      // Make sure this matches your JSON structure
    );
  }
}