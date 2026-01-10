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
import 'package:shimmer/shimmer.dart';
import 'package:panimithra/l10n/app_localizations.dart';

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
        if (isLoading) {
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

  bool isActionLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.myBookings,
              style: const TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  color: Color(0xFF1A1D1E)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  AppLocalizations.of(context)!.manageAssignedBookings,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: BlocConsumer<BookingBloc, BookingState>(
                  buildWhen: (previous, current) {
                    return (current is BookingLoadedState ||
                            current is BookingErrorState) ||
                        (page == 0 && current is BookingLoadingState);
                  },
                  listener: (context, state) {
                    if (state is UpdateBookingStatusLoading) {
                      setState(() {
                        isActionLoading = true;
                      });
                    }
                    if (state is BookingLoadedState) {
                      isLoading = false;
                      totalRecords = state.totalRecords;
                      totalLength = state.item.length;
                    }
                    if (state is UpdateBookingStatusLoaded) {
                      setState(() {
                        isActionLoading = false;
                      });
                      ToastHelper.showToast(
                          context: context,
                          type: "success",
                          title: AppLocalizations.of(context)!.bookingStatusUpdated);
                      context.read<BookingBloc>().add(FetchBookingsEvent(0));
                    }
                    if (state is UpdateBookingStatusError) {
                      setState(() {
                        isActionLoading = false;
                      });
                      ToastHelper.showToast(
                          context: context,
                          type: "error",
                          title: state.message);
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
                      return _buildBookingShimmer();
                    }
                    if (state is BookingInitalState && page == 0) {
                      return _buildBookingShimmer();
                    }
                    if (state is BookingErrorState) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Animated Error Icon with Gradient Background
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFFEF4444).withOpacity(0.1),
                                            const Color(0xFFF97316).withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFEF4444).withOpacity(0.2),
                                            blurRadius: 24,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.error_outline_rounded,
                                        size: 64,
                                        color: Color(0xFFEF4444),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                              
                              // Error Title
                              Text(
                                AppLocalizations.of(context)!.oopsSomethingWentWrong,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1D1E),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Error Message
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              
                              // Retry Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<BookingBloc>()
                                        .add(FetchBookingsEvent(0));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0EA5E9),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 2,
                                    shadowColor: const Color(0xFF0EA5E9).withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.refresh_rounded, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(context)!.tryAgain,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is BookingLoadedState) {
                      return state.totalRecords > 0
                          ? ListView.builder(
                              controller: _scrollController,
                              itemCount: state.item.length + 1,
                              itemBuilder: (context, index) {
                                if (index >= state.item.length) {
                                  return Visibility(
                                      visible: state.totalRecords <=
                                              state.item.length
                                          ? false
                                          : true,
                                      child:
                                          _buildBookingShimmer(itemCount: 1));
                                }

                                return _buildAnimatedListItem(
                                  index: index,
                                  child: BookingCardUltraUC(
                                    item: state.item[index],
                                    onTap: () {
                                      context.push(
                                          AppRoutes
                                              .EMPLOYEE_BOOKING_DETAILS_SCREEN_PATH,
                                          extra: {
                                            "bookingId":
                                                state.item[index].bookingId
                                          });
                                    },
                                  ),
                                );
                              })
                          : _buildEmptyState(context);
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
          if (isActionLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingShimmer({int itemCount = 6}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withOpacity(0.05)),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 120, height: 16, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: 80, height: 12, color: Colors.white),
                        ],
                      ),
                    ),
                    Container(width: 60, height: 20, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 24),
                Container(width: 200, height: 14, color: Colors.white),
                const SizedBox(height: 12),
                Container(width: 180, height: 14, color: Colors.white),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                        width: 100,
                        height: 28,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20))),
                    const Spacer(),
                    Container(width: 20, height: 20, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedListItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 150 + (index % 5 * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.calendar_today_rounded,
                size: 64, color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Bookings Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your assigned service bookings will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<BookingBloc>().add(FetchBookingsEvent(0));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1D1E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.refreshList
            ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header: Service Icon, Name & Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.cleaning_services_rounded,
                          color: Color(0xFF1A1D1E), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalize(item.serviceName) ?? "Service",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1D1E),
                              letterSpacing: -0.4,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Booking ID: #${item.bookingId.substring(0, 8)}',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\₹${item.amount}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                ),

                /// Info Rows
                _buildInfoRow(
                    Icons.calendar_today_rounded,
                    DateFormat("EEE, dd MMM yyyy, hh:mm a")
                        .format(item.bookingDate ?? DateTime.now())),
                const SizedBox(height: 12),
                if (item.location.isNotEmpty || item.city.isNotEmpty) ...[
                  _buildInfoRow(Icons.location_on_outlined,
                      "${item.location}, ${item.city}"),
                  const SizedBox(height: 12),
                ],
                _buildInfoRow(Icons.person_outline_rounded,
                    capitalize(item.userName) ?? "Customer"),

                const SizedBox(height: 20),

                /// Footer: Status & Actions
                Row(
                  children: [
                    _statusChip(item.bookingStatus),
                    const Spacer(),
                    if (_shouldShowActions(item.bookingStatus))
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF9CA3AF), size: 14),
                  ],
                ),
                if (_shouldShowActions(item.bookingStatus)) ...[
                  const SizedBox(height: 16),
                  _buildActionButtons(
                      item.bookingId, item.bookingStatus, context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowActions(String status) {
    final s = status.toUpperCase();
    return s == "PENDING" || s == "INPROGRESS";
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String? status) {
    Color bg;
    Color text;
    String label = status ?? "Unknown";

    switch (status?.toUpperCase()) {
      case "COMPLETED":
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF10B981);
        break;
      case "INPROGRESS":
        bg = const Color(0xFFF0F9FF);
        text = const Color(0xFF0EA5E9);
        break;
      case "PENDING":
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFFF97316);
        break;
      case "REJECTED":
      case "CANCELLED":
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFEF4444);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        text = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: bg == const Color(0xFFF3F4F6)
                ? Colors.grey[300]!
                : Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: text,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: text,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      String bookingId, String status, BuildContext context) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  _showConfirmationDialog(
                    context: context,
                    title: "Accept Booking",
                    content: "Are you sure you want to accept this booking?",
                    confirmText: "Accept",
                    confirmColor: const Color(0xFF10B981),
                    onConfirm: () {
                      context.read<BookingBloc>().add(UpdateBookingStatusEvent(
                          bookingId: bookingId, bookingStatus: "INPROGRESS"));
                    },
                  );
                },
                child: const Text("Accept",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFEF4444),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  _showConfirmationDialog(
                    context: context,
                    title: "Reject Booking",
                    content: "Are you sure you want to reject this booking?",
                    confirmText: "Reject",
                    confirmColor: const Color(0xFFEF4444),
                    onConfirm: () {
                      context.read<BookingBloc>().add(UpdateBookingStatusEvent(
                          bookingId: bookingId, bookingStatus: "REJECTED"));
                    },
                  );
                },
                child: const Text("Reject",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        );

      case "INPROGRESS":
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0EA5E9).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _showConfirmationDialog(
                  context: context,
                  title: "Complete Booking",
                  content:
                      "Are you sure you want to mark this booking as completed?",
                  confirmText: "Complete",
                  confirmColor: const Color(0xFF0EA5E9),
                  onConfirm: () {
                    context.read<BookingBloc>().add(
                          UpdateBookingStatusEvent(
                            bookingId: bookingId,
                            bookingStatus: "COMPLETED",
                          ),
                        );
                  },
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    "Complete Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                confirmText,
                style:
                    TextStyle(color: confirmColor, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
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
