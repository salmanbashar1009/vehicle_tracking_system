import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';

abstract class DriverRepository {
  Future<Either<Failure, DriverEntity>> registerDriver(DriverEntity driver);
  Future<Either<Failure, DriverEntity>> getDriver(String id);
  Future<Either<Failure, DriverEntity>> updateDriver(DriverEntity driver);
  Future<Either<Failure, List<DriverEntity>>> getAllDrivers();
  Future<Either<Failure, void>> deleteDriver(String id);
}