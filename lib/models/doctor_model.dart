class DoctorModel {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String specialization;
  final int experience;
  final double consultationFee;
  final String bio;
  final String? profileImage;
  final String medicalCouncilReg;
  final List<String> availableDays;
  final String availableTimeFrom;
  final String availableTimeTo;
  final List<String> availableTests;
  final bool isVerified;
  final bool isAvailable;
  final double rating;
  final int totalPatients;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.specialization,
    required this.experience,
    required this.consultationFee,
    required this.bio,
    this.profileImage,
    required this.medicalCouncilReg,
    required this.availableDays,
    required this.availableTimeFrom,
    required this.availableTimeTo,
    this.availableTests = const [],
    this.isVerified = false,
    this.isAvailable = true,
    this.rating = 0.0,
    this.totalPatients = 0,
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorModel.fromMap(Map<dynamic, dynamic> map) {
    return DoctorModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      specialization: map['specialization'] ?? '',
      experience: map['experience'] ?? 0,
      consultationFee: (map['consultationFee'] ?? 0).toDouble(),
      bio: map['bio'] ?? '',
      profileImage: map['profileImage'],
      medicalCouncilReg: map['medicalCouncilReg'] ?? '',
      availableDays: List<String>.from(map['availableDays'] ?? []),
      availableTimeFrom: map['availableTimeFrom'] ?? '',
      availableTimeTo: map['availableTimeTo'] ?? '',
      availableTests: List<String>.from(map['availableTests'] ?? []),
      isVerified: map['isVerified'] ?? false,
      isAvailable: map['isAvailable'] ?? true,
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
      'specialization': specialization,
      'experience': experience,
      'consultationFee': consultationFee,
      'bio': bio,
      'profileImage': profileImage,
      'medicalCouncilReg': medicalCouncilReg,
      'availableDays': availableDays,
      'availableTimeFrom': availableTimeFrom,
      'availableTimeTo': availableTimeTo,
      'availableTests': availableTests,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'rating': rating,
      'totalPatients': totalPatients,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
