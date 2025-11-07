import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/booking_details_model.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';

class GetBookingDetailsUsecase {
  final BookingRepository repository;

  GetBookingDetailsUsecase({required this.repository});

  Future<Either<String, BookingDetailsModel>> call(String bookingId) async {
    return await repository.getBookingDetailsRepo(bookingId);
  }
}
