import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  bool isLoading = false;
  int touchedIndex = -1;

  // Static data - Replace with API calls
  final employeeStats = EmployeeStats(
    totalAssigned: 124,
    inProgress: 5,
    completed: 78,
    monthlyEarnings: 3450,
  );

  final monthlyEarningsData = [
    MonthlyData(month: 'Jan', earnings: 2800),
    MonthlyData(month: 'Feb', earnings: 3200),
    MonthlyData(month: 'Mar', earnings: 2900),
    MonthlyData(month: 'Apr', earnings: 3600),
    MonthlyData(month: 'May', earnings: 3100),
    MonthlyData(month: 'Jun', earnings: 3450),
  ];

  final bookingStatus = EmployeeBookingStatus(
    total: 124,
    completed: 78,
    assigned: 25,
    inProgress: 21,
  );

  @override
  void initState() {
    super.initState();
    // Call your API here
    // fetchEmployeeDashboard();
    context
        .read<FetchUsersBloc>()
        .add(const GetEmployeeDashboardEvent(userId: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Performance Overview',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
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
                  if (state is EmployeeDashboardError) {
                    ToastHelper.showToast(
                        context: context, type: "error", title: state.message);
                  }
                  if (state is EmployeeDashboardLoaded) {
                    ToastHelper.showToast(
                        context: context,
                        type: "success",
                        title: "Dashboard Loaded Successfully");
                  }
                },
                builder: (context, state) {
                  if (state is EmployeeDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is EmployeeDashboardError) {
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
                  if (state is EmployeeDashboardLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        Text(
                          'Hi, ${state.employeeDashboardModel.employeeName ?? ""}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                          children: [
                            _buildStatCard(
                              state.employeeDashboardModel.totalBookings
                                  .toString(),
                              'Total Assigned',
                              Icons.calendar_today_outlined,
                              Colors.indigo[50]!,
                              Colors.indigo,
                            ),
                            _buildStatCard(
                              state.employeeDashboardModel.bookingsInprogress
                                  .toString(),
                              "In Progress",
                              Icons.sync,
                              Colors.blue[50]!,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              state.employeeDashboardModel.bookingsCompleted
                                  .toString(),
                              'Completed',
                              Icons.check_circle_outline,
                              Colors.grey[100]!,
                              Colors.grey[700]!,
                            ),
                            _buildStatCard(
                              '\$${state.employeeDashboardModel.revenue}',
                              'Total Earnings',
                              Icons.account_balance_wallet_outlined,
                              Colors.grey[100]!,
                              Colors.grey[700]!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Monthly Earnings Line Chart
                        _buildMonthlyEarningsChart(
                            state.employeeDashboardModel.monthWiseRevenue!),
                        const SizedBox(height: 24),

                        // Booking Status Donut Chart
                        _buildBookingStatusChart(
                            state.employeeDashboardModel.totalBookings!
                                .toDouble(),
                            state.employeeDashboardModel.bookingsInprogress!
                                .toDouble(),
                            state.employeeDashboardModel.bookingsCancelled!
                                .toDouble(),
                            state.employeeDashboardModel.bookingsCompleted!
                                .toDouble(),
                            state.employeeDashboardModel.bookingsRejected!
                                .toDouble()),
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
    String value,
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyEarningsChart(List<MonthWiseRevenue> data) {
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
            'Monthly Earnings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              data[value.toInt()].monthName ?? '',
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
                      interval: 1000,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '\$${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 0,
                maxY: 4000,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '\$${barSpot.y.toStringAsFixed(0)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value.totalAmount!.toDouble() ?? 0.0);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: Colors.blue,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.3),
                          Colors.blue.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingStatusChart(double total, double inprogress,
      double cancelled, double completed, double rejected) {
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
            'Booking Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              height: 280,
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
                      sectionsSpace: 0,
                      centerSpaceRadius: 70,
                      sections: _getPieChartSections(
                          inprogress, completed, cancelled, rejected, total),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total',
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
          const SizedBox(height: 24),
          _buildLegendItem(
            '${completed.toInt().toString()} Completed',
            const Color(0xFF4C5B9D),
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            '${cancelled.toInt().toString()} Cancelled',
            const Color.fromARGB(255, 231, 82, 12),
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            '${rejected.toInt().toString()} Rejected',
            const Color.fromARGB(255, 200, 181, 36),
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            '${inprogress.toInt().toString()} In Progress',
            Colors.grey[300]!,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(
      double inprogress,
      double completed,
      double cancalled,
      double rejected,
      double totalBookings) {
    return [
      PieChartSectionData(
        color: const Color(0xFF4C5B9D),
        value: completed.toDouble(),
        title: '',
        radius: touchedIndex == 0 ? 50 : 45,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4C5B9D),
            Color(0xFF6A7BC4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 228, 87, 27),
        value: cancalled.toDouble(),
        title: '',
        radius: touchedIndex == 1 ? 50 : 45,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5DC8CD),
            Color(0xFF7FD8DB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 218, 140, 24),
        value: rejected.toDouble(),
        title: '',
        radius: touchedIndex == 1 ? 50 : 45,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5DC8CD),
            Color(0xFF7FD8DB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      PieChartSectionData(
        color: Colors.grey[300]!,
        value: inprogress.toDouble(),
        title: '',
        radius: touchedIndex == 2 ? 50 : 45,
      ),
    ];
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
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
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

// Model Classes
class EmployeeStats {
  final int totalAssigned;
  final int inProgress;
  final int completed;
  final int monthlyEarnings;

  EmployeeStats({
    required this.totalAssigned,
    required this.inProgress,
    required this.completed,
    required this.monthlyEarnings,
  });

  factory EmployeeStats.fromJson(Map<String, dynamic> json) {
    return EmployeeStats(
      totalAssigned: json['totalAssigned'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      completed: json['completed'] ?? 0,
      monthlyEarnings: json['monthlyEarnings'] ?? 0,
    );
  }
}

class MonthlyData {
  final String month;
  final double earnings;

  MonthlyData({required this.month, required this.earnings});

  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    return MonthlyData(
      month: json['month'] ?? '',
      earnings: (json['earnings'] ?? 0).toDouble(),
    );
  }
}

class EmployeeBookingStatus {
  final int total;
  final int completed;
  final int assigned;
  final int inProgress;

  EmployeeBookingStatus({
    required this.total,
    required this.completed,
    required this.assigned,
    required this.inProgress,
  });

  factory EmployeeBookingStatus.fromJson(Map<String, dynamic> json) {
    return EmployeeBookingStatus(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      assigned: json['assigned'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
    );
  }
}
