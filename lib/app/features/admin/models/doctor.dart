class DoctorData {
  final String id;
  final String name;
  final String email;
  final String? password; // Make password nullable
  final String? address; // Make address nullable
  final String mobile;
  final List<String?> assignedCompanies;

  DoctorData({
    required this.id,
    required this.name,
    required this.email,
    this.password, // Nullable
    this.address, // Nullable
    required this.mobile,
    required this.assignedCompanies,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'], // Nullable
      address: json['address'], // Nullable
      mobile: json['mobile'],
      assignedCompanies: (json['assigned_companies'] as List<dynamic>)
          .map((item) => item as String?)
          .toList(),
    );
  }
}
