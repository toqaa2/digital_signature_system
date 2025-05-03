class DepartmentModel {
  String? departmentID;
  String? departmentName;
  List<String>? roles;

  DepartmentModel({
    required this.departmentID,
    required this.departmentName,
    required this.roles,
  });

  Map<String, dynamic> toMap() => {
        'deprtmentID': departmentID,
        'departmentName': departmentName,
        'roles': roles,
      };

  DepartmentModel.fromJson(Map<String, dynamic>? json) {
    departmentID = json!['deprtmentID'];
    departmentName = json['departmentName'];
    roles = List.generate(json['roles'].length, (index) => json['roles'][index],);
  }
}
