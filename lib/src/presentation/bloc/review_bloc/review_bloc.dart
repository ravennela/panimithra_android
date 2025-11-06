import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/domain/usecase/add_review_usecase.dart';

import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUsecase addReviewUseCase;

  ReviewBloc({required this.addReviewUseCase}) : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
  }
  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    final result = await addReviewUseCase.call(
        bookingId: event.bookingId,
        employeeId: event.employeeId,
        rating: event.rating,
        review: event.review,
        serviceId: event.serviceId);
    result.fold((f) {
      emit(ReviewError(f.toString()));
    }, (data) {
      emit(ReviewLoaded(data));
    });
  }
}
