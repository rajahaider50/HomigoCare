import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/nurse_model.dart';
import '../models/lab_model.dart';
import '../models/booking_model.dart';
import '../models/chat_message_model.dart';
import '../models/mcq_model.dart';
import '../constants/app_strings.dart';

class FirebaseDatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ==================== USER OPERATIONS ====================

  Future<void> createUser(UserModel user) async {
    await _db.child(AppStrings.usersPath).child(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _db.child(AppStrings.usersPath).child(uid).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.value as Map);
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    await _db.child(AppStrings.usersPath).child(uid).update(data);
  }

  Stream<UserModel?> userStream(String uid) {
    return _db.child(AppStrings.usersPath).child(uid).onValue.map((event) {
      if (event.snapshot.exists) {
        return UserModel.fromMap(event.snapshot.value as Map);
      }
      return null;
    });
  }

  // ==================== DOCTOR OPERATIONS ====================

  Future<void> createDoctor(DoctorModel doctor) async {
    await _db.child(AppStrings.doctorsPath).child(doctor.uid).set(doctor.toMap());
  }

  Future<DoctorModel?> getDoctor(String uid) async {
    final snapshot = await _db.child(AppStrings.doctorsPath).child(uid).get();
    if (snapshot.exists) {
      return DoctorModel.fromMap(snapshot.value as Map);
    }
    return null;
  }

  Future<void> updateDoctor(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    await _db.child(AppStrings.doctorsPath).child(uid).update(data);
  }

  Stream<DoctorModel?> doctorStream(String uid) {
    return _db.child(AppStrings.doctorsPath).child(uid).onValue.map((event) {
      if (event.snapshot.exists) {
        return DoctorModel.fromMap(event.snapshot.value as Map);
      }
      return null;
    });
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    final snapshot = await _db.child(AppStrings.doctorsPath).get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data.values.map((e) => DoctorModel.fromMap(e as Map)).toList();
    }
    return [];
  }

  Stream<List<DoctorModel>> doctorsStream() {
    return _db.child(AppStrings.doctorsPath).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        return data.values.map((e) => DoctorModel.fromMap(e as Map)).toList();
      }
      return [];
    });
  }

  Future<List<DoctorModel>> getApprovedDoctors() async {
    final snapshot = await _db.child(AppStrings.doctorsPath)
        .orderByChild('status')
        .equalTo('approved')
        .get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data.values.map((e) => DoctorModel.fromMap(e as Map)).toList();
    }
    return [];
  }

  // ==================== NURSE OPERATIONS ====================

  Future<void> createNurse(NurseModel nurse) async {
    await _db.child(AppStrings.nursesPath).child(nurse.uid).set(nurse.toMap());
  }

  Future<NurseModel?> getNurse(String uid) async {
    final snapshot = await _db.child(AppStrings.nursesPath).child(uid).get();
    if (snapshot.exists) {
      return NurseModel.fromMap(snapshot.value as Map);
    }
    return null;
  }

  Future<void> updateNurse(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    await _db.child(AppStrings.nursesPath).child(uid).update(data);
  }

  Stream<List<NurseModel>> nursesStream() {
    return _db.child(AppStrings.nursesPath).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        return data.values.map((e) => NurseModel.fromMap(e as Map)).toList();
      }
      return [];
    });
  }

  Future<List<NurseModel>> getApprovedNurses() async {
    final snapshot = await _db.child(AppStrings.nursesPath)
        .orderByChild('status')
        .equalTo('approved')
        .get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data.values.map((e) => NurseModel.fromMap(e as Map)).toList();
    }
    return [];
  }

  // ==================== LAB OPERATIONS ====================

  Future<void> createLab(LabModel lab) async {
    await _db.child(AppStrings.labsPath).child(lab.uid).set(lab.toMap());
  }

  Future<LabModel?> getLab(String uid) async {
    final snapshot = await _db.child(AppStrings.labsPath).child(uid).get();
    if (snapshot.exists) {
      return LabModel.fromMap(snapshot.value as Map);
    }
    return null;
  }

  Future<void> updateLab(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    await _db.child(AppStrings.labsPath).child(uid).update(data);
  }

  Stream<List<LabModel>> labsStream() {
    return _db.child(AppStrings.labsPath).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        return data.values.map((e) => LabModel.fromMap(e as Map)).toList();
      }
      return [];
    });
  }

  Future<List<LabModel>> getApprovedLabs() async {
    final snapshot = await _db.child(AppStrings.labsPath)
        .orderByChild('status')
        .equalTo('approved')
        .get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data.values.map((e) => LabModel.fromMap(e as Map)).toList();
    }
    return [];
  }

  // ==================== BOOKING OPERATIONS ====================

  Future<void> createBooking(BookingModel booking) async {
    await _db.child(AppStrings.bookingsPath).child(booking.bookingId).set(booking.toMap());
  }

  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    await _db.child(AppStrings.bookingsPath).child(bookingId).update(data);
  }

  Stream<List<BookingModel>> patientBookingsStream(String patientId) {
    return _db.child(AppStrings.bookingsPath)
        .orderByChild('patientId')
        .equalTo(patientId)
        .onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        final list = data.values.map((e) => BookingModel.fromMap(e as Map)).toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      }
      return [];
    });
  }

  Stream<List<BookingModel>> providerBookingsStream(String providerId) {
    return _db.child(AppStrings.bookingsPath)
        .orderByChild('providerId')
        .equalTo(providerId)
        .onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        final list = data.values.map((e) => BookingModel.fromMap(e as Map)).toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      }
      return [];
    });
  }

  // ==================== CHAT OPERATIONS ====================

  Future<String> createChatRoom(ChatRoom chatRoom) async {
    final ref = _db.child(AppStrings.chatsPath).push();
    final id = ref.key!;
    final room = ChatRoom(
      chatId: id,
      patientId: chatRoom.patientId,
      patientName: chatRoom.patientName,
      providerId: chatRoom.providerId,
      providerName: chatRoom.providerName,
      providerType: chatRoom.providerType,
      lastMessageTime: DateTime.now(),
    );
    await ref.set(room.toMap());
    return id;
  }

  Future<void> sendMessage(String chatId, ChatMessage message) async {
    final ref = _db.child(AppStrings.chatsPath).child(chatId).child(AppStrings.messagesPath).push();
    final msg = ChatMessage(
      messageId: ref.key!,
      senderId: message.senderId,
      senderName: message.senderName,
      text: message.text,
      timestamp: DateTime.now(),
    );
    await ref.set(msg.toMap());

    // Update last message in chat room
    await _db.child(AppStrings.chatsPath).child(chatId).update({
      'lastMessage': message.text,
      'lastMessageTime': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<ChatMessage>> messagesStream(String chatId) {
    return _db.child(AppStrings.chatsPath).child(chatId).child(AppStrings.messagesPath)
        .orderByChild('timestamp')
        .onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        final list = data.values.map((e) => ChatMessage.fromMap(e as Map)).toList();
        list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return list;
      }
      return [];
    });
  }

  Stream<List<ChatRoom>> userChatRooms(String userId) {
    return _db.child(AppStrings.chatsPath).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        final rooms = data.values
            .map((e) => ChatRoom.fromMap(e as Map))
            .where((r) => r.patientId == userId || r.providerId == userId)
            .toList();
        rooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        return rooms;
      }
      return [];
    });
  }

  // ==================== MCQ OPERATIONS ====================

  Future<List<MCQQuestion>> getMCQQuestions() async {
    final snapshot = await _db.child(AppStrings.mcqsPath).get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data.values.map((e) => MCQQuestion.fromMap(e as Map)).toList();
    }
    return [];
  }

  Future<void> submitMCQTest(MCQTest test) async {
    await _db.child(AppStrings.mcqsPath).child('results').child(test.doctorId).set(test.toMap());
  }

  // ==================== ADMIN OPERATIONS ====================

  Stream<List<UserModel>> allUsersStream() {
    return _db.child(AppStrings.usersPath).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        return data.values.map((e) => UserModel.fromMap(e as Map)).toList();
      }
      return [];
    });
  }

  Future<Map<String, int>> getDashboardStats() async {
    final usersSnap = await _db.child(AppStrings.usersPath).get();
    final doctorsSnap = await _db.child(AppStrings.doctorsPath).get();
    final nursesSnap = await _db.child(AppStrings.nursesPath).get();
    final labsSnap = await _db.child(AppStrings.labsPath).get();
    final bookingsSnap = await _db.child(AppStrings.bookingsPath).get();

    int pendingVerifications = 0;
    if (doctorsSnap.exists) {
      final doctors = doctorsSnap.value as Map;
      doctors.values.forEach((d) {
        if ((d as Map)['status'] == 'pending') pendingVerifications++;
      });
    }

    return {
      'totalUsers': usersSnap.exists ? (usersSnap.value as Map).length : 0,
      'totalDoctors': doctorsSnap.exists ? (doctorsSnap.value as Map).length : 0,
      'totalNurses': nursesSnap.exists ? (nursesSnap.value as Map).length : 0,
      'totalLabs': labsSnap.exists ? (labsSnap.value as Map).length : 0,
      'totalBookings': bookingsSnap.exists ? (bookingsSnap.value as Map).length : 0,
      'pendingVerifications': pendingVerifications,
    };
  }
}
