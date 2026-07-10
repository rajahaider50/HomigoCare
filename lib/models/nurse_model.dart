class NurseModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String qualification;
  final int yearsOfExperience;
  final List<String> serviceAreas;
  final bool isAvailableForHome;
  final bool isVerified;
  final double rating;
  final int totalPatients;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  NurseModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.qualification,
    required this.yearsOfExperience,
    required this.serviceAreas,
    this.isAvailableForHome = true,
    this.isVerified = false,
    this.rating = 0.0,
    this.totalPatients = 0,
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  factory NurseModel.fromMap(Map<dynamic, dynamic> map) {
    return NurseModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImage: map['profileImage'],
      qualification: map['qualification'] ?? '',
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
      serviceAreas: List<String>.from(map['serviceAreas'] ?? []),
      isAvailableForHome: map['isAvailableForHome'] ?? true,
      isVerified: map['isVerified'] ?? false,
      rating: (map['rating'] ?? 0).toDouble(),
      totalPatients: map['totalPatients'] ?? 0,
      status: map['status'] ?? 'pending',
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
      'qualification': qualification,
      'yearsOfExperience': yearsOfExperience,
      'serviceAreas': serviceAreas,
      'isAvailableForHome': isAvailableForHome,
      'isVerified': isVerified,
      'rating': rating,
      'totalPatients': totalPatients,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
