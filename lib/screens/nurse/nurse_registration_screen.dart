import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_database_service.dart';
import '../../models/nurse_model.dart';

class NurseRegistrationScreen extends StatefulWidget {
  const NurseRegistrationScreen({super.key});

  @override
  State<NurseRegistrationScreen> createState() => _NurseRegistrationScreenState();
}

class _NurseRegistrationScreenState extends State<NurseRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  bool _isAvailableForHome = true;
  bool _hasAghaKhanCert = false;
  bool _hasDrivingLicense = false;
  final _dbService = FirebaseDatabaseService();
  final List<String> _areas = [];

  @override
  void dispose() {
    _qualificationController.dispose();
    _experienceController.dispose();
    _serviceAreaController.dispose();
    super.dispose();
  }

  void _addArea() {
    if (_serviceAreaController.text.isNotEmpty) {
      setState(() {
        _areas.add(_serviceAreaController.text);
        _serviceAreaController.clear();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasAghaKhanCert) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aga Khan Nursing Certificate is required'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (_areas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one service area'), backgroundColor: AppColors.error),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.userModel;
    if (user == null) return;

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final nurse = NurseModel(
      uid: user.uid,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      qualification: _qualificationController.text,
      yearsOfExperience: int.tryParse(_experienceController.text) ?? 0,
      serviceAreas: _areas,
      isAvailableForHome: _isAvailableForHome,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.createNurse(nurse);
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, '/nurse-pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nurse Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_hospital, size: 48, color: AppColors.nurseColor),
              const SizedBox(height: 16),
              Text('Nurse Registration', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark)),
              const SizedBox(height: 8),
              Text('Fill in your professional details', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Nursing Qualification',
                hint: 'e.g., BSN, RN, Diploma',
                controller: _qualificationController,
                prefixIcon: const Icon(Icons.school_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Years of Experience',
                hint: 'e.g., 5',
                controller: _experienceController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.work_outline),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Service Areas', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: '',
                      hint: 'Add service area',
                      controller: _serviceAreaController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addArea,
                    icon: const Icon(Icons.add_circle, color: AppColors.nurseColor, size: 36),
                  ),
                ],
              ),
              if (_areas.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _areas.map((area) => Chip(
                    label: Text(area),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => setState(() => _areas.remove(area)),
                    backgroundColor: AppColors.nurseColor.withOpacity(0.1),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Available for Home Visits'),
                value: _isAvailableForHome,
                onChanged: (v) => setState(() => _isAvailableForHome = v),
                activeColor: AppColors.nurseColor,
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              CheckboxListTile(
                value: _hasAghaKhanCert,
                onChanged: (v) => setState(() => _hasAghaKhanCert = v ?? false),
                title: const Text('Aga Khan Nursing Certificate'),
                subtitle: const Text('Required', style: TextStyle(fontSize: 12)),
                activeColor: AppColors.nurseColor,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _hasDrivingLicense,
                onChanged: (v) => setState(() => _hasDrivingLicense = v ?? false),
                title: const Text('Driving License (for Home Visits)'),
                activeColor: AppColors.nurseColor,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Submit Registration',
                color: AppColors.nurseColor,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
