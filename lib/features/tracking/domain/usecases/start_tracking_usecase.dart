import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/repositories/tracking_repository.dart';

class StartTrackingUseCase {
  final TrackingRepository repository;

  StartTrackingUseCase(this.repository);

  Future<Either<Failure, void>> call(String vehicleId) {
    return repository.startTracking(vehicleId);
  }
}