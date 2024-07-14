class VaccineCenter {
  final String name;
  final String address;
  final String phone;

  VaccineCenter({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory VaccineCenter.fromJson(Map<String, dynamic> json) {
    return VaccineCenter(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
