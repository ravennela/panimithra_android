import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/fetch_plan_model.dart';
import 'package:panimithra/src/data/models/plan_by_id_model.dart';
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

class DeletePlanLoading extends PlanState {}

/// 🔹 Delete plan success
class DeletePlanLoaded extends PlanState {
  final SuccessModel success;

  const DeletePlanLoaded(this.success);

  @override
  List<Object?> get props => [success];
}

/// 🔹 Delete plan error
class DeletePlanError extends PlanState {
  final String message;

  const DeletePlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchPlanByIdLoadingState extends PlanState {}

class FetchPlanByIdLoaded extends PlanState {
  final PlanById plan;

  const FetchPlanByIdLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

/// 🔹 Error state — contains message
class FetchPlanByIdError extends PlanState {
  final String message;

  const FetchPlanByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

/// 🔹 Update Plan Loading State
class UpdatePlanLoading extends PlanState {}

/// 🔹 Update Plan Loaded (Success)
class UpdatePlanLoaded extends PlanState {
  final SuccessModel success;

  const UpdatePlanLoaded(this.success);

  @override
  List<Object?> get props => [success];
}

/// 🔹 Update Plan Error
class UpdatePlanError extends PlanState {
  final String message;

  const UpdatePlanError(this.message);

  @override
  List<Object?> get props => [message];
}
