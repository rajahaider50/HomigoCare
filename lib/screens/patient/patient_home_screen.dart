import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadDoctors();
      context.read<PatientProvider>().loadNurses();
      context.read<PatientProvider>().loadLabs();
      final auth = context.read<AuthProvider>();
      if (auth.userModel != null) {
        context.read<PatientProvider>().loadBookings(auth.userModel!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      _buildBookingsTab(),
      _buildChatTab(),
      _buildProfileTab(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: AppStrings.home),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: AppStrings.bookings),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), activeIcon: Icon(Icons.chat), label: AppStrings.chat),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: AppStrings.profile),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final auth = context.watch<AuthProvider>();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${auth.userModel?.fullName ?? 'Patient'}',
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'How can we help you today?',
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textSecondary),
                  const SizedBox(width: 12),
                  Text(
                    'Search doctors, nurses, labs...',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            Text(
              'Nearby Doctors',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.dark),
            ),
            const SizedBox(height: 12),
            _buildDoctorList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionCard(Icons.medical_services, 'Doctors', AppColors.doctorColor, () {
          Navigator.pushNamed(context, '/find-doctors');
        }),
        const SizedBox(width: 12),
        _buildActionCard(Icons.local_hospital, 'Nurses', AppColors.nurseColor, () {
          Navigator.pushNamed(context, '/find-nurses');
        }),
        const SizedBox(width: 12),
        _buildActionCard(Icons.science, 'Lab', AppColors.labColor, () {
          Navigator.pushNamed(context, '/find-labs');
        }),
        const SizedBox(width: 12),
        _buildActionCard(Icons.emergency, 'Emergency', AppColors.error, () {}),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorList() {
    final patientProvider = context.watch<PatientProvider>();
    if (patientProvider.doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No doctors available', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: patientProvider.doctors.length.clamp(0, 5),
        itemBuilder: (context, index) {
          final doctor = patientProvider.doctors[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.doctorColor.withOpacity(0.1),
                  child: Text(
                    doctor.fullName[0].toUpperCase(),
                    style: TextStyle(color: AppColors.doctorColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  doctor.fullName,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  doctor.specialization,
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
                ),
                Text(
                  'PKR ${doctor.consultationFee.toInt()}',
                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingsTab() {
    final patientProvider = context.watch<PatientProvider>();
    if (patientProvider.bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: AppColors.border),
            const SizedBox(height: 16),
            Text('No bookings yet', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patientProvider.bookings.length,
      itemBuilder: (context, index) {
        final booking = patientProvider.bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(booking.status).withOpacity(0.1),
              child: Icon(_getStatusIcon(booking.status), color: _getStatusColor(booking.status)),
            ),
            title: Text(booking.providerName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('${booking.timeSlot} • ${booking.status.toUpperCase()}', style: GoogleFonts.poppins(fontSize: 12)),
            trailing: Text(
              '${booking.date.day}/${booking.date.month}',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat, size: 64, color: AppColors.border),
          const SizedBox(height: 16),
          Text('Chat with your doctors', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                (user?.fullName ?? 'P')[0].toUpperCase(),
                style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? '',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dark),
            ),
            const SizedBox(height: 4),
            Text(user?.email ?? '', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(user?.phoneNumber ?? '', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            _buildProfileOption(Icons.person_outline, 'Edit Profile', () {}),
            _buildProfileOption(Icons.history, 'Appointment History', () {}),
            _buildProfileOption(Icons.settings, 'Settings', () {}),
            _buildProfileOption(Icons.help_outline, 'Help & Support', () {}),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/role-selection');
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text('Logout', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.dark),
      title: Text(title, style: GoogleFonts.poppins()),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed': return AppColors.success;
      case 'pending': return AppColors.accent;
      case 'cancelled': return AppColors.error;
      case 'completed': return AppColors.primary;
      default: return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmed': return Icons.check_circle;
      case 'pending': return Icons.access_time;
      case 'cancelled': return Icons.cancel;
      case 'completed': return Icons.done_all;
      default: return Icons.info;
    }
  }
}
