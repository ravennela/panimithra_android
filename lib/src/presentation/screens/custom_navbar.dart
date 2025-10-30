import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String userRole;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 63,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: _getNavItems(),
      ),
    );
  }

  List<Widget> _getNavItems() {
    if (userRole == 'ADMIN') {
      // Director navigation items - 5 tabs
      return [
        _buildNavItem(
          icon: Icons.home_outlined,
          label: 'Dashboard',
          index: 0,
        ),
        _buildNavItem(
          icon: Icons.person_2_outlined,
          label: 'Users',
          index: 1,
        ),
        _buildNavItem(
          icon: Icons.add_box_rounded,
          label: 'Employees',
          index: 2,
        ),
        _buildNavItem(
          icon: Icons.calendar_view_day_outlined,
          label: 'Bookings',
          index: 3,
        ),
        _buildNavItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          index: 4,
        ),
      ];
    } else if (userRole == 'EMPLOYEE') {
      // Site Manager navigation items - 3 tabs
      return [
        _buildNavItem(
          icon: Icons.home_outlined,
          label: 'Home',
          index: 0,
        ),
        _buildNavItem(
          icon: Icons.book_online,
          label: 'Bookings',
          index: 1,
        ),
        _buildNavItem(
          icon: Icons.payment,
          label: 'Payments',
          index: 2,
        ),
        _buildNavItem(
          icon: Icons.local_shipping_outlined,
          label: 'My Service',
          index: 3,
        ),
        
        _buildNavItem(
          icon: Icons.settings,
          label: 'Profile',
          index: 4,
        ),
      ];
    } else if (userRole == 'USER') {
      return [
        _buildNavItem(
          icon: Icons.home_outlined,
          label: 'Home',
          index: 0,
        ),
        _buildNavItem(
          icon: Icons.business_outlined,
          label: 'Sites',
          index: 1,
        ),
        _buildNavItem(
          icon: Icons.insert_chart_outlined,
          label: 'Reports',
          index: 2,
        ),
        _buildNavItem(
          icon: Icons.local_shipping_outlined,
          label: 'Inventory',
          index: 3,
        ),
        _buildNavItem(
          icon: Icons.apps_outlined,
          label: 'More',
          index: 4,
        ),
      ];
    } else {
      // Default fallback - show at least Home
      return [
        _buildNavItem(
          icon: Icons.home_outlined,
          label: 'Home',
          index: 0,
        ),
      ];
    }
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          height: 63,
          decoration: isSelected
              ? const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 110, 199, 0.4),
                      Color.fromRGBO(255, 255, 255, 0),
                    ],
                    stops: [0.0, 1.0],
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF006EC7),
                      width: 2,
                    ),
                  ),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? const Color(0xFF006EC7)
                    : const Color(0xFF666666),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF006EC7)
                      : const Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
