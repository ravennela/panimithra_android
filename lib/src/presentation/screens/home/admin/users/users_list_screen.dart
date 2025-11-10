import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String selectedStatus = 'All';
  String selectedSort = 'Newest';
  final TextEditingController searchController = TextEditingController();
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

  // Static data - Replace with API call
  List<Map<String, dynamic>> customers = [
    {
      'id': '1',
      'name': 'Maya Rao',
      'email': 'maya.rao@example.com',
      'phone': '+91 91234 56780',
      'date': '15 Sep 2023',
      'orders': '21',
      'status': 'Active',
      'isBlocked': false,
      'avatar': 'assets/maya.jpg', // Add your asset or use initials
    },
    {
      'id': '2',
      'name': 'Rohan Verma',
      'email': 'rohan.verma@example.com',
      'phone': '+91 98765 43211',
      'date': '02 Aug 2023',
      'orders': '5',
      'status': 'Blocked',
      'isBlocked': true,
      'avatar': 'assets/rohan.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    context
        .read<FetchUsersBloc>()
        .add(const GetUsersEvent(page: 0, role: "USER"));
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
        .add(GetUsersEvent(page: 0, name: query, role: "USERS"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customers',
              style: TextStyle(
                color: Color(0xFF1E3A8A),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${customers.length} total',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() {
                _onSearchChanged(value);
              }),
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          // Filters Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Status Filter
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedStatus,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: ['All', 'Active', 'Blocked']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text('Status: $status'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Sort Filter
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSort,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: ['Newest', 'Oldest', 'Name']
                          .map((sort) => DropdownMenuItem(
                                value: sort,
                                child: Text('Sort By: $sort'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Customer List
          Expanded(
            child: BlocConsumer<FetchUsersBloc, FetchUsersState>(
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
                  return const Center(child: CircularProgressIndicator());
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
                                const GetUsersEvent(page: 0, role: "USER"));
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is FetchUsersLoaded) {
                  return state.totalRecords > 0
                      ? ListView.builder(
                          controller: _scrollController,
                          itemCount: state.item.length + 1,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            return _buildCustomerCard(state.item[index]);
                          },
                        )
                      : _buildEmptyState();
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(UserItem customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          // Header Row
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFFF6B6B),
                child: Text(
                  customer.userName!.isNotEmpty
                      ? customer.userName!.substring(0, 1)
                      : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name and Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.userName.toString(),
                      style: const TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.email.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: customer.status != "ACTIVE"
                      ? const Color(0xFFFFEBEE)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: customer.status == "INACTIVE"
                          ? const Color(0xFFFF5252)
                          : const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      customer.status.toString(),
                      style: TextStyle(
                        color: customer.status == "INACTIVE"
                            ? const Color(0xFFFF5252)
                            : const Color(0xFF4CAF50),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info Row
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                customer.contactNumber.toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Expanded(child: Container()),
              const SizedBox(width: 20),
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                DateFormat("dd/MM/yyyy").format(customer.dob ?? DateTime.now()),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Expanded(child: Container()),
              const SizedBox(width: 20),
              const Icon(Icons.shopping_bag, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              const Text(
                "6",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // View details action
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: customer.status == "INACTIVE"
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFF5252),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    customer.status == "INACTIVE" ? 'ACTIVATE' : 'IN ACTIVATE',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Customers Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your search or filter returned no results.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
