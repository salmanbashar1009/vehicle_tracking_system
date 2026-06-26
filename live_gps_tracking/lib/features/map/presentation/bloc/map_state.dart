part of 'map_bloc.dart';

class MapState extends Equatable {
  final List<Marker> markers;

  const MapState({this.markers = const []});

  @override
  List<Object> get props => [markers];
}
