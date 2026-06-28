import 'package:equatable/equatable.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleAdded extends VehicleState {
  final VehicleEntity vehicle;

  const VehicleAdded(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehicleUpdated extends VehicleState {
  final VehicleEntity vehicle;

  const VehicleUpdated(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehicleLoaded extends VehicleState {
  final VehicleEntity vehicle;

  const VehicleLoaded(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehiclesLoaded extends VehicleState {
  final List<VehicleEntity> vehicles;
  final List<VehicleEntity> filteredVehicles;

  const VehiclesLoaded({
    required this.vehicles,
    List<VehicleEntity>? filteredVehicles,
  }) : filteredVehicles = filteredVehicles ?? vehicles;

  @override
  List<Object?> get props => [vehicles, filteredVehicles];
}

class TrackingStatusUpdated extends VehicleState {
  final String vehicleId;
  final bool isTracking;

  const TrackingStatusUpdated({
    required this.vehicleId,
    required this.isTracking,
  });

  @override
  List<Object?> get props => [vehicleId, isTracking];
}

class VehicleDeleted extends VehicleState {}

class VehicleError extends VehicleState {
  final String message;

  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}