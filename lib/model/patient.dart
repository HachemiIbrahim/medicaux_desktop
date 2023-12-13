class Patient {
  const Patient(
      {required this.patientId,
      required this.name,
      required this.age,
      required this.phoneNumber});

  final int patientId;
  final String name;
  final int age;
  final String phoneNumber;

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: int.parse(json['patientId']),
      name: json['name'],
      age: int.parse(json['age']),
      phoneNumber: json['phone_number'],
    );
  }
}
