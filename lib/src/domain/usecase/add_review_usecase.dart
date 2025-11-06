import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';
import 'package:panimithra/src/domain/repositories/review_repository.dart';

class AddReviewUsecase {
  final ReviewRepository repository;

  AddReviewUsecase({required this.repository});

  Future<Either<String, SuccessModel>> call({
    required String bookingId,
    required String employeeId,
    required double rating,
    required String review,
    required String serviceId
  }) async {
    return await repository.addReviewRepo(
      bookingId: bookingId,
      serviceId: serviceId,
      employeeId: employeeId,
      rating: rating,
      review: review,
    );
  }
}
