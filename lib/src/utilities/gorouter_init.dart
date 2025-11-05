import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
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
import 'package:panimithra/src/presentation/screens/home/admin/settings/sub_category_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/subscription_plan_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/my_services/create_service.dart';
import 'package:panimithra/src/presentation/screens/home/employee/my_services/my_services_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/payments/checkout_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/payments/plans_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/dashboard/pre_booking_screen.dart';
import 'package:panimithra/src/presentation/screens/home_screen.dart';
import 'package:panimithra/src/presentation/screens/splash/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const ErrorScreen(),
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
  ],
  redirect: (context, state) {
    return null;
  },
  debugLogDiagnostics: true,
);
