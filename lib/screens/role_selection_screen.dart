import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../constants/app_strings.dart';
import '../widgets/role_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                AppStrings.selectRole,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose how you want to use ${AppStrings.appName}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    RoleCard(
                      title: AppStrings.patient,
                      subtitle: AppStrings.patientDesc,
                      icon: Icons.person,
                      color: AppColors.patientColor,
                      onTap: () => Navigator.pushNamed(context, '/login', arguments: 'patient'),
                    ),
                    RoleCard(
                      title: AppStrings.doctor,
                      subtitle: AppStrings.doctorDesc,
                      icon: Icons.medical_services,
                      color: AppColors.doctorColor,
                      onTap: () => Navigator.pushNamed(context, '/login', arguments: 'doctor'),
                    ),
                    RoleCard(
                      title: AppStrings.nurse,
                      subtitle: AppStrings.nurseDesc,
                      icon: Icons.local_hospital,
                      color: AppColors.nurseColor,
                      onTap: () => Navigator.pushNamed(context, '/login', arguments: 'nurse'),
                    ),
                    RoleCard(
                      title: AppStrings.lab,
                      subtitle: AppStrings.labDesc,
                      icon: Icons.science,
                      color: AppColors.labColor,
                      onTap: () => Navigator.pushNamed(context, '/login', arguments: 'lab'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
