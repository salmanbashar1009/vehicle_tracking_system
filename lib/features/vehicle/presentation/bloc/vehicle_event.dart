import 'package:equatable/equatable.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class AddVehicleEvent extends VehicleEvent {
  final VehicleEntity vehicle;

  const AddVehicleEvent(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class UpdateVehicleEvent extends VehicleEvent {
  final VehicleEntity vehicle;

  const UpdateVehicleEvent(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class GetVehicleEvent extends VehicleEvent {
  final String id;

  const GetVehicleEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadVehiclesEvent extends VehicleEvent {}

class FilterVehiclesEvent extends VehicleEvent {
  final String? vehicleType;
  final String? driverName;

  const FilterVehiclesEvent({this.vehicleType, this.driverName});

  @override
  List<Object?> get props => [vehicleType, driverName];
}

class UpdateTrackingStatusEvent extends VehicleEvent {
  final String vehicleId;
  final bool isTracking;

  const UpdateTrackingStatusEvent({
    required this.vehicleId,
    required this.isTracking,
  });

  @override
  List<Object?> get props => [vehicleId, isTracking];
}

class DeleteVehicleEvent extends VehicleEvent {
  final String id;

  const DeleteVehicleEvent(this.id);

  @override
  List<Object?> get props => [id];
}