import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';

class UpdateBookingStatusUsecase {
  final BookingRepository repository;

  UpdateBookingStatusUsecase({required this.repository});

  Future<Either<String, SuccessModel>> call({
    required String bookingId,
    required String bookingStatus,
  }) async {
    return await repository.updateBookingStatusRepo(
      bookingId: bookingId,
      bookingStatus: bookingStatus,
    );
  }
}
