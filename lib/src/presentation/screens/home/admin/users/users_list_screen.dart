import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/common/toast.dart';
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

          const SizedBox(height: 8),

          // Customer List
          Expanded(
            child: BlocConsumer<FetchUsersBloc, FetchUsersState>(
              buildWhen: (previous, current) =>
                  ((current is FetchUsersError || current is FetchUsersLoaded)),
              listener: (context, state) {
                print(state);
                if (state is ChangeUserStatusSuccess) {
                  ToastHelper.showToast(
                      context: context,
                      type: "success",
                      title: "User Status Updated Successfully");
                  context
                      .read<FetchUsersBloc>()
                      .add(const GetUsersEvent(page: 0, role: "USER"));
                }
                if (state is ChangeUserStatusError) {
                  ToastHelper.showToast(
                      context: context, type: "error", title: state.message);
                }
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
                            return UserCard(
                              name: state.item[index].userName ?? "-",
                              phone: state.item[index].contactNumber ?? "-",
                              status: state.item[index].status ?? "-",
                              onToggleStatus: () {
                                context.read<FetchUsersBloc>().add(
                                    ChangeUserStatusEvent(
                                        userId:
                                            state.item[index].userId.toString(),
                                        status:
                                            state.item[index].status == "ACTIVE"
                                                ? "INACTIVE"
                                                : "ACTIVE"));
                              },
                              role: state.item[index].role.toString(),
                              onView: () {},
                              onEdit: () {},
                            );
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

class UserCard extends StatelessWidget {
  final String name;
  final String phone;
  final String role;
  final String status; // "Active" or "Inactive"
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const UserCard({
    super.key,
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
    required this.onView,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar Circle
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.person, color: Colors.blue),
          ),

          const SizedBox(width: 14),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
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

                // Phone
                Text(
                  phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    // Role chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Active/Inactive chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == "ACTIVE"
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          color: status == "ACTIVE" ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Popup menu
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (value) {
              if (value == "view") onView();
              if (value == "edit") onEdit();
              if (value == "toggle") onToggleStatus();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "view",
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 18),
                    SizedBox(width: 10),
                    Text("View Details"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 10),
                    Text("Edit User"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "toggle",
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, size: 18),
                    SizedBox(width: 10),
                    Text(
                      status == "ACTIVE" ? "Deactivate" : "Activate",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
