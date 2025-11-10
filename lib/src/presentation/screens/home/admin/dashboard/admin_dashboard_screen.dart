import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<AdminDashboardScreen> {
  bool isLoading = false;
  int touchedIndex = -1;

  // Static data - Replace with API calls
  final dashboardStats = DashboardStats(
    newUsers: 1250,
    newUsersChange: 5.2,
    employees: 45,
    employeesChange: 2.1,
    completed: 890,
    completedChange: 10.5,
    pending: 120,
    pendingChange: -3.0,
    revenue: 15750,
    revenueChange: 12.6,
  );

  final employeeRegistrations = [
    CityData(city: 'New York', value: 70),
    CityData(city: 'London', value: 85),
    CityData(city: 'Tokyo', value: 75),
    CityData(city: 'Paris', value: 40),
  ];

  final bookingsByCity = [
    CityData(city: 'New York', value: 16),
    CityData(city: 'London', value: 0),
    CityData(city: 'Tokyo', value: 0),
    CityData(city: 'Paris', value: 0),
  ];

  final bookingStatus = BookingStatus(
    total: 1010,
    completed: 75,
    pending: 15,
    cancelled: 10,
  );

  @override
  void initState() {
    super.initState();
    context.read<FetchUsersBloc>().add(const GetAdminDashboardEvent());
    // Call your API here
    // fetchDashboardData();
  }

  // Future<void> fetchDashboardData() async {
  //   setState(() => isLoading = true);
  //   try {
  //     // Your API calls here
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.construction, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FixMate',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.light_mode_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<FetchUsersBloc, FetchUsersState>(
                listener: (context, state) {
                  if (state is AdminDashboardError) {
                    ToastHelper.showToast(
                        context: context, type: 'error', title: state.message);
                  }
                },
                builder: (context, state) {
                  if (state is AdminDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AdminDashboardError) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text(
                            'Error in loading ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is AdminDashboardLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard(
                              'New Users',
                              state.dashboardModel.currentMonthUsers.toString(),
                              differeceCalculator(
                                  state.dashboardModel.currentMonthUsers ?? 0,
                                  state.dashboardModel.previousMonthuser ?? 0),
                              Icons.group_add_outlined,
                              Colors.blue[50]!,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              'Employees',
                              state.dashboardModel.currentMonthEmployees
                                  .toString(),
                              differeceCalculator(
                                  state.dashboardModel.currentMonthEmployees ??
                                      0,
                                  state.dashboardModel.previousMonthEmployees ??
                                      0),
                              Icons.badge_outlined,
                              Colors.blue[50]!,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              'Completed',
                              state.dashboardModel.completedBookings.toString(),
                              differeceCalculator(
                                  state.dashboardModel.completedBookings ?? 0,
                                  state.dashboardModel
                                          .completedBookingsByPreviousMonth ??
                                      0),
                              Icons.check_circle_outline,
                              Colors.grey[100]!,
                              Colors.grey,
                            ),
                            _buildStatCard(
                              'Pending',
                              state.dashboardModel.pendingBookings.toString(),
                              differeceCalculator(
                                  state.dashboardModel.pendingBookings ?? 0,
                                  state.dashboardModel
                                          .pendingdBookingsByPreviouMonth ??
                                      0),
                              Icons.access_time,
                              Colors.orange[50]!,
                              Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Revenue Card
                        _buildRevenueCard(state.dashboardModel.revenue!),
                        const SizedBox(height: 24),

                        // City Analytics
                        const Text(
                          'City Analytics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Employee Registrations Bar Chart
                        _buildEmployeeRegistrationsChart(
                            state.dashboardModel.cityEmployee!),
                        const SizedBox(height: 16),

                        // Bookings by City
                        _buildBookingsByCityChart(
                            state.dashboardModel.cityBookings!),
                        const SizedBox(height: 24),

                        // Booking Status Overview with Pie Chart
                        _buildBookingStatusCard(
                            state.dashboardModel.totalBookings!.toDouble(),
                            state.dashboardModel.totalBookingsPending!
                                .toDouble(),
                            state.dashboardModel.rejectedBookings!.toDouble(),
                            state.dashboardModel.inporgressBookings!.toDouble(),
                            state.dashboardModel.completedBookings!.toDouble(),
                            state.dashboardModel.cancelledBookings!.toDouble()),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    double change,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    final isPositive = change >= 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(double revenue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.attach_money, color: Colors.purple, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${revenue.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              Text(
                '+${dashboardStats.revenueChange.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRegistrationsChart(
    List<City> city,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Employee Registrations by City',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${city[groupIndex].city}\n${rod.toY.toInt()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < city.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              city[value.toInt()].city!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: city.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.count!.toDouble(),
                        color: Colors.blue,
                        width: 40,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsByCityChart(List<City> city) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bookings by City',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < bookingsByCity.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              city[value.toInt()].city!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: city.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.count!.toDouble(),
                        color: Colors.grey[300]!,
                        width: 40,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingStatusCard(double totalBookings, double pendingBookins,
      double rejected, double inprogress, double completed, double cancelled) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Status Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 4,
                      centerSpaceRadius: 80,
                      sections: _getPieChartSections(
                          totalBookings,
                          pendingBookins,
                          rejected,
                          inprogress,
                          completed,
                          cancelled),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        totalBookings.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Bookings',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildLegendItem('Completed',
              calculatePercentage(completed, totalBookings), Colors.green),
          const SizedBox(height: 12),
          _buildLegendItem(
              'Pending',
              calculatePercentage(pendingBookins, totalBookings),
              Colors.orange),
          const SizedBox(height: 12),
          _buildLegendItem('Cancelled',
              calculatePercentage(cancelled, totalBookings), Colors.red),
          const SizedBox(height: 12),
          _buildLegendItem('Rejected',
              calculatePercentage(rejected, totalBookings), Colors.orange),
          const SizedBox(height: 12),
          _buildLegendItem(
              'Inprogress',
              calculatePercentage(inprogress, totalBookings),
              Colors.blueAccent),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(
      double totalBookings,
      double pendingBookins,
      double rejected,
      double inprogress,
      double completed,
      double cancelled) {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: completed.toDouble(),
        title: '',
        radius: touchedIndex == 0 ? 45 : 35,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: pendingBookins.toDouble(),
        title: '',
        radius: touchedIndex == 1 ? 45 : 35,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: cancelled.toDouble(),
        title: '',
        radius: touchedIndex == 2 ? 45 : 35,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.blueAccent,
        value: inprogress.toDouble(),
        title: '',
        radius: touchedIndex == 2 ? 45 : 35,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: rejected.toDouble(),
        title: '',
        radius: touchedIndex == 2 ? 45 : 35,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem(String label, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Text(
          '$percentage%',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Model Classes
class DashboardStats {
  final int newUsers;
  final double newUsersChange;
  final int employees;
  final double employeesChange;
  final int completed;
  final double completedChange;
  final int pending;
  final double pendingChange;
  final double revenue;
  final double revenueChange;

  DashboardStats({
    required this.newUsers,
    required this.newUsersChange,
    required this.employees,
    required this.employeesChange,
    required this.completed,
    required this.completedChange,
    required this.pending,
    required this.pendingChange,
    required this.revenue,
    required this.revenueChange,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      newUsers: json['newUsers'] ?? 0,
      newUsersChange: (json['newUsersChange'] ?? 0).toDouble(),
      employees: json['employees'] ?? 0,
      employeesChange: (json['employeesChange'] ?? 0).toDouble(),
      completed: json['completed'] ?? 0,
      completedChange: (json['completedChange'] ?? 0).toDouble(),
      pending: json['pending'] ?? 0,
      pendingChange: (json['pendingChange'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
      revenueChange: (json['revenueChange'] ?? 0).toDouble(),
    );
  }
}

class CityData {
  final String city;
  final double value;

  CityData({required this.city, required this.value});

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      city: json['city'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}

class BookingStatus {
  final int total;
  final int completed;
  final int pending;
  final int cancelled;

  BookingStatus({
    required this.total,
    required this.completed,
    required this.pending,
    required this.cancelled,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) {
    return BookingStatus(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }
}
