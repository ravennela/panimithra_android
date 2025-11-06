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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'Rate Your Experience',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                'How was your service with ${widget.providerName}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),

              // Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.star,
                        size: 24,
                        color: index < selectedRating
                            ? const Color(0xFFFFC107)
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Review Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Write your review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Review TextField
              TextField(
                controller: reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tell us more about your experience (optional)',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFFFC107), width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: BlocListener<ReviewBloc, ReviewState>(
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
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ReviewBloc>().add(AddReviewEvent(
                          bookingId: widget.bookingId,
                          employeeId: widget.employeeId,
                          rating: selectedRating.toDouble(),
                          serviceId: widget.serviceId,
                          review: reviewController.text));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
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
