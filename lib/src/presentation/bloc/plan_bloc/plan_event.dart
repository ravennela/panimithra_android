import 'package:equatable/equatable.dart';

/// Base class for all Plan-related events
abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object?> get props => [];
}

/// 🔹 Event to create a new plan
class CreatePlanEvent extends PlanEvent {
  final String planName;
  final String description;
  final double price;
  final int duration;
  final double originalPrice;
  final String discount;

  const CreatePlanEvent({
    required this.planName,
    required this.description,
    required this.price,
    required this.discount,
    required this.originalPrice,
    required this.duration,
  });

  @override
  List<Object?> get props =>
      [planName, description, price, duration, discount, originalPrice];
}

/// 🔹 Event to fetch paginated plans
class FetchPlansEvent extends PlanEvent {
  const FetchPlansEvent();

  @override
  List<Object?> get props => [];
}

class DeletePlanEvent extends PlanEvent {
  final String planId;

  const DeletePlanEvent({required this.planId});

  @override
  List<Object?> get props => [planId];
}
