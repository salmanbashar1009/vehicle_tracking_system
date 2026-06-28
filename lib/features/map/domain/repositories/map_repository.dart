import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleWithLocation {
  final VehicleEntity vehicle;
  final LocationEntity? location;
  final DriverEntity? driver;

  VehicleWithLocation({
    required this.vehicle,
    this.location,
    this.driver,
  });
}

abstract class MapRepository {
  Future<Either<Failure, List<VehicleWithLocation>>> getAllVehiclesWithLocations();
  Stream<List<VehicleWithLocation>> getVehiclesWithLocationsStream();
}