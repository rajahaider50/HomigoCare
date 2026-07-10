import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class PatientChatScreen extends StatelessWidget {
  const PatientChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.border),
            const SizedBox(height: 16),
            Text('No active chats', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              'Start a chat after booking an appointment',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
