class UserModel {
  String? userId;
  String? department;

  String? name;
  String? role;
  String? email;
  String? signature;

  UserModel(
    this.userId,
    this.department,
    this.name,
    this.role,
    this.email,
    this.signature,
  );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'department': department,
        'name': name,
        'role': role,
        'email': email,
        'signature': signature,
      };

  UserModel.fromJson(Map<String, dynamic>? json) {
    userId = json!['userId'];
    department = json['department'];

    name = json['name'];
    role = json['role'];
    email = json['email'];
    signature = json['signature'];
  }
}
