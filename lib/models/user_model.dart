class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String avatarUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.bio = '',
    this.avatarUrl = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        bio: map['bio'] ?? '',
        avatarUrl: map['avatarUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'bio': bio,
        'avatarUrl': avatarUrl,
      };
}