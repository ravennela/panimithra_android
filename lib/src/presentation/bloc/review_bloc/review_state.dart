import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/data/models/top_five_rating_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final SuccessModel response;

  const ReviewLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopFiveRatingsLoading extends ReviewState {}

class TopFiveRatingsError extends ReviewState {
  final String message;

  const TopFiveRatingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopFiveRatingsLoaded extends ReviewState {
  final TopFiveRatingModel topFiveRatingModel;

  const TopFiveRatingsLoaded(this.topFiveRatingModel);

  @override
  List<Object?> get props => [topFiveRatingModel];
}
