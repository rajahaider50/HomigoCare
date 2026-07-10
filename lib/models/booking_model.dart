class BookingModel {
  final String bookingId;
  final String patientId;
  final String patientName;
  final String providerId;
  final String providerName;
  final String providerType; // doctor, nurse, lab
  final String? specialization;
  final DateTime date;
  final String timeSlot;
  final String status; // pending, confirmed, completed, cancelled
  final String? reason;
  final String? notes;
  final double? fee;
  final String? paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.bookingId,
    required this.patientId,
    required this.patientName,
    required this.providerId,
    required this.providerName,
    required this.providerType,
    this.specialization,
    required this.date,
    required this.timeSlot,
    this.status = 'pending',
    this.reason,
    this.notes,
    this.fee,
    this.paymentStatus = 'unpaid',
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromMap(Map<dynamic, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      providerType: map['providerType'] ?? '',
      specialization: map['specialization'],
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? 'pending',
      reason: map['reason'],
      notes: map['notes'],
      fee: map['fee']?.toDouble(),
      paymentStatus: map['paymentStatus'] ?? 'unpaid',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'patientId': patientId,
      'patientName': patientName,
      'providerId': providerId,
      'providerName': providerName,
      'providerType': providerType,
      'specialization': specialization,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'reason': reason,
      'notes': notes,
      'fee': fee,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BookingModel copyWith({
    String? status,
    String? notes,
    String? paymentStatus,
  }) {
    return BookingModel(
      bookingId: bookingId,
      patientId: patientId,
      patientName: patientName,
      providerId: providerId,
      providerName: providerName,
      providerType: providerType,
      specialization: specialization,
      date: date,
      timeSlot: timeSlot,
      status: status ?? this.status,
      reason: reason,
      notes: notes ?? this.notes,
      fee: fee,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
