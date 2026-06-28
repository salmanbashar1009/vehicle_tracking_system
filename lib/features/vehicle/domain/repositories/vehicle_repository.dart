import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<Either<Failure, VehicleEntity>> addVehicle(VehicleEntity vehicle);
  Future<Either<Failure, VehicleEntity>> updateVehicle(VehicleEntity vehicle);
  Future<Either<Failure, VehicleEntity>> getVehicle(String id);
  Future<Either<Failure, List<VehicleEntity>>> getVehicles();
  Future<Either<Failure, List<VehicleEntity>>> getVehiclesByDriver(String driverId);
  Future<Either<Failure, void>> deleteVehicle(String id);
  Future<Either<Failure, void>> updateTrackingStatus(String vehicleId, bool isTracking);
  Stream<List<VehicleEntity>> get vehiclesStream;
}