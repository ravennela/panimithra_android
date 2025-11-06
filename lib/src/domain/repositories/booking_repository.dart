import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class BookingRepository {
  Future<Either<String, SuccessModel>> createBookingRepo(
      Map<String, dynamic> data);
  Future<Either<String, FetchBookingModel>> getBookings(int page);
  Future<Either<String, SuccessModel>> updateBookingStatusRepo({
    required String bookingId,
    required String bookingStatus,
  });
}
