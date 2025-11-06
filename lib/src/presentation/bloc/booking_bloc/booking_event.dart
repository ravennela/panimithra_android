import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';

abstract class BookingEvent {}

class CreateBookingEvent extends BookingEvent {
  final Map<String, dynamic> data;
  CreateBookingEvent({required this.data});
}

class FetchBookingsEvent extends BookingEvent {
  final int page;
  FetchBookingsEvent(this.page);

  List<Object?> get props => [page];
}

class UpdateBookingStatusEvent extends BookingEvent {
  final String bookingId;
  final String bookingStatus;

  UpdateBookingStatusEvent({
    required this.bookingId,
    required this.bookingStatus,
  });
  List<Object?> get props => [bookingId, bookingStatus];
}
