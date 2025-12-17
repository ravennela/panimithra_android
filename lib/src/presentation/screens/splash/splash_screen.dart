import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/constant.dart';
import 'package:panimithra/src/common/images.dart';
import 'package:panimithra/src/common/routes.dart' show AppRoutes;
import 'package:panimithra/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Future.microtask(
        () => context.read<AuthenticatorWatcherBloc>().add(
              const AuthenticatorWatcherAuthCheckRequest(),
            ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticatorWatcherBloc, AuthenticatorWatcherState>(
      listener: (context, state) {
        print("status value" + state.toString());
        if (state is AuthenticatorWatcherAuthenticated) {
          context.go(AppRoutes.HOME_SCREEN_PATH);
        } else if (state is AuthenticatorWatcherUnauthenticated) {
          context.go(AppRoutes.WELCOME_ROUTE_PATH);
        } else if (state is AuthenticatorWatcherIsFirstTime && mounted) {
          context.go(AppRoutes.WELCOME_ROUTE_PATH);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Image.asset(
                            key: Key("splash_logo"),
                            Images.SPLASH_LOGO,
                            height: 300,
                            width: 300,
                          ),
                          SizedBox(height: SPACE12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
