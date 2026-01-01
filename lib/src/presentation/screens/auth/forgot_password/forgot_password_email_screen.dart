import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:panimithra/src/presentation/screens/auth/forgot_password/otp_verification_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void submitEmail() {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      "email": emailController.text.trim(),
      "currTime": DateTime.now().toIso8601String(),
    };

    context.read<FetchUsersBloc>().add(
          RequestOtpEvent(body: body),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchUsersBloc, FetchUsersState>(
      listener: (context, state) {
        if (state is RequestOtpSuccess) {
          context.push(AppRoutes.VERIFY_OTP_SCREEN,
              extra: {"emailId": emailController.text.trim()});
          ToastHelper.showToast(
              context: context,
              type: "success",
              title: "Otp Sent Successfully");
        }
        if (state is RequestOtpError) {
          ToastHelper.showToast(
              context: context, type: "error", title: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your registered email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We will send an OTP to this email",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                /// 📧 Email field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                /// 🔘 Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocBuilder<FetchUsersBloc, FetchUsersState>(
                    builder: (context, state) {
                      final isLoading = state is RequestOtpLoading;

                      return ElevatedButton(
                        onPressed: isLoading ? null : submitEmail,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Submit"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
