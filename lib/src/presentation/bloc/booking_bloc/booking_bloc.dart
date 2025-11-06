import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/domain/usecase/create_booking_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_booking_usecase.dart';
import 'package:panimithra/src/domain/usecase/update_booking_status_usecase.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUsecase createBookingUsecase;
  final GetBookingsUseCase getBookingsUseCase;
  final UpdateBookingStatusUsecase updateBookingStatusUsecase;
  BookingBloc(
      {required this.createBookingUsecase,
      required this.getBookingsUseCase,
      required this.updateBookingStatusUsecase})
      : super(BookingInitalState()) {
    on<CreateBookingEvent>(_createBookingHandler);
    on<FetchBookingsEvent>(_onFetchBookings);
    on<UpdateBookingStatusEvent>(_onUpdateBookingStatus);
  }

  FutureOr<void> _createBookingHandler(
      CreateBookingEvent event, Emitter<BookingState> emit) async {
    emit(CreateBookingLoadingState());
    final res =
        await createBookingUsecase.repository.createBookingRepo(event.data);
    res.fold((f) {
      emit(CreateBookingErrorState(message: f.toString()));
    }, (data) {
      emit(CreateBokkingLoadedState(successModel: data));
    });
  }

  FutureOr<void> _onFetchBookings(
      FetchBookingsEvent event, Emitter<BookingState> emit) async {
    List<BookingItem> currentItem = [];
    if (state is BookingLoadedState) {
      if (event.page > 0) {
        currentItem = List.from((state as BookingLoadedState).item);
      }
    }
    emit(BookingLoadingState());

    final result = await getBookingsUseCase(event.page);
    result.fold(
      (failure) => emit(BookingErrorState(failure)),
      (bookings) {
        final upadtedBookings = [...currentItem, ...bookings.data];
        emit(BookingLoadedState(
            bookings: bookings,
            item: upadtedBookings,
            totalRecords: bookings.totalItems));
      },
    );
  }

  FutureOr<void> _onUpdateBookingStatus(
      UpdateBookingStatusEvent event, Emitter<BookingState> emit) async {
    emit(UpdateBookingStatusLoading());

    final result = await updateBookingStatusUsecase.call(
      bookingId: event.bookingId,
      bookingStatus: event.bookingStatus,
    );

    result.fold(
      (failure) => emit(UpdateBookingStatusError(failure)),
      (success) => emit(UpdateBookingStatusLoaded(success)),
    );
  }
}
