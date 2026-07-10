import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../models/booking_model.dart';
import '../models/doctor_model.dart';
import '../models/nurse_model.dart';
import '../models/lab_model.dart';
import '../services/firebase_database_service.dart';

class PatientProvider extends ChangeNotifier {
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  List<DoctorModel> _doctors = [];
  List<NurseModel> _nurses = [];
  List<LabModel> _labs = [];
  List<BookingModel> _bookings = [];
  bool _isLoading = false;

  List<DoctorModel> get doctors => _doctors;
  List<NurseModel> get nurses => _nurses;
  List<LabModel> get labs => _labs;
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  void loadDoctors() {
    _dbService.doctorsStream().listen((doctors) {
      _doctors = doctors.where((d) => d.status == 'approved' && d.isAvailable).toList();
      notifyListeners();
    });
  }

  void loadNurses() {
    _dbService.nursesStream().listen((nurses) {
      _nurses = nurses.where((n) => n.status == 'approved').toList();
      notifyListeners();
    });
  }

  void loadLabs() {
    _dbService.labsStream().listen((labs) {
      _labs = labs.where((l) => l.status == 'approved').toList();
      notifyListeners();
    });
  }

  void loadBookings(String patientId) {
    _dbService.patientBookingsStream(patientId).listen((bookings) {
      _bookings = bookings;
      notifyListeners();
    });
  }

  Future<void> bookAppointment(BookingModel booking) async {
    _isLoading = true;
    notifyListeners();
    await _dbService.createBooking(booking);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    await _dbService.updateBooking(bookingId, {'status': 'cancelled'});
  }
}
