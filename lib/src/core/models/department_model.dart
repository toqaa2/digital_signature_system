class DeparmentModel {
  String? deprtmentID;
  String? departmentName;
  List<String>? roles;

  DeparmentModel({
    required this.deprtmentID,
    required this.departmentName,
    required this.roles,
  });

  Map<String, dynamic> toMap() => {
        'deprtmentID': deprtmentID,
        'departmentName': departmentName,
        'roles': roles,
      };

  DeparmentModel.fromJson(Map<String, dynamic>? json) {
    deprtmentID = json!['deprtmentID'];
    departmentName = json['departmentName'];
    roles = List.generate(json['roles'].length, (index) => json['roles'][index],);
  }
}
