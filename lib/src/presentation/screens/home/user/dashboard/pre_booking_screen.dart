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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                return Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.3,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: size.height * 0.4,
                    ),
                  ],
                );
              }
              if (state is ServiceByIdError) {
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
                          context
                              .read<ServiceBloc>()
                              .add(GetServiceByIdEvent(widget.serviceId));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (state is ServiceByIdLoaded) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Image with App Bar
                        Stack(
                          children: [
                            Image.network(
                              state.service.imageUrl != null
                                  ? state.service.imageUrl.toString()
                                  : 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800',
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 250,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.plumbing,
                                      size: 80, color: Colors.grey),
                                );
                              },
                            ),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: const Icon(Icons.arrow_back,
                                            color: Colors.black),
                                        onPressed: () {
                                          context.pop();
                                        },
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: const Icon(Icons.share,
                                            color: Colors.black),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Content
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Breadcrumb
                                    Text(
                                      '${state.service.categoryName} > ${state.service.subCategoryName}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Title
                                    Text(
                                      state.service.serviceName,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Rating and Price
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.service.avaragerating
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          ' (${state.service.totalReviewCount})',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: Colors.blue[700],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Starts from \₹${state.service.price.toString()}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    // Professional Card
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Colors.blue[100],
                                            child: const Icon(Icons.person,
                                                size: 32, color: Colors.blue),
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
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${state.service.employeeExperiance}+ years of experience',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.verified,
                                                color: Colors.blue[700],
                                                size: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // About Section
                                    const Text(
                                      'About this service',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.service.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // What's Included
                                    const Text(
                                      'What\'s Included',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    if (state.service.addInfoOne != null &&
                                        state.service.addInfoOne!.isNotEmpty)
                                      _buildIncludedItem(
                                        '${state.service.addInfoOne}',
                                      ),
                                    if (state.service.addInfoTwo != null &&
                                        state.service.addInfoTwo!.isNotEmpty)
                                      _buildIncludedItem(
                                        '${state.service.addInfoTwo}',
                                      ),
                                    if (state.service.addInfoThree != null &&
                                        state.service.addInfoThree!.isNotEmpty)
                                      _buildIncludedItem(
                                        '${state.service.addInfoThree}',
                                      ),
                                    const SizedBox(height: 24),

                                    // Reviews Section
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Reviews',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
                                          child: const Text('See all'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    BlocConsumer<ReviewBloc, ReviewState>(
                                        buildWhen: (previous, current) =>
                                            (current is TopFiveRatingsError ||
                                                current
                                                    is TopFiveRatingsLoaded ||
                                                current
                                                    is TopFiveRatingsLoaded),
                                        builder: (context, state) {
                                          if (state is TopFiveRatingsLoading) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (state is TopFiveRatingsError) {
                                            return Center(
                                              child: Text(state.message),
                                            );
                                          }
                                          if (state is TopFiveRatingsLoaded) {
                                            final ratings = state
                                                    .topFiveRatingModel
                                                    .rating ??
                                                [];

                                            if (ratings.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No reviews available'));
                                            }

                                            return Column(
                                              children: List.generate(
                                                  ratings.length, (index) {
                                                final item = ratings[index];
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: _buildReviewCard(
                                                    name: item.userName
                                                        .toString(),
                                                    rating:
                                                        item.rating!.toInt(),
                                                    review: item.comment ?? "",
                                                  ),
                                                );
                                              }),
                                            );
                                          }

                                          return Container();
                                        },
                                        listener: (context, state) {}),

                                    // Review 1

                                    // Review 2

                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: BlocListener<BookingBloc, BookingState>(
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
                          context: context,
                          type: 'error',
                          title: state.message);
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      String userId =
                          preferences.getString(ApiConstants.userId) ?? "";
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
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildIncludedItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.blue[700], size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
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
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600], size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: List.generate(
                      rating,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '"$review"',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
