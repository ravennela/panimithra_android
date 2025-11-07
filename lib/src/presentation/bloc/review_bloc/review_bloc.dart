import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/domain/usecase/add_review_usecase.dart';
import 'package:panimithra/src/domain/usecase/top_five_review_usecase.dart';

import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUsecase addReviewUseCase;
  final GetTopFiveRatingsUseCase getTopFiveRatingsUseCase;

  ReviewBloc(
      {required this.addReviewUseCase, required this.getTopFiveRatingsUseCase})
      : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
    on<FetchTopFiveRatingsEvent>(_onFetchTopFiveRatings);
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

  Future<void> _onFetchTopFiveRatings(
    FetchTopFiveRatingsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(TopFiveRatingsLoading());
    final result = await getTopFiveRatingsUseCase(serviceId: event.serviceId);
    result.fold(
      (failure) => emit(TopFiveRatingsError(failure)),
      (data) => emit(TopFiveRatingsLoaded(data)),
    );
  }
}
