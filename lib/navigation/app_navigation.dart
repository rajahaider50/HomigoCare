import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/patient/patient_home_screen.dart';
import '../screens/doctor/doctor_registration_screen.dart';
import '../screens/doctor/doctor_dashboard_screen.dart';
import '../screens/doctor/doctor_pending_screen.dart';
import '../screens/nurse/nurse_registration_screen.dart';
import '../screens/nurse/nurse_dashboard_screen.dart';
import '../screens/lab/lab_registration_screen.dart';
import '../screens/lab/lab_dashboard_screen.dart';

class AppNavigation {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String patientHome = '/patient-home';
  static const String doctorRegistration = '/doctor-registration';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String doctorPending = '/doctor-pending';
  static const String nurseRegistration = '/nurse-registration';
  static const String nurseDashboard = '/nurse-dashboard';
  static const String nursePending = '/nurse-pending';
  static const String labRegistration = '/lab-registration';
  static const String labDashboard = '/lab-dashboard';
  static const String labPending = '/lab-pending';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    patientHome: (context) => const PatientHomeScreen(),
    doctorRegistration: (context) => const DoctorRegistrationScreen(),
    doctorDashboard: (context) => const DoctorDashboardScreen(),
    doctorPending: (context) => const DoctorPendingScreen(),
    nurseRegistration: (context) => const NurseRegistrationScreen(),
    nurseDashboard: (context) => const NurseDashboardScreen(),
    labRegistration: (context) => const LabRegistrationScreen(),
    labDashboard: (context) => const LabDashboardScreen(),
  };

  static void navigateByRole(BuildContext context, String role) {
    switch (role) {
      case 'patient':
        Navigator.pushReplacementNamed(context, patientHome);
        break;
      case 'doctor':
        Navigator.pushReplacementNamed(context, doctorDashboard);
        break;
      case 'nurse':
        Navigator.pushReplacementNamed(context, nurseDashboard);
        break;
      case 'lab':
        Navigator.pushReplacementNamed(context, labDashboard);
        break;
      case 'admin':
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
        break;
      default:
        Navigator.pushReplacementNamed(context, roleSelection);
    }
  }

  static void goToRoleSelection(BuildContext context) {
    Navigator.pushReplacementNamed(context, roleSelection);
  }
}
