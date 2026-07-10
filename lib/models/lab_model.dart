class LabModel {
  final String uid;
  final String labName;
  final String ownerName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String licenseNumber;
  final List<String> availableTests;
  final String address;
  final bool isVerified;
  final bool isOpen;
  final double rating;
  final int totalTests;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime updatedAt;

  LabModel({
    required this.uid,
    required this.labName,
    required this.ownerName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.licenseNumber,
    required this.availableTests,
    required this.address,
    this.isVerified = false,
    this.isOpen = true,
    this.rating = 0.0,
    this.totalTests = 0,
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  factory LabModel.fromMap(Map<dynamic, dynamic> map) {
    return LabModel(
      uid: map['uid'] ?? '',
      labName: map['labName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImage: map['profileImage'],
      licenseNumber: map['licenseNumber'] ?? '',
      availableTests: List<String>.from(map['availableTests'] ?? []),
      address: map['address'] ?? '',
      isVerified: map['isVerified'] ?? false,
      isOpen: map['isOpen'] ?? true,
      rating: (map['rating'] ?? 0).toDouble(),
      totalTests: map['totalTests'] ?? 0,
      status: map['status'] ?? 'pending',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'labName': labName,
      'ownerName': ownerName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'licenseNumber': licenseNumber,
      'availableTests': availableTests,
      'address': address,
      'isVerified': isVerified,
      'isOpen': isOpen,
      'rating': rating,
      'totalTests': totalTests,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
