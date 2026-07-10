import 'package:flutter/material.dart';
import '../models/lab_model.dart';
import '../models/booking_model.dart';
import '../services/firebase_database_service.dart';

class LabProvider extends ChangeNotifier {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  LabModel? _labModel;
  List<BookingModel> _bookings = [];
  bool _isLoading = false;

  LabModel? get labModel => _labModel;
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  void loadLabProfile(String uid) {
    _dbService.labsStream().listen((labs) {
      final match = labs.where((l) => l.uid == uid);
      if (match.isNotEmpty) {
        _labModel = match.first;
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

  Future<void> updateLabProfile(String uid, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    await _dbService.updateLab(uid, data);
    _isLoading = false;
    notifyListeners();
  }
}
