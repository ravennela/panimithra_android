import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/domain/usecase/fetch_users_usecase.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';

class FetchUsersBloc extends Bloc<FetchUsersEvent, FetchUsersState> {
  final FetchUsersUseCase fetchUsersUseCase;

  FetchUsersBloc({required this.fetchUsersUseCase})
      : super(FetchUsersInitial()) {
    on<GetUsersEvent>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(
    GetUsersEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    List<UserItem> currentUsers = [];

    // retain previously loaded users for pagination
    if (state is FetchUsersLoaded) {
      if (event.page != null && event.page! > 0) {
        currentUsers =
            List.from((state as FetchUsersLoaded).fetchUsersModel.data);
      }
    }

    emit(FetchUsersLoading());
    print(event.page);
    final result = await fetchUsersUseCase.call(
      page: event.page,
      name: event.name,
      status: event.status,
      role: event.role,
    );

    result.fold(
      (failure) => emit(FetchUsersError(failure.toString())),
      (FetchUsersModel usersModel) {
        print("loaded state bloc");
        final updatedManagers = [...currentUsers, ...usersModel.data];
        print("updated managers" + updatedManagers.length.toString());

        // if no records found initially

        emit(FetchUsersLoaded(
            fetchUsersModel: usersModel,
            item: updatedManagers,
            totalRecords: usersModel.totalItems));
      },
    );
  }
}
