import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_event.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_state.dart';

// Function to show the rating dialog
void showRatingDialog(BuildContext context, String providerName,
    String serviceId, String employeeId, String bookingId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RatingDialog(
        providerName: providerName,
        bookingId: bookingId,
        employeeId: employeeId,
        serviceId: serviceId,
      );
    },
  );
}

class RatingDialog extends StatefulWidget {
  final String providerName;
  final String serviceId;
  final String employeeId;
  final String bookingId;

  const RatingDialog(
      {super.key,
      required this.providerName,
      required this.bookingId,
      required this.employeeId,
      required this.serviceId});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(5),
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded,
                    color: Color(0xFFFFC107), size: 32),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Rate Your Experience',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D1E),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'How was your service with ${widget.providerName}?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Star Rating
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50], // Subtle background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.star_rounded, // Rounded stars look more modern
                          size: 36,
                          color: index < selectedRating
                              ? const Color(0xFFFFC107)
                              : Colors.grey[300],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              // Review Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Write your review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1D1E),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Review TextField
              TextField(
                controller: reviewController,
                maxLines: 4,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Tell us more about your experience (optional)',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFFFFC107), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button with Loading State
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<ReviewBloc, ReviewState>(
                  listener: (context, state) {
                    if (state is ReviewError) {
                      ToastHelper.showToast(
                          context: context,
                          type: "error",
                          title: state.message);
                    }
                    if (state is ReviewLoaded) {
                      ToastHelper.showToast(
                          context: context,
                          type: "success",
                          title: "Rating Updated Successfully");
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    bool isLoading = state is ReviewLoading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (selectedRating == 0) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: "error",
                                    title: "Please select a star rating");
                                return;
                              }
                              context.read<ReviewBloc>().add(AddReviewEvent(
                                  bookingId: widget.bookingId,
                                  employeeId: widget.employeeId,
                                  rating: selectedRating.toDouble(),
                                  serviceId: widget.serviceId,
                                  review: reviewController.text));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        disabledBackgroundColor:
                            const Color(0xFFFFC107).withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF1A1D1E),
                              ),
                            )
                          : const Text(
                              'Submit Review',
                              style: TextStyle(
                                color: Color(0xFF1A1D1E),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage in your widget:
/*
ElevatedButton(
  onPressed: () {
    showRatingDialog(context, 'John Doe');
  },
  child: const Text('Rate Service'),
)
*/
