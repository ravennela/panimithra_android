import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/fetch_reviews_model.dart';
import 'package:panimithra/src/domain/usecase/add_review_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_all_reviews_usecase.dart';
import 'package:panimithra/src/domain/usecase/top_five_review_usecase.dart';

import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUsecase addReviewUseCase;
  final GetTopFiveRatingsUseCase getTopFiveRatingsUseCase;
  final FetchAllReviewsUseCase fetchAllReviewsUseCase;

  ReviewBloc(
      {required this.addReviewUseCase,
      required this.getTopFiveRatingsUseCase,
      required this.fetchAllReviewsUseCase})
      : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
    on<FetchTopFiveRatingsEvent>(_onFetchTopFiveRatings);
    on<FetchAllReviewsEvent>(_onFetchAllReviews);
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

  FutureOr<void> _onFetchAllReviews(
    FetchAllReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    // Keep track of previously loaded reviews for pagination
    List<ReviewsItem> currentItems = [];

    if (state is FetchAllReviewsLoaded) {
      if (event.pageNo != 0) {
        currentItems = List.from(
          (state as FetchAllReviewsLoaded).fetchReviewsModel.data,
        );
      }
    }

    // Emit loading
    emit(FetchAllReviewsLoading());

    // Call the usecase
    final result = await fetchAllReviewsUseCase.call(
      serviceId: event.serviceId,
      pageNo: event.pageNo,
    );

    // Handle result
    result.fold(
      (failure) => emit(FetchAllReviewsError(failure.toString())),
      (reviewsModel) {
        // Append new page data to previous data
        final updatedItems = [...currentItems, ...reviewsModel.data];

        // Emit loaded state with mergeddata
        emit(
          FetchAllReviewsLoaded(
              fetchReviewsModel: reviewsModel,
              items: updatedItems,
              totalRecords: reviewsModel.totalItems),
        );
      },
    );
  }
}
