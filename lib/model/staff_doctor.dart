class DoctorStaff {
  const DoctorStaff({
    required this.doctorID,
    required this.staffID,
    required this.assignmentDate,
    required this.doctorName,
    required this.staffName,
  });

  factory DoctorStaff.fromJson(Map<String, dynamic> json) {
    return DoctorStaff(
      doctorID: json['doctorID'] as int,
      staffID: json['staffID'] as int,
      assignmentDate: json['assignmentDate'] as String,
      doctorName: json['doctorName'] as String,
      staffName: json['staffName'] as String,
    );
  }

  final int doctorID;
  final int staffID;
  final String assignmentDate;
  final String doctorName;
  final String staffName;
}
