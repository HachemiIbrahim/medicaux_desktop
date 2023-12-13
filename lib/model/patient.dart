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
      patientId: int.tryParse(json['patientId']) ?? 0,
      name: json['name'],
      age: int.tryParse(json['age']) ?? 0,
      phoneNumber: json['phoneNumber'],
    );
  }
}
