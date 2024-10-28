class UserModel {
  final String fullName;
  final String email;
  final String uid;
  UserModel({
    required this.fullName,
    required this.email,
    required this.uid,
  });

// toJson

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "uid": uid,
      };
}
