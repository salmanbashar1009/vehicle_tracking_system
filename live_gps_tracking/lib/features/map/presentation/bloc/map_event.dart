part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class UpdateMarkers extends MapEvent {
  final List<Marker> markers;

  const UpdateMarkers(this.markers);

  @override
  List<Object> get props => [markers];
}
