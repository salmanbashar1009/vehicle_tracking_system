import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';
import 'package:vehicle_tracking_system/features/driver/domain/repositories/driver_repository.dart';

class RegisterDriverUseCase {
  final DriverRepository repository;

  RegisterDriverUseCase({required this.repository});

  Future<Either<Failure, DriverEntity>> call(DriverEntity driver) {
    return repository.registerDriver(driver);
  }
}