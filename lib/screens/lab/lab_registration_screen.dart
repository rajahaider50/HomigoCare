import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_database_service.dart';
import '../../models/lab_model.dart';

class LabRegistrationScreen extends StatefulWidget {
  const LabRegistrationScreen({super.key});

  @override
  State<LabRegistrationScreen> createState() => _LabRegistrationScreenState();
}

class _LabRegistrationScreenState extends State<LabRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labNameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _addressController = TextEditingController();
  final _testController = TextEditingController();
  bool _hasNabeelLabCert = false;
  bool _hasDrivingLicense = false;
  final _dbService = FirebaseDatabaseService();
  final List<String> _tests = [];

  @override
  void dispose() {
    _labNameController.dispose();
    _licenseController.dispose();
    _addressController.dispose();
    _testController.dispose();
    super.dispose();
  }

  void _addTest() {
    if (_testController.text.isNotEmpty) {
      setState(() {
        _tests.add(_testController.text);
        _testController.clear();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasNabeelLabCert) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nabeel Lab Certification is required'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (_tests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one available test'), backgroundColor: AppColors.error),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.userModel;
    if (user == null) return;

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final lab = LabModel(
      uid: user.uid,
      labName: _labNameController.text,
      ownerName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      licenseNumber: _licenseController.text,
      availableTests: _tests,
      address: _addressController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.createLab(lab);
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, '/lab-pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Lab Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.science, size: 48, color: AppColors.labColor),
              const SizedBox(height: 16),
              Text('Lab Registration', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark)),
              const SizedBox(height: 8),
              Text('Register your laboratory', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Lab Name',
                hint: 'e.g., City Diagnostic Lab',
                controller: _labNameController,
                prefixIcon: const Icon(Icons.science_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Lab License #',
                hint: 'License number',
                controller: _licenseController,
                prefixIcon: const Icon(Icons.badge_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Address',
                hint: 'Full address',
                controller: _addressController,
                prefixIcon: const Icon(Icons.location_on_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Available Tests', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: '',
                      hint: 'Add test type',
                      controller: _testController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addTest,
                    icon: const Icon(Icons.add_circle, color: AppColors.labColor, size: 36),
                  ),
                ],
              ),
              if (_tests.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tests.map((test) => Chip(
                    label: Text(test),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => setState(() => _tests.remove(test)),
                    backgroundColor: AppColors.labColor.withOpacity(0.1),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 20),
              const Divider(),
              CheckboxListTile(
                value: _hasNabeelLabCert,
                onChanged: (v) => setState(() => _hasNabeelLabCert = v ?? false),
                title: const Text('Nabeel Lab Certification'),
                subtitle: const Text('Required', style: TextStyle(fontSize: 12)),
                activeColor: AppColors.labColor,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                value: _hasDrivingLicense,
                onChanged: (v) => setState(() => _hasDrivingLicense = v ?? false),
                title: const Text('Driving License (for sample pickup)'),
                activeColor: AppColors.labColor,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Submit Registration',
                color: AppColors.labColor,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
