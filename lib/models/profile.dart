class GetProfile {
  GetProfile({required this.profile});

  Profile profile;

  factory GetProfile.fromJson(var json) => GetProfile(
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "profile": profile.toJson(),
      };
}

class Profile {
  Profile(
      {required this.id,
      required this.bio,
      required this.name,
      required this.ward,
      required this.email,
      required this.gender,
      required this.roleId,
      this.school,
      this.desr,
      this.profession,
      this.dob,
      required this.location,
      required this.isExpert,
      this.profilePic,
      this.categoryName,
      this.ambassadorLevel,
      this.follower});

  String id;
  String bio;
  String? profession;
  String? dob;
  String? desr;
  String name;
  String email;
  Map<String, dynamic>? ward;
  String roleId;
  String gender;
  Map<String, dynamic>? school;
  String location;
  String isExpert;
  String? profilePic;
  String? categoryName;
  String? ambassadorLevel;
  String? follower;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      bio: json["bio"] ?? '',
      name: json["name"],
      ward: json["ward"],
      email: json["email"],
      gender: json["gender"],
      school: json["school"],
      roleId: json["role_id"],
      location: json["location"] ?? "null",
      isExpert: json["is_expert"],
      profilePic: json["profile_pic"],
      categoryName: json["category_name"],
      ambassadorLevel: json["ambassador_level"],
      dob: json['dob'],
      desr: json['desr'],
      profession: json['profession'],
      follower: json["followers"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "bio": bio,
        "ward": ward,
        "name": name,
        "email": email,
        "school": school,
        "gender": gender,
        "role_id": roleId,
        "location": location,
        "is_expert": isExpert,
        "profile_pic": profilePic,
        "category_name": categoryName,
        "ambassador_level": ambassadorLevel,
      };
}
