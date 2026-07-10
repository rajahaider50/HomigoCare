import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/nurse_model.dart';
import '../models/lab_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_database_service.dart';
import '../constants/app_strings.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();

  UserModel? _userModel;
  DoctorModel? _doctorModel;
  NurseModel? _nurseModel;
  LabModel? _labModel;
  bool _isLoading = false;
  String? _error;

  UserModel? get userModel => _userModel;
  DoctorModel? get doctorModel => _doctorModel;
  NurseModel? get nurseModel => _nurseModel;
  LabModel? get labModel => _labModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _userModel != null;
  String get userRole => _userModel?.role ?? '';

  Future<void> init() async {
    final user = _authService.currentUser;
    if (user != null) {
      await _loadUserData(user.uid);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userModel = await _authService.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: role,
      );
      if (userModel != null) {
        await _dbService.createUser(userModel);
        _userModel = userModel;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.loginWithEmail(
        email: email,
        password: password,
      );
      if (user != null) {
        await _loadUserData(user.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userModel = await _authService.signInWithGoogle();
      if (userModel != null) {
        final existing = await _dbService.getUser(userModel.uid);
        if (existing == null) {
          await _dbService.createUser(userModel);
          _userModel = userModel;
        } else {
          _userModel = existing;
          await _loadRoleData(existing.uid, existing.role);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _userModel = null;
    _doctorModel = null;
    _nurseModel = null;
    _labModel = null;
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    _userModel = await _dbService.getUser(uid);
    if (_userModel != null) {
      await _loadRoleData(uid, _userModel!.role);
    }
    notifyListeners();
  }

  Future<void> _loadRoleData(String uid, String role) async {
    switch (role) {
      case 'doctor':
        _doctorModel = await _dbService.getDoctor(uid);
        break;
      case 'nurse':
        _nurseModel = await _dbService.getNurse(uid);
        break;
      case 'lab':
        _labModel = await _dbService.getLab(uid);
        break;
    }
  }

  Future<void> refreshUser() async {
    if (_authService.currentUser != null) {
      await _loadUserData(_authService.currentUser!.uid);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
