import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';

class UpdatePaymentStatusUseCase {
  final BookingRepository repository;

  UpdatePaymentStatusUseCase(this.repository);

  Future<Either<String, SuccessModel>> call(String bookingId) async {
    return await repository.updatePaymentStatusRepo(
      bookingId: bookingId,
    );
  }
}
