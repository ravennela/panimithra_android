import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
              child:const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    'Employees',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
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

            // Employee List
            BlocConsumer<FetchUsersBloc, FetchUsersState>(
              buildWhen: (previous, current) {
                return (current is FetchUsersLoaded ||
                        current is FetchUsersError ||
                        current is ChangeUserStatusSuccess ||
                        current is ChangeUserStatusError) ||
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
                if (state is ChangeUserStatusSuccess) {
                  ToastHelper.showToast(
                      context: context,
                      type: "success",
                      title: "Employee Status Updated Successfully");
                  context
                      .read<FetchUsersBloc>()
                      .add(const GetUsersEvent(page: 0, role: "EMPLOYEE"));
                  context.pop();
                }
                if (state is ChangeUserStatusError) {
                  ToastHelper.showToast(
                      context: context, type: "error", title: state.message);
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
                              return EmployeeCard(
                                isActive: state.item[index].status.toString() ==
                                        "ACTIVE"
                                    ? true
                                    : false,
                                name: state.item[index].userName.toString(),
                                onActivate: () {
                                  context.read<FetchUsersBloc>().add(
                                      ChangeUserStatusEvent(
                                          userId: state.item[index].userId
                                              .toString(),
                                          status: "ACTIVE"));
                                },
                                onDeactivate: () {
                                  context.read<FetchUsersBloc>().add(
                                      ChangeUserStatusEvent(
                                          userId: state.item[index].userId
                                              .toString(),
                                          status: "INACTIVE"));
                                },
                                onEdit: () {},
                                role: state.item[index].role.toString(),
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

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final bool isActive;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onEdit;

  const EmployeeCard({
    Key? key,
    required this.name,
    required this.role,
    required this.isActive,
    required this.onActivate,
    required this.onDeactivate,
    required this.onEdit,
  }) : super(key: key);

  void _openActions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        message: Text(role),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: onEdit,
            child: const Text("Edit Details"),
          ),
          if (isActive)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: onDeactivate,
              child: const Text("Deactivate"),
            )
          else
            CupertinoActionSheetAction(
              onPressed: onActivate,
              child: const Text("Activate"),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // Leading Avatar Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.person, color: Colors.blue, size: 26),
          ),

          const SizedBox(width: 14),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 6),

                // ACTIVE / INACTIVE chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // More Options
          IconButton(
            onPressed: () => _openActions(context),
            icon: const Icon(Icons.more_vert, size: 24),
          ),
        ],
      ),
    );
  }
}
