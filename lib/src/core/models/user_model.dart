class UserModel {
  String? userId;
  String? department;

  String? name;
  String? role;
  String? email;
  String? mainSignature;

  UserModel(
    this.userId,
    this.department,
    this.name,
    this.role,
    this.email,
    this.mainSignature,
  );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'department': department,
        'name': name,
        'role': role,
        'email': email,
        'mainSignature': mainSignature,
      };

  UserModel.fromJson(Map<String, dynamic>? json) {
    userId = json!['userId'];
    department = json['department'];

    name = json['name'];
    role = json['role'];
    email = json['email'];
    mainSignature = json['mainSignature'];
  }
}
