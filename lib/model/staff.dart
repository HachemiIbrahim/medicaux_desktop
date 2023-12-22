class Staff {
  // ignore: public_member_api_docs
  const Staff({
    required this.staffId,
    required this.name,
    required this.role,
  });

  final int staffId;
  final String name;
  final String role;

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
        staffId: int.parse(json['staffId']),
        name: json['name'],
        role: json['role']);
  }
}
