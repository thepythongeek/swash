import 'profile.dart';

class User {
  final String id;
  final String role;
  Profile? profile;

  User({required this.id, required this.role, this.profile});
}
