import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class AddReviewEvent extends ReviewEvent {
  final String bookingId;
  final String employeeId;
  final double rating;
  final String review;
  final String serviceId;

  const AddReviewEvent(
      {required this.bookingId,
      required this.employeeId,
      required this.rating,
      required this.review,
      required this.serviceId});

  @override
  List<Object?> get props => [bookingId, employeeId, rating, review];
}

class FetchTopFiveRatingsEvent extends ReviewEvent {
  final String serviceId;
  const FetchTopFiveRatingsEvent({required this.serviceId});
}
