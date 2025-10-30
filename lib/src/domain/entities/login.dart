import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String raw;

  const LoginEntity({
    required this.raw,
  });

  @override
  List<Object?> get props => [raw];
}