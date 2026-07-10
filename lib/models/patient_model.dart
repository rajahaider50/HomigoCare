class PatientModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final int age;
  final String? gender;
  final String? address;
  final List<String> medicalHistory;
  final List<String> allergies;
  final List<String> emergencyContacts;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.age = 0,
    this.gender,
    this.address,
    this.medicalHistory = const [],
    this.allergies = const [],
    this.emergencyContacts = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromMap(Map<dynamic, dynamic> map) {
    return PatientModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImage: map['profileImage'],
      age: map['age'] ?? 0,
      gender: map['gender'],
      address: map['address'],
      medicalHistory: List<String>.from(map['medicalHistory'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'age': age,
      'gender': gender,
      'address': address,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'emergencyContacts': emergencyContacts,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
