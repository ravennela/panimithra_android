import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/provider_registration_cubit.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Steps Progress
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                      buildProgressStep(isActive: true, isCompleted: true),
                      buildProgressLine(isActive: false, width: 40),
                      buildProgressStep(isActive: false, isCompleted: false),
                      buildProgressLine(isActive: false, width: 40),
                      buildProgressStep(isActive: false, isCompleted: false),
                      buildProgressLine(isActive: false, width: 40),
                      buildProgressStep(isActive: false, isCompleted: false),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Card Container
                const Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your personal details to create a provider account.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),

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
                    children: [
                      // Full Name
                      _buildTextField(
                          label: "Full Name",
                          hint: "Enter your full name",
                          icon: Icons.person_outline_rounded,
                          controller: _fullNameController,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),

                      // Email
                      _buildTextField(
                        label: "Email",
                        icon: Icons.email_outlined,
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
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),

                      // Mobile Number
                      _buildTextField(
                        label: "Mobile Number",
                        hint: "Enter your mobile number",
                        icon: Icons.phone_outlined,
                        controller: _mobileController,
                        isRequired: true,
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
                      const SizedBox(height: 20),

                      // Alternate Number
                      _buildTextField(
                        label: "Alternate Number",
                        hint: "Enter alternate number",
                        icon: Icons.phone_iphone_rounded,
                        controller: _alternateController,
                        keyboardType: TextInputType.phone,
                        isRequired: false,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final mobileRegex = RegExp(r'^[0-9]{10}$');
                            if (!mobileRegex.hasMatch(value)) {
                              return 'Please enter a valid 10-digit number';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Gender
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Gender",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              Text(' *',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF64748B)),
                            decoration: _inputDecoration("Select your gender",
                                icon: Icons.wc_outlined),
                            items: const [
                              DropdownMenuItem(
                                  value: "Male",
                                  child: Text("Male",
                                      style: TextStyle(fontSize: 15))),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text("Female",
                                    style: TextStyle(fontSize: 15)),
                              ),
                              DropdownMenuItem(
                                value: "Other",
                                child: Text("Other",
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ],
                            onChanged: (value) => setState(() {
                              _selectedGender = value;
                            }),
                            validator: (value) =>
                                value == null ? 'Please Select Gender' : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Date of Birth
                      _buildDatePickerField(),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Next button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      if (selectedDate == null) {
                        ToastHelper.showToast(
                          context: context,
                          type: 'error',
                          title: "Please Select Date of Birth",
                        );
                        return;
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
                      "Next Step",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
    required IconData icon,
    String? Function(String?)? validator,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            if (!isRequired)
              const Text(' (Optional)',
                  style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B)),
          decoration: _inputDecoration(hint, icon: icon),
        ),
      ],
    );
  }

  // Date of Birth picker
  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "Date of Birth",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            Text(' *',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
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
          child: IgnorePointer(
            child: TextFormField(
              controller: _dobController,
              readOnly: true,
              validator: (val) =>
                  val == null || val.isEmpty ? "Please enter DOB" : null,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B)),
              decoration: _inputDecoration("mm/dd/yyyy",
                      icon: Icons.calendar_month_rounded)
                  .copyWith(
                suffixIcon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Common Input Decoration
  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      prefixIcon: icon != null
          ? Icon(icon, color: const Color(0xFF94A3B8), size: 20)
          : null,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 15,
        fontWeight: FontWeight.normal,
      ),
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
