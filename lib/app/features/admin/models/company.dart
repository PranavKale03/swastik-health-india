class CompanyData {
  final String name;
  final String email;
  final String id;

  CompanyData({
    required this.name,
    required this.email,
    required this.id,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      name: json['name'],
      email: json['email']??"",
      id: json['_id'],

    );
  }
}
