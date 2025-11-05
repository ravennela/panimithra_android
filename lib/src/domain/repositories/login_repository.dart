import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/login_model.dart';

abstract class LoginRepository {
  Future<Either<String, LoginModel>> createlogin(Map<String, dynamic> data);
}
