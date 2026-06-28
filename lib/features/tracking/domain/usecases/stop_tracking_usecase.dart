import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/repositories/tracking_repository.dart';

class StopTrackingUseCase {
  final TrackingRepository repository;

  StopTrackingUseCase({required this.repository});

  Future<Either<Failure, void>> call(String vehicleId) {
    return repository.stopTracking(vehicleId);
  }
}