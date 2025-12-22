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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Dashboard',
              style: TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Performance Overview',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
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
                            onPressed: () {
                              context.read<FetchUsersBloc>().add(
                                  const GetEmployeeDashboardEvent(userId: ""));
                            },
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
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, ${state.employeeDashboardModel.employeeName ?? ""}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1D1E),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Here's what's happening with your bookings today.",
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Stats Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: constraints.maxWidth > 600
                                  ? 4
                                  : 2, // Responsive grid
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio:
                                  constraints.maxWidth > 600 ? 1.5 : 1.1,
                              children: [
                                _buildStatCard(
                                  context,
                                  state.employeeDashboardModel.totalBookings
                                      .toString(),
                                  'Total Assigned',
                                  Icons.calendar_today_rounded,
                                  const Color(0xFFEEF2FF),
                                  const Color(0xFF6366F1),
                                ),
                                _buildStatCard(
                                  context,
                                  state
                                      .employeeDashboardModel.bookingsInprogress
                                      .toString(),
                                  "In Progress",
                                  Icons.sync_rounded,
                                  const Color(0xFFF0F9FF),
                                  const Color(0xFF0EA5E9),
                                ),
                                _buildStatCard(
                                  context,
                                  state.employeeDashboardModel.bookingsCompleted
                                      .toString(),
                                  'Completed',
                                  Icons.check_circle_rounded,
                                  const Color(0xFFECFDF5),
                                  const Color(0xFF10B981),
                                ),
                                _buildStatCard(
                                  context,
                                  state.employeeDashboardModel.revenue
                                      .toString(),
                                  'Total Earnings',
                                  Icons.account_balance_wallet_rounded,
                                  const Color(0xFFFFF7ED),
                                  const Color(0xFFF97316),
                                  isCurrency: true,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Monthly Earnings Line Chart
                        _buildMonthlyEarningsChart(
                            state.employeeDashboardModel.monthWiseRevenue!),
                        const SizedBox(height: 32),

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
                        const SizedBox(height: 32),
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
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    bool isCurrency = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(
          16), // Sligthly reduced padding for smaller screens
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isCurrency ? '\₹$value' : value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: Color(0xFF1A1D1E),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyEarningsChart(List<MonthWiseRevenue> data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Earnings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Revenue Overview',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Year ${DateTime.now().year}',
                  style: TextStyle(
                    color: Color(0xFF0EA5E9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[100]!,
                      strokeWidth: 1,
                      dashArray: [4, 4],
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
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 && value.toInt() < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              data[value.toInt()].monthName ?? '',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
                          '${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                      reservedSize: 30,
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
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value.totalAmount!.toDouble() ?? 0.0);
                    }).toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF0EA5E9),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF0EA5E9),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0EA5E9).withOpacity(0.2),
                          const Color(0xFF0EA5E9).withOpacity(0.0),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 40),
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
                      sectionsSpace: 4,
                      centerSpaceRadius: 65,
                      sections: _getPieChartSections(
                          inprogress, completed, cancelled, rejected, total),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            total.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1D1E),
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Total Bookings',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildLegendItem(
                '${completed.toInt().toString()} Completed',
                const Color(0xFF10B981),
              ),
              _buildLegendItem(
                '${inprogress.toInt().toString()} In Progress',
                const Color(0xFF0EA5E9),
              ),
              _buildLegendItem(
                '${cancelled.toInt().toString()} Cancelled',
                const Color(0xFFEF4444),
              ),
              _buildLegendItem(
                '${rejected.toInt().toString()} Rejected',
                const Color(0xFFF59E0B),
              ),
            ],
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
        color: const Color(0xFF10B981),
        value: completed.toDouble(),
        title: '',
        radius: touchedIndex == 0 ? 55 : 45,
        badgeWidget: touchedIndex == 0
            ? _buildBadge(Icons.check, const Color(0xFF10B981))
            : null,
        badgePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: cancalled.toDouble(),
        title: '',
        radius: touchedIndex == 1 ? 55 : 45,
        badgeWidget: touchedIndex == 1
            ? _buildBadge(Icons.close, const Color(0xFFEF4444))
            : null,
        badgePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: rejected.toDouble(),
        title: '',
        radius: touchedIndex == 2 ? 55 : 45,
        badgeWidget: touchedIndex == 2
            ? _buildBadge(Icons.block, const Color(0xFFF59E0B))
            : null,
        badgePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        color: const Color(0xFF0EA5E9),
        value: inprogress.toDouble(),
        title: '',
        radius: touchedIndex == 3 ? 55 : 45,
        badgeWidget: touchedIndex == 3
            ? _buildBadge(Icons.sync, const Color(0xFF0EA5E9))
            : null,
        badgePositionPercentageOffset: 1.3,
      ),
    ];
  }

  // Helper for Pie Chart Badges
  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color, width: 2),
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 16, color: color),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
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
