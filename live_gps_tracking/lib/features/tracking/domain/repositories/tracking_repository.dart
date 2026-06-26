import 'package:live_gps_tracking/features/tracking/domain/entities/location_entity.dart';

abstract class TrackingRepository {
  Future<void> updateLocation(LocationEntity location);
  Stream<List<LocationEntity>> getLiveLocations();
  Future<void> startTracking(String vehicleId);
  Future<void> stopTracking(String vehicleId);
}
