import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/injection.dart' as di;
import 'package:panimithra/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:panimithra/src/presentation/screens/auth/forgot_password/forgot_password_email_screen.dart';
import 'package:panimithra/src/presentation/screens/auth/forgot_password/otp_verification_screen.dart';
import 'package:panimithra/src/presentation/screens/auth/forgot_password/reset_password_screen.dart';
import 'package:panimithra/src/presentation/screens/auth/login_screen.dart';
import 'package:panimithra/src/presentation/screens/auth/provider_registration/provider_account_info.dart';
import 'package:panimithra/src/presentation/screens/auth/provider_registration/provider_address_info.dart';
import 'package:panimithra/src/presentation/screens/auth/provider_registration/provider_base_info.dart';
import 'package:panimithra/src/presentation/screens/auth/provider_registration/provider_service_info.dart';
import 'package:panimithra/src/presentation/screens/auth/user_registration/user_registration_screen.dart';
import 'package:panimithra/src/presentation/screens/auth/welcome_screen.dart';
import 'package:panimithra/src/presentation/screens/error/error_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/category_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/create_category_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/create_subcategory_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/create_subcripion_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/edit_category_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/edit_plan_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/edit_subcategory_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/sub_category_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/subscription_plan_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/bookings/booking_details_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/my_services/create_service.dart';
import 'package:panimithra/src/presentation/screens/home/employee/my_services/edit_service_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/payments/checkout_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/payments/plans_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/bookings/user_booking_details_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/dashboard/pre_booking_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/dashboard/reviews_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/profile/about_us_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/profile/faq_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/profile/help_and_support.dart';
import 'package:panimithra/src/presentation/screens/home/user/profile/reset_password_screen.dart';
import 'package:panimithra/src/presentation/screens/home_screen.dart';
import 'package:panimithra/src/presentation/screens/splash/splash_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(di.sl<AuthenticatorWatcherBloc>().stream),
  errorBuilder: (context, state) => const ErrorScreen(),
  redirect: (context, state) {
    final authBloc = di.sl<AuthenticatorWatcherBloc>();
    final authState = authBloc.state;

    final bool isAuthenticated = authState.isAuthenticated;
    final bool isSessionExpired = authState.isSessionExpired;

    final String loginLocation = AppRoutes.LOGIN_ROUTE_PATH;
    final String homeLocation = AppRoutes.HOME_SCREEN_PATH;
    final String welcomeLocation = AppRoutes.WELCOME_ROUTE_PATH;

    final bool isLoggingIn = state.matchedLocation == loginLocation;
    final bool isWelcomeScreen = state.matchedLocation == welcomeLocation;
    final bool isSplashScreen = state.matchedLocation == '/';
    
    // Auth routes that are allowed when unauthenticated
    final bool isAuthRoute = isLoggingIn || isWelcomeScreen || isSplashScreen ||
        state.matchedLocation == AppRoutes.USER_REGISTRATION_PATH ||
        state.matchedLocation == AppRoutes.PROVIDER_BASE_REGISTRATION_PATH ||
        state.matchedLocation == AppRoutes.PROVIDER_ADDRESS_REGISTRATION_PATH ||
        state.matchedLocation == AppRoutes.PROVIDER_SERVICE_REGISTRATION_PATH ||
        state.matchedLocation == AppRoutes.PROVIDER_ACCOUNT_REGISTRATION_PATH ||
        state.matchedLocation == AppRoutes.FORGOT_PASSWORD_EMAIL ||
        state.matchedLocation == AppRoutes.VERIFY_OTP_SCREEN ||
        state.matchedLocation == AppRoutes.RESET_BEFORE_AUTH;

    // 1. Session Expired logic (MANDATORY)
    if (isSessionExpired && !isLoggingIn) {
      return '$loginLocation?reason=sessionExpired';
    }

    // 2. Unauthenticated user
    if (!isAuthenticated && !isAuthRoute) {
      return welcomeLocation;
    }

    // 3. Authenticated user trying to access auth pages
    if (isAuthenticated && isAuthRoute && !isSplashScreen) {
      return homeLocation;
    }

    return null; // No redirect needed
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: AppRoutes.WELCOME_ROUTE_PATH,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.LOGIN_ROUTE_PATH,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.PROVIDER_BASE_REGISTRATION_PATH,
      builder: (context, state) => const ProviderBaseRegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.PROVIDER_ADDRESS_REGISTRATION_PATH,
      builder: (context, state) => const AddressDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.PROVIDER_SERVICE_REGISTRATION_PATH,
      builder: (context, state) => const ServiceInformationScreen(),
    ),
    GoRoute(
      path: AppRoutes.PROVIDER_ACCOUNT_REGISTRATION_PATH,
      builder: (context, state) => const AccountInformationScreen(),
    ),
    GoRoute(
      path: AppRoutes.USER_REGISTRATION_PATH,
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: AppRoutes.HOME_SCREEN_PATH,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.CATEGORIES_PATH,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: AppRoutes.CREATE_CATEGORY_PATH,
      builder: (context, state) => const CreateCategoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.CREATE_SERVICE_PATH,
      builder: (context, state) => const CreateServiceScreen(),
    ),
    GoRoute(
      path: AppRoutes.SUBSCRIPTION_PLAN_SCREEN_PATH,
      builder: (context, state) => const SubscriptionPlansScreen(),
    ),
    GoRoute(
      path: AppRoutes.CREATE_SUBSCRIPTION_PLAN_SCREEN_PATH,
      builder: (context, state) => const CreateSubscriptionPlanScreen(),
    ),
    GoRoute(
      path: AppRoutes.EMPLOYEE_PLANS_SCREEN_PATH,
      builder: (context, state) => const MyPlansScreen(),
    ),
    GoRoute(
      path: AppRoutes.USER_REVIEW_SCREEN,
      builder: (context, state) {
        final serviceId = state.extra is Map
            ? (state.extra as Map)['serviceId'] as String? ?? ''
            : '';
        return ReviewsScreen(
          serviceId: serviceId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.EMPLOYEE_BOOKING_DETAILS_SCREEN_PATH,
      builder: (context, state) {
        final bookingId = state.extra is Map
            ? (state.extra as Map)['bookingId'] as String? ?? ''
            : '';
        return EmployeeBookingDetailsScreen(
          bookingId: bookingId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.UserBookingDetailsScreen,
      builder: (context, state) {
        final bookingId = state.extra is Map
            ? (state.extra as Map)['bookingId'] as String? ?? ''
            : '';
        return UserBookingDetailsScreen(
          bookingId: bookingId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.EDIT_SERVICE_SCREEN_PATH,
      builder: (context, state) {
        final serviceId = state.extra is Map
            ? (state.extra as Map)['serviceId'] as String? ?? ''
            : '';
        return EditServiceScreen(
          serviceId: serviceId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.CHECKOUT_SCREEN_PATH,
      builder: (context, state) {
        final planId = state.extra is Map
            ? (state.extra as Map)['planId'] as String? ?? ''
            : '';
        final planName = state.extra is Map
            ? (state.extra as Map)['planName'] as String? ?? ''
            : '';
        final price = state.extra is Map
            ? (state.extra as Map)['price'] as double? ?? 0.0
            : 0.0;
        return CheckoutScreen(
          plnaid: planId,
          price: price,
          planName: planName,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.SUB_CATEGORY_PATH,
      builder: (context, state) {
        final categoryId = state.extra is Map
            ? (state.extra as Map)['categoryId'] as String? ?? ''
            : '';
        final categoryName = state.extra is Map
            ? (state.extra as Map)['categoryName'] as String? ?? ''
            : '';
        return SubcategoriesScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.CREATE_SUBCATEGORY_PATH,
      builder: (context, state) {
        final categoryId = state.extra is Map
            ? (state.extra as Map)['categoryId'] as String? ?? ''
            : '';
        return CreateSubCategoryScreen(
          categoryId: categoryId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.PREBOOKING_SCREEN_PATH,
      builder: (context, state) {
        final serviceId = state.extra is Map
            ? (state.extra as Map)['serviceId'] as String? ?? ''
            : '';
        return PreBookingScreen(
          serviceId: serviceId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.EDIT_CATEGORY_SCREEN_PATH,
      builder: (context, state) {
        final categoryId = state.extra is Map
            ? (state.extra as Map)['categoryId'] as String? ?? ''
            : '';
        return EditCategoryScreen(
          categoryId: categoryId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.EDIT_SUBCATEGORY_SCREEN_PATH,
      builder: (context, state) {
        final categoryId = state.extra is Map
            ? (state.extra as Map)['categoryId'] as String? ?? ''
            : '';
        final subCategoryId = state.extra is Map
            ? (state.extra as Map)['subCategoryId'] as String? ?? ''
            : '';
        return EditSubcategoryScreen(
          categoryId: categoryId,
          subCategoryId: subCategoryId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.EDIT_PLAN_SCREEN_PATH,
      builder: (context, state) {
        final planId = state.extra is Map
            ? (state.extra as Map)['planId'] as String? ?? ''
            : '';

        return EditPlanScreen(planId: planId);
      },
    ),
    GoRoute(
      path: AppRoutes.HELP_SUPPORT_SCREEN_PATH,
      builder: (context, state) {
        return HelpSupportScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.FAQ_SCREEN_PATH,
      builder: (context, state) {
        return FaqScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.RESET_PASSWORD_SCREEN,
      builder: (context, state) {
        return ChangePasswordScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.ABOUT_US_SCREEN_PATH,
      builder: (context, state) {
        return AboutUsScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.FORGOT_PASSWORD_EMAIL,
      builder: (context, state) {
        return ForgotPasswordEmailScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.RESET_BEFORE_AUTH,
      builder: (context, state) {
        final emailId = state.extra is Map
            ? (state.extra as Map)['emailId'] as String? ?? ''
            : '';
        return ResetPasswordScreen(
          emailId: emailId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.VERIFY_OTP_SCREEN,
      builder: (context, state) {
        final emailId = state.extra is Map
            ? (state.extra as Map)['emailId'] as String? ?? ''
            : '';
        return OtpVerificationScreen(
          email: emailId,
        );
      },
    ),
  ],
  
  debugLogDiagnostics: true,
);
