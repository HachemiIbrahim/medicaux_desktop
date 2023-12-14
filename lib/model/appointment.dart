class Appointment {
  const Appointment({
    required this.appointmentId,
    required this.patientName,
    required this.doctorName,
    required this.appointment_date,
  });

  final int appointmentId;
  final String patientName;
  final String doctorName;
  final String appointment_date;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: int.parse(json['appointmentId']),
      patientName: json['patientName'],
      doctorName: json['doctorName'],
      appointment_date: json['appointment_date'],
    );
  }
}
