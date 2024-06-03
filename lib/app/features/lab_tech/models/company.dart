class CompanyData {
  final String id;
  final String name;
  final String email;
  final String address;
  final String mobile;
  final bool audiometryTest;
  final bool visionTest;
  final bool lungFunctionTest;
  final bool bodyCompositionTest;

  CompanyData({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.mobile,
    required this.audiometryTest,
    required this.visionTest,
    required this.lungFunctionTest,
    required this.bodyCompositionTest,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      mobile: json['mobile'],
      audiometryTest: json['audiometry_test'] ?? false,
      visionTest: json['vision_test'] ?? false,
      lungFunctionTest: json['lungfunction_test'] ?? false,
      bodyCompositionTest: json['body_composition_test'] ?? false,
    );
  }
}