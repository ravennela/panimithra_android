import 'package:flutter/material.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/presentation/screens/custom_navbar.dart';
import 'package:panimithra/src/presentation/screens/home/admin/bookings/admin_booking_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/dashboard/admin_dashboard_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/employees/employee_list_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/settings/profile_screen.dart';
import 'package:panimithra/src/presentation/screens/home/admin/users/users_list_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/bookings/my_booking_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/home/employee_dashboard_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/my_services/my_services_screen.dart';
import 'package:panimithra/src/presentation/screens/home/employee/payments/payments_screen.dart';

import 'package:panimithra/src/presentation/screens/home/test_screen.dart'
    hide BookingCard;
import 'package:panimithra/src/presentation/screens/home/user/bookings/bookings_screen.dart'
    hide BookingCard;
import 'package:panimithra/src/presentation/screens/home/user/dashboard/home_screen.dart';
import 'package:panimithra/src/presentation/screens/home/user/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String role = "";
  bool isLoading = true;

  // For Director (5 screens)
  final List<Widget> _adminScreens = [
    const AdminDashboardScreen(), // Index 0
    const CustomerScreen(), // Index 1
    const EmployeesScreen(),
    const AdminBookingsScreen(), // Index 3 - was ChangePasswordScreen
    const ProfileSettingsScreen() // Index 4
  ];

  // For Site Manager (3 screens)
  final List<Widget> employeeScreens = [
    const EmployeeDashboard(), // Index 0
    const MyBookingsScreen(), // Index 1
    const SubscriptionScreen(),

    const MyServicesScreen(),
    const UserProfileScreen()

// Index 2
  ];

  final List<Widget> userScreens = [
    const FindServicesScreen(), // Index 0
    const BookingsScreen(), // Index 1

    const UserProfileScreen(),
    Center(
      child: Text("Test"),
    )
// Index 2
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString(ApiConstants.role) ?? "";
      isLoading = false;
    });
    print("Loaded role: '$role'"); // Debug print with quotes
    print("Role length: ${role.length}"); // Check for hidden characters
    print("Normalized role: '${role.toLowerCase()}'");
  }

  void _onItemTapped(int index) async {
    // Get the appropriate screen list based on role
    List<Widget> currentScreens = _getCurrentScreens();

    // Ensure index is within bounds
    if (index >= 0 && index < currentScreens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  List<Widget> _getCurrentScreens() {
    if (role == 'ADMIN') {
      return _adminScreens;
    } else if (role == 'USER') {
      return userScreens;
    } else if (role == "EMPLOYEE") {
      return employeeScreens;
    } else {
      // Default fallback
      return [const Center(child: Text('Home'))];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    List<Widget> currentScreens = _getCurrentScreens();

    // Ensure selectedIndex is within bounds
    if (_selectedIndex >= currentScreens.length) {
      _selectedIndex = 0;
    }
    return Scaffold(
      body: currentScreens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          userRole: role,
        ),
      ),
    );
  }
}
