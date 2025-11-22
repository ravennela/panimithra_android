import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/toast.dart' show ToastHelper;
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<AdminBookingsScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  int totalRecords = 0;
  int totalLength = 0;
  int page = 0;
  int x = 0;
  String searchString = "";
  Timer? _debounce;
  Timer? _searchDebounce;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchBookingsEvent(0));
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    _searchDebounce?.cancel();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print("scrolling");
    if (isLoading) {
      return;
    }
    if (!mounted) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (totalLength >= totalRecords) {
          return;
        }
        if (totalLength <= totalRecords) {
          x = 2;
          page += 1;
          context.read<BookingBloc>().add(FetchBookingsEvent(page));
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
    //context.read<BookingBloc>().add(FetchBookingsEvent(page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'All Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                _onSearchChanged(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by ID, Customer...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          // Filter Chips

          BlocConsumer<BookingBloc, BookingState>(
            buildWhen: (previous, current) {
              return (current is BookingLoadedState ||
                      current is BookingErrorState) ||
                  (page == 0 && current is BookingLoadingState);
            },
            listener: (context, state) {
              if (state is BookingLoadedState) {
                isLoading = false;
                totalRecords = state.totalRecords;
                totalLength = state.item.length;
              }
              if (state is BookingLoadingState) {
                isLoading = true;
              }
              if (state is BookingErrorState) {
                isLoading = false;
                ToastHelper.showToast(
                  context: context,
                  type: 'error',
                  title: state.message,
                );
              }
            },
            builder: (context, state) {
              if (state is BookingLoadingState && page == 0) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is BookingInitalState && page == 0) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is BookingErrorState) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading Bookings',
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
                          context
                              .read<BookingBloc>()
                              .add(FetchBookingsEvent(0));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (state is BookingLoadedState) {
                return state.totalRecords > 0
                    ? Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
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

                              return _buildBookingCard(state.item[index]);
                            }),
                      )
                    : Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.26),
                          const Text("No Bookings Available"),
                        ],
                      );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingItem booking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ----- TOP ROW -----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile Icon + Name + ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "#${booking.bookingId}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// STATUS BADGE
              _buildStatusBadge(booking.bookingStatus),
            ],
          ),

          const SizedBox(height: 18),

          /// ----- DETAILS SECTION -----
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow("Service", booking.serviceName),
                const SizedBox(height: 10),
                _detailRow(
                    "Date",
                    DateFormat("dd/MMM/yyyy")
                        .format(booking.bookingDate ?? DateTime.now())),
                const SizedBox(height: 10),
                _detailRow("Status", booking.bookingStatus ?? "-"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ----- PRICE -----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                "₹${booking.amount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _detailRow(String label, String value) {
  return Row(
    children: [
      SizedBox(
        width: 80,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

Widget _buildStatusBadge(String status) {
  Color bg;
  Color text;

  switch (status.toUpperCase()) {
    case "COMPLETED":
      bg = Colors.green.shade50;
      text = Colors.green.shade700;
      break;
    case "PENDING":
      bg = Colors.orange.shade50;
      text = Colors.orange.shade700;
      break;
    case "CANCELLED":
      bg = Colors.red.shade50;
      text = Colors.red.shade700;
      break;
    default:
      bg = Colors.grey.shade200;
      text = Colors.grey.shade700;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      status,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: text,
      ),
    ),
  );
}
