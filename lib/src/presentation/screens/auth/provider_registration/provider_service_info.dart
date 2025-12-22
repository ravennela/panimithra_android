import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/routes.dart';
import '../../../cubit/provider_registration/provider_registration_cubit.dart';
import '../../../widget/helper.dart';

class ServiceInformationScreen extends StatefulWidget {
  const ServiceInformationScreen({super.key});

  @override
  State<ServiceInformationScreen> createState() =>
      _ServiceInformationScreenState();
}

class _ServiceInformationScreenState extends State<ServiceInformationScreen> {
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _selectedServiceCategory;

  final List<String> _serviceCategories = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Painting',
    'Cleaning',
    'Appliance Repair',
    'HVAC',
    'Pest Control',
    'Landscaping',
    'Home Renovation',
    'Interior Design',
    'Moving Services',
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _yearsController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Provider Registration',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Steps Progress
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildProgressStep(
                                isActive: true, isCompleted: true),
                            buildProgressLine(isActive: true, width: 40),
                            buildProgressStep(
                                isActive: true, isCompleted: true),
                            buildProgressLine(isActive: true, width: 40),
                            buildProgressStep(
                                isActive: true, isCompleted: true),
                            buildProgressLine(isActive: false, width: 40),
                            buildProgressStep(
                                isActive: false, isCompleted: false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title Section
                      const Text(
                        'Professional Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Tell us about your expertise to help us match you with the right jobs.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Primary Service Category Dropdown
                            _buildLabel('Primary Service Category',
                                isRequired: true),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedServiceCategory,
                              decoration: _inputDecoration(
                                  hint: 'Select specialize in',
                                  icon: Icons.category_rounded),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF64748B),
                              ),
                              items: _serviceCategories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category,
                                      style: const TextStyle(fontSize: 15)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedServiceCategory = newValue;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select a specialization'
                                  : null,
                            ),
                            const SizedBox(height: 24),

                            // Years of Experience Field
                            _buildLabel('Years of Experience',
                                isRequired: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _yearsController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B)),
                              decoration: _inputDecoration(
                                  hint: 'Enter number of years',
                                  icon: Icons.work_history_rounded),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter years of experience';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Short Description/Bio Field
                            _buildLabel('Short Bio', isRequired: false),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _bioController,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B)),
                              decoration: _inputDecoration(
                                hint: 'Tell us a bit about your services...',
                                icon: Icons.description_rounded,
                              ).copyWith(
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          context.read<ProviderRegistrationCubit>().serviceInfo(
                                _selectedServiceCategory.toString(),
                                int.tryParse(_yearsController.text) ?? 0,
                                _bioController.text,
                              );

                          context.push(
                            AppRoutes.PROVIDER_ACCOUNT_REGISTRATION_PATH,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                        ),
                        child: const Text(
                          'Next Step',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        if (isRequired) ...[
          const Text(' *',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.bold)),
        ] else ...[
          const SizedBox(width: 4),
          const Text(
            '(Optional)',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 15,
        fontWeight: FontWeight.normal,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade200),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
    );
  }
}
