import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lab_provider.dart';

class LabDashboardScreen extends StatefulWidget {
  const LabDashboardScreen({super.key});

  @override
  State<LabDashboardScreen> createState() => _LabDashboardScreenState();
}

class _LabDashboardScreenState extends State<LabDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.userModel != null) {
        context.read<LabProvider>().loadLabProfile(auth.userModel!.uid);
        context.read<LabProvider>().loadBookings(auth.userModel!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lab = context.watch<LabProvider>().labModel;
    final auth = context.watch<AuthProvider>();
    final bookings = context.watch<LabProvider>().bookings;

    if (lab != null && lab.status == 'pending') {
      return _buildPendingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Dashboard'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.labColor.withOpacity(0.1),
                  child: Icon(Icons.science, color: AppColors.labColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lab?.labName ?? auth.userModel?.fullName ?? '', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(lab?.address ?? '', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard('Total\nTests', '${lab?.totalTests ?? 0}', AppColors.labColor),
                const SizedBox(width: 12),
                _buildStatCard('Pending\nOrders', '${bookings.where((b) => b.status == 'pending').length}', AppColors.accent),
                const SizedBox(width: 12),
                _buildStatCard('Rating', '${lab?.rating ?? 0.0}', AppColors.success),
              ],
            ),
            const SizedBox(height: 24),
            Text('Recent Orders', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (bookings.isEmpty)
              Center(child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text('No orders yet', style: TextStyle(color: AppColors.textSecondary)),
              ))
            else
              ...bookings.take(5).map((b) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.patientColor.withOpacity(0.1),
                    child: const Icon(Icons.person, color: AppColors.patientColor),
                  ),
                  title: Text(b.patientName, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text('${b.reason ?? "Test"} • ${b.status}'),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      if (b.status == 'pending')
                        const PopupMenuItem(value: 'confirm', child: Text('Accept')),
                      if (b.status == 'confirmed')
                        const PopupMenuItem(value: 'complete', child: Text('Complete')),
                    ],
                    onSelected: (v) {
                      String s = v == 'confirm' ? 'confirmed' : 'completed';
                      context.read<LabProvider>().updateBookingStatus(b.bookingId, s);
                    },
                  ),
                ),
              )),
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
      ),
    );
  }

  Widget _buildPendingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_top, size: 80, color: AppColors.accent),
            const SizedBox(height: 24),
            Text('Registration Under Review', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Your lab registration is being reviewed.', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/role-selection');
              },
              child: const Text('Logout'),
            ),
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
}
