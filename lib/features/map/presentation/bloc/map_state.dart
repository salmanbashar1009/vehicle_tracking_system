import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:vehicle_tracking_system/features/map/domain/repositories/map_repository.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<VehicleWithLocation> vehicles;
  final String? selectedVehicleId;
  final LatLng? centerOn;

  const MapLoaded({
    required this.vehicles,
    this.selectedVehicleId,
    this.centerOn,
  });

  @override
  List<Object?> get props => [vehicles, selectedVehicleId, centerOn];

  MapLoaded copyWith({
    List<VehicleWithLocation>? vehicles,
    String? selectedVehicleId,
    LatLng? centerOn,
    bool clearSelection = false,
    bool clearCenter = false,
  }) {
    return MapLoaded(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicleId: clearSelection ? null : (selectedVehicleId ?? this.selectedVehicleId),
      centerOn: clearCenter ? null : (centerOn ?? this.centerOn),
    );
  }
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}