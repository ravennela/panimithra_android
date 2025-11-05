import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';

abstract class FetchUsersState extends Equatable {
  const FetchUsersState();

  @override
  List<Object?> get props => [];
}

/// Initial or idle state
class FetchUsersInitial extends FetchUsersState {}

/// Loading state
class FetchUsersLoading extends FetchUsersState {}

/// Loaded state — contains the successfully fetched users
class FetchUsersLoaded extends FetchUsersState {
  final FetchUsersModel fetchUsersModel;
  final List<UserItem> item;
  final int totalRecords;
  const FetchUsersLoaded(
      {required this.fetchUsersModel,
      required this.item,
      required this.totalRecords});

  @override
  List<Object?> get props => [fetchUsersModel];
}

/// Error state — contains an error message
class FetchUsersError extends FetchUsersState {
  final String message;

  const FetchUsersError(this.message);

  @override
  List<Object?> get props => [message];
}
