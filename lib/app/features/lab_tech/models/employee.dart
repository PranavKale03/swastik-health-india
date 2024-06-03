class EmployeesModel {
  final String? id;
  final String? name;
  final String? age;
  final String? email;
  final String? gender;
  final bool audiometryTest;
  final bool visionTest;
  final bool lungFunctionTest;
  final bool bodyCompositionTest;

  EmployeesModel({
    this.id,
    this.name,
    this.age,
    this.email,
    this.gender,
    this.audiometryTest = false,
    this.visionTest = false,
    this.lungFunctionTest = false,
    this.bodyCompositionTest = false,
  });

  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    return EmployeesModel(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      email: json['email'],
      gender: json['gender'],
      audiometryTest: json['audiometry_test'] ?? false,
      visionTest: json['vision_test'] ?? false,
      lungFunctionTest: json['lungfunction_test'] ?? false,
      bodyCompositionTest: json['body_composition_test'] ?? false,
    );
  }
}
