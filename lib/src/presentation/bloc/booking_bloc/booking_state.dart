import 'package:panimithra/src/data/models/booking_details_model.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class BookingState {}

class BookingInitalState extends BookingState {}

class CreateBookingLoadingState extends BookingState {}

class CreateBookingErrorState extends BookingState {
  final String message;
  CreateBookingErrorState({required this.message});
}

class CreateBokkingLoadedState extends BookingState {
  final SuccessModel successModel;
  CreateBokkingLoadedState({required this.successModel});
}

class BookingLoadingState extends BookingState {}

class BookingLoadedState extends BookingState {
  final FetchBookingModel bookings;
  final List<BookingItem> item;
  final int totalRecords;
  BookingLoadedState(
      {required this.bookings, required this.item, required this.totalRecords});
  List<Object?> get props => [bookings];
}

class BookingErrorState extends BookingState {
  final String message;

  BookingErrorState(this.message);
  List<Object?> get props => [message];
}

class UpdateBookingStatusLoading extends BookingState {}

class UpdateBookingStatusLoaded extends BookingState {
  final SuccessModel success;
  UpdateBookingStatusLoaded(this.success);
  List<Object?> get props => [success];
}

class UpdateBookingStatusError extends BookingState {
  final String message;
  UpdateBookingStatusError(this.message);
  List<Object?> get props => [message];
}

class BookingDetailsLoading extends BookingState {}

// ✅ Loaded (success) state
class BookingDetailsLoaded extends BookingState {
  final BookingDetailsModel bookingDetails;

  BookingDetailsLoaded(this.bookingDetails);
  List<Object?> get props => [bookingDetails];
}

// ✅ Error state
class BookingDetailsError extends BookingState {
  final String message;

  BookingDetailsError(this.message);

  List<Object?> get props => [message];
}

class UpdatePaymentStatusLoading extends BookingState {}

class UpdatePaymentStatusLoaded extends BookingState {
  final SuccessModel success;
  UpdatePaymentStatusLoaded(this.success);

  List<Object?> get props => [success];
}

class UpdatePaymentStatusError extends BookingState {
  final String message;
  UpdatePaymentStatusError(this.message);

  List<Object?> get props => [message];
}
