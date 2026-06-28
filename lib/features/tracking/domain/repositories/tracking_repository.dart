import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';

abstract class TrackingRepository {
  Future<Either<Failure, void>> startTracking(String vehicleId);
  Future<Either<Failure, void>> stopTracking(String vehicleId);
  Future<Either<Failure, void>> updateLocation(LocationEntity location);
  Future<Either<Failure, LocationEntity?>> getLatestLocation(String vehicleId);
  Stream<LocationEntity?> getLiveLocation(String vehicleId);
  Stream<Map<String, LocationEntity>> getAllLiveLocations();
}