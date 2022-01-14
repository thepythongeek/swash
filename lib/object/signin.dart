class Signin {
  bool success;
  String userId;
  String roleId;
  String wardId;
  String message;
  String schoolId;

  Signin(
      {required this.success,
      required this.userId,
      required this.roleId,
      required this.wardId,
      required this.message,
      required this.schoolId});

  Signin.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        message = json['message'],
        userId = json['user_id'].toString(),
        roleId = json['role_id'].toString(),
        wardId = json['ward_id'].toString(),
        schoolId = json['school_id'].toString();
}
