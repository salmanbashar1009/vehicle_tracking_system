import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapDataEvent extends MapEvent {}

class MapReadyEvent extends MapEvent {}

class SelectVehicleEvent extends MapEvent {
  final String vehicleId;

  const SelectVehicleEvent(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

class DeselectVehicleEvent extends MapEvent {}

class CenterOnVehicleEvent extends MapEvent {
  final String vehicleId;
  final double latitude;
  final double longitude;

  const CenterOnVehicleEvent({
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [vehicleId, latitude, longitude];
}

class MoveMapEvent extends MapEvent {
  final LatLng center;
  final double zoom;

  const MoveMapEvent({required this.center, required this.zoom});

  @override
  List<Object?> get props => [center, zoom];
}