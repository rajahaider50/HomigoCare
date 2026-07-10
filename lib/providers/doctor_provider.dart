import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../models/booking_model.dart';
import '../services/firebase_database_service.dart';

class DoctorProvider extends ChangeNotifier {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  DoctorModel? _doctorModel;
  List<BookingModel> _bookings = [];
  List<DoctorModel> _allDoctors = [];
  bool _isLoading = false;

  DoctorModel? get doctorModel => _doctorModel;
  List<BookingModel> get bookings => _bookings;
  List<DoctorModel> get allDoctors => _allDoctors;
  bool get isLoading => _isLoading;

  void loadDoctorProfile(String uid) {
    _dbService.doctorStream(uid).listen((doctor) {
      _doctorModel = doctor;
      notifyListeners();
    });
  }

  void loadBookings(String providerId) {
    _dbService.providerBookingsStream(providerId).listen((bookings) {
      _bookings = bookings;
      notifyListeners();
    });
  }

  void loadAllDoctors() {
    _dbService.doctorsStream().listen((doctors) {
      _allDoctors = doctors.where((d) => d.status == 'approved').toList();
      notifyListeners();
    });
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _dbService.updateBooking(bookingId, {'status': status});
  }

  Future<void> updateDoctorProfile(String uid, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    await _dbService.updateDoctor(uid, data);
    _isLoading = false;
    notifyListeners();
  }
}
