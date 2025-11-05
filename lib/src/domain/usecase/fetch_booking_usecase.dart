import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';

class GetBookingsUseCase {
  final BookingRepository repository;

  GetBookingsUseCase({required this.repository});

  Future<Either<String, FetchBookingModel>> call(int page) async {
    return await repository.getBookings(page);
  }
}
