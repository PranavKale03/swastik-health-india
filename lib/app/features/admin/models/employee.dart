class EmployeesModel {
  final String? name, id;
  final String? age;
  final String? email;
  final String? gender;

  EmployeesModel({
    this.id, 
    this.name,
    this.age,
    this.email,
    this.gender,
  });

  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    return EmployeesModel(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}