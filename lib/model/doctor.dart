class Doctor {
  // ignore: public_member_api_docs
  const Doctor({
    required this.doctorId,
    required this.name,
    required this.speciality,
  });

  final int doctorId;
  final String name;
  final String speciality;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        doctorId: int.parse(json['doctorId']),
        name: json['name'],
        speciality: json['speciality']);
  }
}
