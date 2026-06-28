import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/repositories/tracking_repository.dart';

class GetLiveLocationsUseCase {
  final TrackingRepository repository;

  GetLiveLocationsUseCase(this.repository);

  Stream<Map<String, LocationEntity>> call() {
    return repository.getAllLiveLocations();
  }
}