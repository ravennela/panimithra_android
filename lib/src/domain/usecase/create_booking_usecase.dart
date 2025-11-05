import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';

class CreateBookingUsecase {
  BookingRepository repository;
  CreateBookingUsecase({required this.repository});
  Future<Either<String, SuccessModel>> createBookingUsecase(
      Map<String, dynamic> data) {
    return repository.createBookingRepo(data);
  }
}
