import 'package:equatable/equatable.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingActive extends TrackingState {
  final String vehicleId;
  final LocationEntity? currentLocation;

  const TrackingActive({
    required this.vehicleId,
    this.currentLocation,
  });

  @override
  List<Object?> get props => [vehicleId, currentLocation];
}

class TrackingStopped extends TrackingState {
  final String vehicleId;

  const TrackingStopped(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

class LiveLocationsLoaded extends TrackingState {
  final Map<String, LocationEntity> locations;

  const LiveLocationsLoaded(this.locations);

  @override
  List<Object?> get props => [locations];
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError(this.message);

  @override
  List<Object?> get props => [message];
}