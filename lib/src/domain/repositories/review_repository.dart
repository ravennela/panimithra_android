import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class ReviewRepository {
  Future<Either<String, SuccessModel>> addReviewRepo(
      {required String bookingId,
      required String employeeId,
      required double rating,
      required String review,
      required String serviceId});
}
