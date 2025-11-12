import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/provider_registration_cubit.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

import '../../../../common/toast.dart';

class ProviderBaseRegistrationScreen extends StatefulWidget {
  const ProviderBaseRegistrationScreen({super.key});

  @override
  State<ProviderBaseRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderBaseRegistrationScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alternateController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(child: Container()),
                    const Center(
                      child: Text(
                        "Provider Registration",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                const SizedBox(height: 16),

                // Step progress
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      buildProgressStep(isActive: true, isCompleted: true),
                      buildProgressLine(isActive: false),
                      buildProgressStep(isActive: true, isCompleted: false),
                      buildProgressLine(isActive: false),
                      buildProgressStep(isActive: false, isCompleted: false),
                      buildProgressLine(isActive: false),
                      buildProgressStep(isActive: false, isCompleted: false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Card Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                      const Text(
                        "Basic Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      _buildTextField(
                        label: "Full Name",
                        hint: "Enter your full name",
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildTextField(
                        label: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        hint: "Enter your email address",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Mobile Number
                      _buildTextField(
                        label: "Mobile Number",
                        hint: "Enter your mobile number",
                        controller: _mobileController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          // Basic Indian mobile validation — 10 digits only
                          final mobileRegex = RegExp(r'^[0-9]{10}$');
                          if (!mobileRegex.hasMatch(value)) {
                            return 'Please enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Alternate Number
                      _buildTextField(
                        label: "Alternate Number (Optional)",
                        hint: "Enter alternate number",
                        controller: _alternateController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Gender
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: _inputDecoration("Select your gender"),
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),
                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female"),
                          ),
                          DropdownMenuItem(
                            value: "Other",
                            child: Text("Other"),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _selectedGender = value;
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      _buildDatePickerField(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Next button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (_fullNameController.text.isEmpty) {
                        ToastHelper.showToast(
                          context: context,
                          type: 'error',
                          title: "Please Enter Full Name",
                        );
                        return;
                      }
                      if (_emailController.text.isEmpty) {
                        ToastHelper.showToast(
                          context: context,
                          type: 'error',
                          title: "Please Enter Email Id",
                        );
                        return;
                      }
                      if (_mobileController.text.isEmpty) {
                        ToastHelper.showToast(
                          context: context,
                          type: 'error',
                          title: "Please Enter Mobile Number",
                        );
                        return;
                      }
                      if (_selectedGender == null) {
                        ToastHelper.showToast(
                          context: context,
                          type: 'error',
                          title: "Please Select Gender",
                        );
                        return;
                      }
                      if (selectedDate == null) {
                        ToastHelper.showToast(
                          context: context,
                          type: 'error',
                          title: "Please Select Date of Birth",
                        );
                      }
                      context.read<ProviderRegistrationCubit>().addBaseInfo(
                            _fullNameController.text,
                            _emailController.text,
                            _mobileController.text,
                            _alternateController.text,
                            _selectedGender.toString(),
                            selectedDate!,
                          );
                      context.push(
                        AppRoutes.PROVIDER_ADDRESS_REGISTRATION_PATH,
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text field builder
  Widget _buildTextField({
    required String label,
    required String hint,
    String? Function(String?)? validator,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  // Date of Birth picker
  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date of Birth",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _dobController,
          readOnly: true,
          decoration: _inputDecoration("mm/dd/yyyy").copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  selectedDate = pickedDate;
                  setState(() {
                    _dobController.text =
                        "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Common Input Decoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF6F6F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8D8DD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB)),
      ),
    );
  }
}
