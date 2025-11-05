import 'package:equatable/equatable.dart';

abstract class FetchUsersEvent extends Equatable {
  const FetchUsersEvent();

  @override
  List<Object?> get props => [];
}

class GetUsersEvent extends FetchUsersEvent {
  final int? page;
  final String? status;
  final String? name;
  final String? role;

  const GetUsersEvent({
    this.page,
    this.status,
    this.name,
    this.role,
  });

  @override
  List<Object?> get props => [page, status, name, role];
}
