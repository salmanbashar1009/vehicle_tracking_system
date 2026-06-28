
import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/repositories/tracking_repository.dart';

class UpdateLocationUseCase {
  final TrackingRepository repository;

  UpdateLocationUseCase({required this.repository});

  Future<Either<Failure, void>> call(LocationEntity location) {
    return repository.updateLocation(location);
  }
}