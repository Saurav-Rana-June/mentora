class ProfileModel {
  final int id;
  final int userId;
  final String name;
  final String? gender;
  final int? age;
  final String? email;
  final String? address;
  final double? height;
  final double? weight;
  final double? bmi;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String createdAt;
  final String updatedAt;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    this.gender,
    this.age,
    this.email,
    this.address,
    this.height,
    this.weight,
    this.bmi,
    this.phoneNumber,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'gender': gender,
      'age': age,
      'email': email,
      'address': address,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
