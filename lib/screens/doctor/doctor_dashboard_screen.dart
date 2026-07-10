import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/doctor_provider.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.userModel != null) {
        context.read<DoctorProvider>().loadDoctorProfile(auth.userModel!.uid);
        context.read<DoctorProvider>().loadBookings(auth.userModel!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctor = context.watch<DoctorProvider>().doctorModel;
    final auth = context.watch<AuthProvider>();

    if (doctor != null && doctor.status == 'pending') {
      return _buildPendingScreen();
    }

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildPendingScreen() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_top, size: 80, color: AppColors.accent),
              const SizedBox(height: 24),
              Text(
                'Registration Under Review',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark),
              ),
              const SizedBox(height: 12),
              Text(
                'Your registration is being reviewed by the admin. You will be notified once approved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) Navigator.pushReplacementNamed(context, '/role-selection');
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildAppointmentsTab();
      case 2:
        return _buildChatTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    final doctor = context.watch<DoctorProvider>().doctorModel;
    final bookings = context.watch<DoctorProvider>().bookings;
    final auth = context.watch<AuthProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.doctorColor.withOpacity(0.1),
                  child: Text(
                    (auth.userModel?.fullName ?? 'D')[0].toUpperCase(),
                    style: TextStyle(color: AppColors.doctorColor, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${auth.userModel?.fullName ?? ''}',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark),
                      ),
                      Text(
                        doctor?.specialization ?? '',
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (doctor?.isAvailable ?? false) ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (doctor?.isAvailable ?? false) ? 'Available' : 'Offline',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: (doctor?.isAvailable ?? false) ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard('Today\'s\nBookings', '${bookings.where((b) => b.status == 'confirmed').length}', AppColors.primary),
                const SizedBox(width: 12),
                _buildStatCard('Total\nPatients', '${doctor?.totalPatients ?? 0}', AppColors.accent),
                const SizedBox(width: 12),
                _buildStatCard('Rating', '${doctor?.rating ?? 0.0}', AppColors.success),
              ],
            ),
            const SizedBox(height: 24),
            Text('Recent Appointments', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (bookings.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('No appointments yet', style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ...bookings.take(5).map((booking) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.patientColor.withOpacity(0.1),
                    child: Icon(Icons.person, color: AppColors.patientColor),
                  ),
                  title: Text(booking.patientName, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text('${booking.timeSlot} • ${booking.status}'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    final bookings = context.watch<DoctorProvider>().bookings;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: AppColors.patientColor.withOpacity(0.1),
              child: Icon(Icons.person, color: AppColors.patientColor),
            ),
            title: Text(booking.patientName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('${booking.timeSlot} • ${booking.status.toUpperCase()}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                if (booking.status == 'pending')
                  const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
                if (booking.status == 'confirmed')
                  const PopupMenuItem(value: 'complete', child: Text('Complete')),
                const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
              ],
              onSelected: (value) {
                String newStatus = value == 'confirm' ? 'confirmed' : value == 'complete' ? 'completed' : 'cancelled';
                context.read<DoctorProvider>().updateBookingStatus(booking.bookingId, newStatus);
              },
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
          Text('Patient Chats', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final auth = context.watch<AuthProvider>();
    final doctor = context.watch<DoctorProvider>().doctorModel;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.doctorColor.withOpacity(0.1),
            child: Text(
              'Dr.',
              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.doctorColor),
            ),
          ),
          const SizedBox(height: 16),
          Text('Dr. ${auth.userModel?.fullName ?? ''}', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(doctor?.specialization ?? '', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _buildProfileInfo('Registration #', doctor?.medicalCouncilReg ?? ''),
          _buildProfileInfo('Experience', '${doctor?.experience ?? 0} years'),
          _buildProfileInfo('Fee', 'PKR ${doctor?.consultationFee.toInt() ?? 0}'),
          _buildProfileInfo('Available Days', doctor?.availableDays.join(', ') ?? ''),
          _buildProfileInfo('Time', '${doctor?.availableTimeFrom ?? ''} - ${doctor?.availableTimeTo ?? ''}'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await auth.logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/role-selection');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Logout', style: TextStyle(color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
