import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';
import 'package:panimithra/src/presentation/widget/rating_dialog.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return BookingScreenWidget();
  }
}

class BookingScreenWidget extends State<BookingsScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int totalRecords = 0;
  int totalLength = 0;
  int page = 1;
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
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
          if (state is BookingErrorState) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading Site Manager',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                ? ListView.builder(
                    itemCount: state.item.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.item.length) {
                        return Visibility(
                            visible: state.totalRecords <= state.item.length
                                ? false
                                : true,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      }
                      return BookingCard(
                        title: state.item[index].name,
                        provider: state.item[index].employeeName,
                        date: 'Oct 28, 2023 - 2:00 PM',
                        status: state.item[index].bookingStatus.toString(),
                        bookingId: state.item[index].bookingId,
                        employeeId: state.item[index].employeeId,
                        serviceId: state.item[index].serviceId,
                      );
                    })
                : Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.26),
                      const Text("No Bookings Available"),
                    ],
                  );
          }
          return Container();
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String title;
  final String provider;
  final String date;
  final String status;
  final String serviceId;
  final String bookingId;
  final String employeeId;

  const BookingCard(
      {super.key,
      required this.title,
      required this.provider,
      required this.date,
      required this.status,
      required this.bookingId,
      required this.employeeId,
      required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(status)
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Provider: $provider',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Date: $date',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (status == "COMPLETED")
                    GestureDetector(
                      onTap: () {
                        showRatingDialog(context, provider, serviceId,
                            employeeId, bookingId);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_outline_outlined,
                              color: Colors.blueAccent,
                            ),
                            Text(
                              "Rate & Review",
                              style: TextStyle(color: Colors.blueAccent),
                            )
                          ],
                        ),
                      ),
                    ),
                  const Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: Color(0xFF2196F3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
