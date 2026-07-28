class UserModel {
  final int id;
  final String email;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
