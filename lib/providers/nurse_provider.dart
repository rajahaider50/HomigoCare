import 'package:flutter/material.dart';
import '../models/nurse_model.dart';
import '../models/booking_model.dart';
import '../services/firebase_database_service.dart';

class NurseProvider extends ChangeNotifier {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  NurseModel? _nurseModel;
  List<BookingModel> _bookings = [];
  bool _isLoading = false;

  NurseModel? get nurseModel => _nurseModel;
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  void loadNurseProfile(String uid) {
    _dbService.doctorStream(uid);
    _dbService.nursesStream().listen((nurses) {
      final match = nurses.where((n) => n.uid == uid);
      if (match.isNotEmpty) {
        _nurseModel = match.first;
        notifyListeners();
      }
    });
  }

  void loadBookings(String providerId) {
    _dbService.providerBookingsStream(providerId).listen((bookings) {
      _bookings = bookings;
      notifyListeners();
    });
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _dbService.updateBooking(bookingId, {'status': status});
  }

  Future<void> updateNurseProfile(String uid, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    await _dbService.updateNurse(uid, data);
    _isLoading = false;
    notifyListeners();
  }
}
