import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/fetch_plan_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

/// 🔹 Initial state
class CreatePlanInitial extends PlanState {}

/// 🔹 Loading state (e.g., when creating plan or fetching data)
class CreatePlanLoading extends PlanState {}

/// 🔹 Loaded (Success) state — holds SuccessModel
class CreatePlanLoaded extends PlanState {
  final SuccessModel success;

  const CreatePlanLoaded(this.success);

  @override
  List<Object?> get props => [success];
}

/// 🔹 Error state — holds error message
class CreatePlanError extends PlanState {
  final String message;

  const CreatePlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchPlansLoading extends PlanState {}

/// Loaded state with data
class FetchPlansLoaded extends PlanState {
  final FetchPlanModel fetchPlanModel;

  const FetchPlansLoaded(this.fetchPlanModel);

  @override
  List<Object?> get props => [fetchPlanModel];
}

/// Error state with message
class FetchPlansError extends PlanState {
  final String message;

  const FetchPlansError(this.message);

  @override
  List<Object?> get props => [message];
}
