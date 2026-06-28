import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/repositories/vehicle_repository.dart';

class AddVehicleUseCase {
  final VehicleRepository repository;

  AddVehicleUseCase({required this.repository});

  Future<Either<Failure, VehicleEntity>> call(VehicleEntity vehicle) {
    return repository.addVehicle(vehicle);
  }
}