import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String statusFilter = 'All Status';
  String serviceFilter = 'All Services';
  final ScrollController _scrollController = ScrollController();
  int totalRecords = 0;
  int totalLength = 0;
  int page = 0;
  int x = 0;
  bool hasMoreRecords = true;
  String searchString = "";
  Timer? _debounce;
  Timer? _searchDebounce;
  bool isLoading = false;
  final List<Map<String, dynamic>> employees = [
    {
      'name': 'John Doe',
      'specialty': 'Plumber',
      'status': 'Approved',
      'rating': '4.8',
      'experience': '5+ Yrs',
      'memberDuration': '2 yrs',
      'location': 'New York',
      'color': Colors.blue,
    },
    {
      'name': 'Jane Smith',
      'specialty': 'Electrician',
      'status': 'Pending',
      'rating': 'N/A',
      'experience': '2 Yrs',
      'memberDuration': '1 mo',
      'location': 'Los Angeles',
      'color': Colors.orange,
    },
    {
      'name': 'Mark Johnson',
      'specialty': 'Cleaner',
      'status': 'Rejected',
      'rating': 'N/A',
      'experience': '< 1 Yr',
      'memberDuration': '3 wks',
      'location': 'Chicago',
      'color': Colors.teal,
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return const Color(0xFF10B981);
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'EXPIRED':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  Color getStatusBgColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return const Color(0xFFF0FDF4);
      case 'PENDING':
        return const Color(0xFFFFFBEB);
      case 'EXPIRED':
        return const Color(0xFFFEF2F2);
      default:
        return Colors.grey.shade50;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'ACTIVE':
        return Icons.check_circle;
      case 'PENDING':
        return Icons.access_time;
      case 'EXPIRED':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  void initState() {
    super.initState();
    context
        .read<FetchUsersBloc>()
        .add(const GetUsersEvent(page: 0, role: "EMPLOYEE"));
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (isLoading) {
      return;
    }
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (totalLength >= totalRecords) {
          hasMoreRecords = false;
          return;
        }

        if (totalLength <= totalRecords) {
          x = 2;
          page += 1;
          //Api
          context
              .read<FetchUsersBloc>()
              .add(GetUsersEvent(page: page, role: "EMPLOYEE"));
        }
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _callApi(query); // Trigger the API
    });
  }

  _callApi(String query) {
    if (query.isEmpty) {
      page = 0;
    }
    context
        .read<FetchUsersBloc>()
        .add(GetUsersEvent(page: 0, name: query, role: "EMPLOYEE"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 24),
                    onPressed: () {},
                  ),
                  const Text(
                    'Employees',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF111827), width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, size: 24),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 15),
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, specialty...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.grey[600], size: 22),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Filters
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              statusFilter,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF374151),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey[700], size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              serviceFilter,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF374151),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey[700], size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Employee List
            BlocConsumer<FetchUsersBloc, FetchUsersState>(
              buildWhen: (previous, current) {
                return (current is FetchUsersLoaded ||
                        current is FetchUsersError) ||
                    (x != 2 && current is FetchUsersLoading);
              },
              listener: (context, state) {
                if (state is FetchUsersLoaded) {
                  isLoading = false;
                  totalRecords = state.totalRecords;
                  totalLength = state.item.length;
                }
                if (state is FetchUsersLoading) {
                  isLoading = true;
                }
                if (state is FetchUsersError) {
                  isLoading = false;
                  ToastHelper.showToast(
                    context: context,
                    type: 'error',
                    title: state.message,
                  );
                }
              },
              builder: (context, state) {
                if (state is FetchUsersLoading || state is FetchUsersInitial) {
                  return const CircularProgressIndicator();
                }
                if (state is FetchUsersError) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading Employee',
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
                                const GetUsersEvent(page: 0, role: "EMPLOYEE"));
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is FetchUsersLoaded) {
                  return state.totalRecords > 0
                      ? Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: state.item.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= state.item.length) {
                                return Visibility(
                                    visible:
                                        state.totalRecords <= state.item.length
                                            ? false
                                            : true,
                                    child: const Center(
                                        child: CircularProgressIndicator()));
                              }
                              final employee = state.item[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Employee Header
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xFFFFFBEB),
                                              width: 3,
                                            ),
                                            image: const DecorationImage(
                                              image: NetworkImage(
                                                  'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=200'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      employee.userName ?? "",
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF111827),
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 0,
                                                      vertical: 0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          getStatusIcon(
                                                              employee.status ??
                                                                  ""),
                                                          color: getStatusColor(
                                                              employee.status ??
                                                                  ""),
                                                          size: 18,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          employee.status ?? "",
                                                          style: TextStyle(
                                                            color: getStatusColor(
                                                                employee.status ??
                                                                    ""),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                employee.primaryService
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xFF6B7280),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // Employee Stats
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "4.8",
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF111827),
                                                      ),
                                                    ),
                                                    if (employee.city != 'N/A')
                                                      const SizedBox(width: 4),
                                                    if (employee.city != 'N/A')
                                                      const Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xFFFBBF24),
                                                        size: 20,
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Rating',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 40,
                                            color: Colors.grey[300],
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  employee.experiance
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF111827),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Experience',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 40,
                                            color: Colors.grey[300],
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "1 mo",
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF111827),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Member',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18),

                                    // Location
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              employee.city ?? "",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3B82F6),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.26),
                            Text("No Employee Available"),
                          ],
                        );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
