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
