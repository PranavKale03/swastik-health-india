class LabTechData {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String mobile;
  final bool audiometryTest;
  final bool visionTest;
  final bool lungFunctionTest;
  final bool bodyCompositionTest;
  final List<String?> assignedCompanies;

  LabTechData({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.mobile,
    required this.audiometryTest,
    required this.visionTest,
    required this.lungFunctionTest,
    required this.bodyCompositionTest,
    required this.assignedCompanies,
  });

  factory LabTechData.fromJson(Map<String, dynamic> json) {
    return LabTechData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      mobile: json['mobile'],
      audiometryTest: json['audiometry_test'],
      visionTest: json['vision_test'],
      lungFunctionTest: json['lungfunction_test'],
      bodyCompositionTest: json['body_composition_test'],
      assignedCompanies: List<String?>.from(json['assigned_companies']),
    );
  }
}
