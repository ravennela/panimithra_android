import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_event.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_state.dart';

import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/service/service_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreBookingScreen extends StatefulWidget {
  final String serviceId;
  const PreBookingScreen({super.key, required this.serviceId});

  @override
  State<PreBookingScreen> createState() => _PreBookingScreenState();
}

class _PreBookingScreenState extends State<PreBookingScreen> {
  String name = "";
  String employeeId = "";
  String description = "";
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(GetServiceByIdEvent(widget.serviceId));
    context
        .read<ReviewBloc>()
        .add(FetchTopFiveRatingsEvent(serviceId: widget.serviceId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          BlocConsumer<ServiceBloc, ServiceState>(
            listener: (context, state) {
              if (state is ServiceByIdError) {
                ToastHelper.showToast(
                    context: context, type: 'error', title: state.message);
              }
              if (state is ServiceByIdLoaded) {
                employeeId = state.service.employeeId.toString();
                name = state.service.serviceName;
                description = state.service.description;
                totalAmount = state.service.price;
              }
            },
            builder: (context, state) {
              if (state is ServiceByIdLoading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF1A1D1E),
                    ),
                  ),
                );
              }
              if (state is ServiceByIdError) {
                return Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Something went wrong',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1D1E)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ServiceBloc>()
                                .add(GetServiceByIdEvent(widget.serviceId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1D1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Retry',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is ServiceByIdLoaded) {
                return Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 280,
                        backgroundColor: const Color(0xFFF8F9FD),
                        elevation: 0,
                        pinned: true,
                        leading: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_rounded,
                                color: Colors.black, size: 20),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                state.service.imageUrl != null
                                    ? state.service.imageUrl.toString()
                                    : 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                        Icons.image_not_supported_rounded,
                                        size: 60,
                                        color: Colors.grey[400]),
                                  );
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FD),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Categories
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1D1E)
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${state.service.categoryName} • ${state.service.subCategoryName}',
                                        style: const TextStyle(
                                          color: Color(0xFF1A1D1E),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Title & Price
                                    Text(
                                      state.service.serviceName,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A1D1E),
                                        height: 1.2,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          '\₹${state.service.price}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1A1D1E),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'starts from',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.orange.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.orange
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star_rounded,
                                                  color: Colors.orange,
                                                  size: 18),
                                              const SizedBox(width: 4),
                                              Text(
                                                state.service.avaragerating
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              Text(
                                                ' (${state.service.totalReviewCount})',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    // Professional Card
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.04),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1A1D1E),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                                Icons.person_rounded,
                                                color: Colors.white,
                                                size: 24),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.service.employeeName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1A1D1E),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${state.service.employeeExperiance}+ years exp',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(Icons.verified_rounded,
                                                    size: 14,
                                                    color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Verified',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // About Section
                                    const Text(
                                      'About Service',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A1D1E),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.service.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                        height: 1.6,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // What's Included
                                    if ((state.service.addInfoOne != null && state.service.addInfoOne!.isNotEmpty) ||
                                        (state.service.addInfoTwo != null &&
                                            state.service.addInfoTwo!
                                                .isNotEmpty) ||
                                        (state.service.addInfoThree != null &&
                                            state.service.addInfoThree!
                                                .isNotEmpty)) ...[
                                      const Text(
                                        'What\'s Included',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1D1E),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (state.service.addInfoOne != null &&
                                          state.service.addInfoOne!.isNotEmpty)
                                        _buildIncludedItem(
                                            '${state.service.addInfoOne}'),
                                      if (state.service.addInfoTwo != null &&
                                          state.service.addInfoTwo!.isNotEmpty)
                                        _buildIncludedItem(
                                            '${state.service.addInfoTwo}'),
                                      if (state.service.addInfoThree != null &&
                                          state
                                              .service.addInfoThree!.isNotEmpty)
                                        _buildIncludedItem(
                                            '${state.service.addInfoThree}'),
                                      const SizedBox(height: 32),
                                    ],

                                    // Reviews Section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Reviews',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1A1D1E),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.push(
                                                AppRoutes.USER_REVIEW_SCREEN,
                                                extra: {
                                                  "serviceId": widget.serviceId
                                                });
                                          },
                                          child: Text(
                                            'See all',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF1A1D1E),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    BlocBuilder<ReviewBloc, ReviewState>(
                                      buildWhen: (previous, current) =>
                                          (current is TopFiveRatingsLoading ||
                                              current is TopFiveRatingsLoaded ||
                                              current is TopFiveRatingsError),
                                      builder: (context, state) {
                                        if (state is TopFiveRatingsLoading) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        if (state is TopFiveRatingsLoaded) {
                                          final ratings =
                                              state.topFiveRatingModel.rating ??
                                                  [];
                                          if (ratings.isEmpty) {
                                            return Container(
                                              padding: const EdgeInsets.all(24),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .chat_bubble_outline_rounded,
                                                      size: 32,
                                                      color: Colors.grey[300]),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'No reviews yet',
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return Column(
                                            children: List.generate(
                                              ratings.length,
                                              (index) {
                                                final item = ratings[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12.0),
                                                  child: _buildReviewCard(
                                                    name: item.userName
                                                        .toString(),
                                                    rating:
                                                        item.rating!.toInt(),
                                                    review: item.comment ?? "",
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                    const SizedBox(height: 100),
                                  ],
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
              return const SizedBox();
            },
          ),
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocConsumer<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is CreateBokkingLoadedState) {
                    ToastHelper.showToast(
                        context: context,
                        type: 'success',
                        title: "Booking Created Successfully");
                    context.pop();
                  }
                  if (state is CreateBookingErrorState) {
                    ToastHelper.showToast(
                        context: context, type: 'error', title: state.message);
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is CreateBookingLoadingState;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String userId =
                                  preferences.getString(ApiConstants.userId) ??
                                      "";
                              if (employeeId == "") {
                                return;
                              }

                              Map<String, dynamic> data = {
                                "name": name,
                                "bookingDate": DateTime.now().toIso8601String(),
                                "paymentStatus": "PENDING",
                                "description": description,
                                "serviceId": widget.serviceId,
                                "userId": userId,
                                "totalAmount": totalAmount,
                                "employeeId": employeeId,
                                "bookingStatus": "PENDING"
                              };

                              context
                                  .read<BookingBloc>()
                                  .add(CreateBookingEvent(data: data));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1D1E),
                        disabledBackgroundColor:
                            const Color(0xFF1A1D1E).withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Book Service Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIncludedItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D1E).withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded,
              color: Color(0xFF1A1D1E), size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildReviewCard({
  required String name,
  required int rating,
  required String review,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          color:
                              index < rating ? Colors.amber : Colors.grey[300],
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.format_quote_rounded, color: Colors.grey[200], size: 24),
          ],
        ),
        if (review.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            review,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ],
    ),
  );
}
