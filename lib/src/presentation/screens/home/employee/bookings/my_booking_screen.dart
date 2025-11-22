import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return MyBookingsScreenWidget();
  }
}

class MyBookingsScreenWidget extends State<MyBookingsScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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
    context.read<BookingBloc>().add(FetchBookingsEvent(page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Manage all your assigned service bookings',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
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
                        'Error loading Site Manager',
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
                        child: Text('Retry'),
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

                              return GestureDetector(
                                  onTap: () {
                                    context.push(
                                        AppRoutes
                                            .EMPLOYEE_BOOKING_DETAILS_SCREEN_PATH,
                                        extra: {
                                          "bookingId": state
                                              .bookings.data[index].bookingId
                                        });
                                  },
                                  child:
                                      // BookingCard(booking: state.item[index])
                                      BookingCardUltraUC(
                                    item: state.item[index],
                                    onTap: () {
                                      context.push(
                                          AppRoutes
                                              .EMPLOYEE_BOOKING_DETAILS_SCREEN_PATH,
                                          extra: {
                                            "bookingId": state
                                                .bookings.data[index].bookingId
                                          });
                                    },
                                  ));
                            }),
                      )
                    : Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.34),
                          Center(child: const Text("No Bookings Available")),
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
}

class UCTheme {
  static const Color primary = Color(0xFF1A73E8);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF6D6D6D);
  static const Color bgLight = Color(0xFFF7F9FC);
  static const Color card = Colors.white;

  static const double radius = 16;
}

class BookingCardUltraUC extends StatelessWidget {
  final BookingItem item;
  final VoidCallback onTap;

  const BookingCardUltraUC({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP ROW — TITLE + ARROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    capitalize(item.serviceName) ?? "Service Name",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 18, color: Colors.grey.shade500),
              ],
            ),

            const SizedBox(height: 6),

            /// DESCRIPTION
            Text(
              capitalize(item.description) ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.4,
                fontSize: 14.5,
              ),
            ),

            const SizedBox(height: 18),

            const Divider(height: 1, color: Color(0xFFEAEAEA)),
            const SizedBox(height: 16),

            /// DATE & TIME
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  DateFormat("EEE, dd MMM yyyy")
                      .format(item.bookingDate ?? DateTime.now()),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.person_outline,
                    size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 8),

                /// YOU WILL REPLACE THIS WITH YOUR REAL TIME
                Text(
                  capitalize(item.userName),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// AMOUNT + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// AMOUNT ROW
                Row(
                  children: [
                    Icon(Icons.currency_rupee_rounded,
                        size: 20, color: Colors.blue.shade700),
                    Text(
                      "${item.amount}" ?? "0",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                /// STATUS BADGE
                _statusChip(item.bookingStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String? status) {
    Color bg;
    Color text;

    switch (status) {
      case "Completed":
        bg = const Color(0xFFE8F5E9);
        text = const Color(0xFF2E7D32);
        break;
      case "Inprogress":
        bg = const Color(0xFFE3F2FD);
        text = const Color(0xFF1A73E8);
        break;
      default:
        bg = const Color(0xFFFFEBEE);
        text = const Color(0xFFC62828);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        status ?? "",
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }
}

// Booking Model
class Booking {
  final String customerName;
  final String customerImage;
  final String serviceType;
  final String status;
  final String dateTime;
  final String location;

  Booking({
    required this.customerName,
    required this.customerImage,
    required this.serviceType,
    required this.status,
    required this.dateTime,
    required this.location,
  });
}
