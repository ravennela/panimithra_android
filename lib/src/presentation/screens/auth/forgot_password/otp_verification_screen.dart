import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:panimithra/l10n/app_localizations.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  void verifyOtp() {
    final otp = otpController.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.enterValidOtp)),
      );
      return;
    }

    final body = {
      "emailId": widget.email,
      "otp": otp,
    };

    context.read<FetchUsersBloc>().add(
          VerifyOtpEvent(body: body),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchUsersBloc, FetchUsersState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
         

          context.push(AppRoutes.RESET_BEFORE_AUTH,
              extra: {"emailId": widget.email});
          ToastHelper.showToast(
              context: context,
              type: "success",
              title: AppLocalizations.of(context)!.otpVerified);
        }

        if (state is VerifyOtpError) {
          ToastHelper.showToast(
              context: context, type: "error", title: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.verifyOtp)),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context)!.otpSentTo} ${widget.email}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),

              /// 🔢 OTP Field
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterOtp,
                  border: const OutlineInputBorder(),
                  counterText: "",
                ),
              ),

              const SizedBox(height: 30),

              /// 🔘 Verify Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocBuilder<FetchUsersBloc, FetchUsersState>(
                  builder: (context, state) {
                    final isLoading = state is VerifyOtpLoading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : verifyOtp,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(AppLocalizations.of(context)!.verify),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
