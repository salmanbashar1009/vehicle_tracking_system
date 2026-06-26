import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/entities/user_entity.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String role,
  }) {
    return repository.signUp(email: email, password: password, role: role);
  }
}