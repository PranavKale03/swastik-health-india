class AdminData {
  final String name;
  final String id;
  final String email;
  final String photoUrl;

  AdminData({
    required this.name,
    required this.id,
    required this.email,
    required this.photoUrl,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      name: json['name'],
      id: json['_id'],
      email: json['email'],
      photoUrl: json['mobile'],
    );
  }
}
