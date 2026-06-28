import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartTrackingEvent extends TrackingEvent {
  final String vehicleId;

  const StartTrackingEvent(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

class StopTrackingEvent extends TrackingEvent {
  final String vehicleId;

  const StopTrackingEvent(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

class LocationUpdatedEvent extends TrackingEvent {
  final String vehicleId;
  final double latitude;
  final double longitude;

  const LocationUpdatedEvent({
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [vehicleId, latitude, longitude];
}

class LoadLiveLocationsEvent extends TrackingEvent {}

class TrackingErrorEvent extends TrackingEvent {
  final String message;

  const TrackingErrorEvent(this.message);

  @override
  List<Object?> get props => [message];
}