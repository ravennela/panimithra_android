import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/success_model.dart';

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
