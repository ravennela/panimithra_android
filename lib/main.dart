import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/injection.dart' as di;

import 'package:panimithra/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/provider_registration_cubit.dart';
import 'package:panimithra/src/utilities/gorouter_init.dart';
import 'src/presentation/bloc/login/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => di.sl<LoginBloc>(),
        ),
        BlocProvider(create: (_) => di.sl<ProviderRegistrationCubit>()),
        BlocProvider<ProviderRegistrationBloc>(
            create: (_) => di.sl<ProviderRegistrationBloc>()),
        BlocProvider<AuthenticatorWatcherBloc>(
            create: (_) => di.sl<AuthenticatorWatcherBloc>()),
        BlocProvider<CategoriesBloc>(create: (_) => di.sl<CategoriesBloc>()),
        BlocProvider<SubcategoryBloc>(create: (_) => di.sl<SubcategoryBloc>()),
        BlocProvider<ServiceBloc>(create: (_) => di.sl<ServiceBloc>()),
        BlocProvider<PlanBloc>(create: (_) => di.sl<PlanBloc>()),
        BlocProvider<FetchUsersBloc>(create: (_) => di.sl<FetchUsersBloc>()),
        BlocProvider<EmployeePaymentBloc>(
            create: (_) => di.sl<EmployeePaymentBloc>()),
        BlocProvider<BookingBloc>(create: (_) => di.sl<BookingBloc>())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Marble Tech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: router,
    );
  }
}
