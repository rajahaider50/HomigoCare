import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_database_service.dart';
import '../../models/doctor_model.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({super.key});

  @override
  State<DoctorRegistrationScreen> createState() => _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  final _dbService = FirebaseDatabaseService();

  // Step 1: Personal
  final _councilRegController = TextEditingController();
  String _selectedSpecialization = 'General Physician';
  final _experienceController = TextEditingController();
  final _feeController = TextEditingController();
  final _bioController = TextEditingController();

  // Step 2: Availability
  List<String> _selectedDays = [];
  String _timeFrom = '09:00';
  String _timeTo = '17:00';

  // Step 3: MCQ
  Map<int, int> _answers = {};

  // Step 4: Documents
  bool _hasDrivingLicense = false;
  bool _hasMedicalDegree = false;
  bool _hasNmcCert = false;

  final List<String> _specializations = [
    'General Physician', 'Cardiologist', 'Dermatologist', 'ENT Specialist',
    'Gynecologist', 'Neurologist', 'Oncologist', 'Ophthalmologist',
    'Orthopedic', 'Pediatrician', 'Psychiatrist', 'Radiologist',
    'Surgeon', 'Urologist', 'Other',
  ];

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  final List<Map<String, dynamic>> _mcqQuestions = [
    {
      'question': 'What is the normal resting heart rate for adults?',
      'options': ['40-60 bpm', '60-100 bpm', '100-120 bpm', '120-140 bpm'],
      'correct': 1,
    },
    {
      'question': 'Which vitamin is primarily obtained from sunlight?',
      'options': ['Vitamin A', 'Vitamin B', 'Vitamin C', 'Vitamin D'],
      'correct': 3,
    },
    {
      'question': 'What is the largest organ in the human body?',
      'options': ['Heart', 'Liver', 'Skin', 'Brain'],
      'correct': 2,
    },
    {
      'question': 'How many bones does an adult human body have?',
      'options': ['186', '196', '206', '216'],
      'correct': 2,
    },
    {
      'question': 'What is the normal blood pressure reading?',
      'options': ['90/60 mmHg', '120/80 mmHg', '140/90 mmHg', '160/100 mmHg'],
      'correct': 1,
    },
    {
      'question': 'Which organ filters blood in the human body?',
      'options': ['Heart', 'Lungs', 'Kidneys', 'Liver'],
      'correct': 2,
    },
    {
      'question': 'What does RBC stand for?',
      'options': ['Red Blood Cell', 'Red Body Cell', 'Rare Blood Cell', 'Rapid Blood Cell'],
      'correct': 0,
    },
    {
      'question': 'Which blood group is the universal donor?',
      'options': ['A+', 'B+', 'AB+', 'O-'],
      'correct': 3,
    },
    {
      'question': 'What is the normal body temperature?',
      'options': ['96.8°F', '97.8°F', '98.6°F', '99.6°F'],
      'correct': 2,
    },
    {
      'question': 'Which type of white blood cell fights parasites?',
      'options': ['Neutrophils', 'Lymphocytes', 'Eosinophils', 'Monocytes'],
      'correct': 2,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _councilRegController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitRegistration();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_councilRegController.text.isEmpty) {
          _showError('Medical Council Registration is required');
          return false;
        }
        if (_experienceController.text.isEmpty) {
          _showError('Experience is required');
          return false;
        }
        if (_feeController.text.isEmpty) {
          _showError('Consultation fee is required');
          return false;
        }
        return true;
      case 1:
        if (_selectedDays.isEmpty) {
          _showError('Select at least one available day');
          return false;
        }
        return true;
      case 2:
        int correct = 0;
        _answers.forEach((qIndex, answerIndex) {
          if (answerIndex == _mcqQuestions[qIndex]['correct']) correct++;
        });
        double percentage = (correct / _mcqQuestions.length) * 100;
        if (percentage < 70) {
          _showError('You need 70% to pass. You got ${percentage.toInt()}%');
          return false;
        }
        return true;
      case 3:
        if (!_hasMedicalDegree) {
          _showError('Medical degree is required');
          return false;
        }
        if (!_hasNmcCert) {
          _showError('NMC certificate is required');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _submitRegistration() async {
    final auth = context.read<AuthProvider>();
    final user = auth.userModel;
    if (user == null) return;

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final doctor = DoctorModel(
      uid: user.uid,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      specialization: _selectedSpecialization,
      experience: int.tryParse(_experienceController.text) ?? 0,
      consultationFee: double.tryParse(_feeController.text) ?? 0,
      bio: _bioController.text,
      medicalCouncilReg: _councilRegController.text,
      availableDays: _selectedDays,
      availableTimeFrom: _timeFrom,
      availableTimeTo: _timeTo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _dbService.createDoctor(doctor);

    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss loading
    Navigator.pushReplacementNamed(context, '/doctor-pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Registration'),
        leading: _currentStep > 0
            ? IconButton(onPressed: _prevStep, icon: const Icon(Icons.arrow_back))
            : null,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfoStep(),
                _buildAvailabilityStep(),
                _buildMCQStep(),
                _buildVerificationStep(),
              ],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Personal', 'Availability', 'MCQ Test', 'Verification'];
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index <= _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isActive ? AppColors.primary : AppColors.border,
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? AppColors.primary : AppColors.border,
                      ),
                      child: Center(
                        child: isCurrent
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < _currentStep ? AppColors.primary : AppColors.border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Professional Information', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dark)),
          const SizedBox(height: 8),
          Text('Provide your medical credentials', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          CustomTextField(
            label: AppStrings.medicalCouncilReg,
            hint: 'Enter registration number',
            controller: _councilRegController,
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedSpecialization,
            decoration: const InputDecoration(labelText: 'Specialization', border: OutlineInputBorder()),
            items: _specializations.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _selectedSpecialization = v ?? _selectedSpecialization),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.experience,
            hint: 'Years of experience',
            controller: _experienceController,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.work_outline),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.consultationFee,
            hint: 'Fee in PKR',
            controller: _feeController,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.attach_money),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.bio,
            hint: 'Tell patients about yourself',
            controller: _bioController,
            maxLines: 3,
            prefixIcon: const Icon(Icons.description_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Availability', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Set your available days and time', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Text('Available Days', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _days.map((day) {
              final selected = _selectedDays.contains(day);
              return FilterChip(
                label: Text(day.substring(0, 3)),
                selected: selected,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(color: selected ? Colors.white : AppColors.dark),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'From',
                  hint: '09:00',
                  readOnly: true,
                  onTap: () => _pickTime(isFrom: true),
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'To',
                  hint: '17:00',
                  readOnly: true,
                  onTap: () => _pickTime(isFrom: false),
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime({required bool isFrom}) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: isFrom ? 9 : 17, minute: 0),
    );
    if (time != null) {
      final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isFrom) {
          _timeFrom = formatted;
        } else {
          _timeTo = formatted;
        }
      });
    }
  }

  Widget _buildMCQStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz, color: AppColors.accent, size: 28),
              const SizedBox(width: 8),
              Text('MCQ Test', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Answer all questions. Passing: 70%', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          ...List.generate(_mcqQuestions.length, (index) {
            final q = _mcqQuestions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}. ${q['question']}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(q['options'].length, (optIndex) {
                    return RadioListTile<int>(
                      value: optIndex,
                      groupValue: _answers[index],
                      onChanged: (val) {
                        setState(() => _answers[index] = val!);
                      },
                      title: Text(q['options'][optIndex], style: GoogleFonts.poppins(fontSize: 13)),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVerificationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user, color: AppColors.primary, size: 48),
          const SizedBox(height: 16),
          Text('Document Verification', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Upload required documents for verification', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          _buildDocumentCheck('Driving License (for Home Visit)', _hasDrivingLicense, (v) => setState(() => _hasDrivingLicense = v)),
          _buildDocumentCheck('Medical Degree Certificate', _hasMedicalDegree, (v) => setState(() => _hasMedicalDegree = v)),
          _buildDocumentCheck('NMC Certificate', _hasNmcCert, (v) => setState(() => _hasNmcCert = v)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your documents will be reviewed by admin. You can start after verification.',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCheck(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: CustomButton(
        text: _currentStep == 3 ? 'Submit Registration' : 'Next',
        onPressed: _nextStep,
      ),
    );
  }
}
