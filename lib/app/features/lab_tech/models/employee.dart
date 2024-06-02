class EmployeesModel {
  final String? name;
  final String? age;
  final String? email;
  final String? gender;

  EmployeesModel({
    this.name,
    this.age,
    this.email,
    this.gender,
  });

  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    return EmployeesModel(
      name: json['name'],
      age: json['age'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}