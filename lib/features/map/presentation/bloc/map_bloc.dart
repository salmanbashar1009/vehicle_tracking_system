import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vehicle_tracking_system/features/map/domain/repositories/map_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepository;

  MapBloc({required this.mapRepository}) : super(MapInitial()) {
    on<LoadMapDataEvent>(_onLoadMapData);
    on<MapReadyEvent>(_onMapReady);
    on<SelectVehicleEvent>(_onSelectVehicle);
    on<DeselectVehicleEvent>(_onDeselectVehicle);
    on<CenterOnVehicleEvent>(_onCenterOnVehicle);
    on<MoveMapEvent>(_onMoveMap);
  }

  Future<void> _onLoadMapData(
      LoadMapDataEvent event,
      Emitter<MapState> emit,
      ) async {
    emit(MapLoading());

    final result = await mapRepository.getAllVehiclesWithLocations();

    result.fold(
          (failure) => emit(MapError(failure.message)),
          (vehicles) => emit(MapLoaded(vehicles: vehicles)),
    );

    // Also listen to stream for real-time updates
    mapRepository.getVehiclesWithLocationsStream().listen(
          (vehicles) {
        if (state is MapLoaded) {
          emit((state as MapLoaded).copyWith(vehicles: vehicles));
        } else {
          emit(MapLoaded(vehicles: vehicles));
        }
      },
      onError: (error) {
        emit(MapError(error.toString()));
      },
    );
  }

  void _onMapReady(
      MapReadyEvent event,
      Emitter<MapState> emit,
      ) {
    // Map is ready, could perform initial actions
  }

  void _onSelectVehicle(
      SelectVehicleEvent event,
      Emitter<MapState> emit,
      ) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(selectedVehicleId: event.vehicleId));
    }
  }

  void _onDeselectVehicle(
      DeselectVehicleEvent event,
      Emitter<MapState> emit,
      ) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(clearSelection: true));
    }
  }

  void _onCenterOnVehicle(
      CenterOnVehicleEvent event,
      Emitter<MapState> emit,
      ) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(
        selectedVehicleId: event.vehicleId,
        centerOn: LatLng(event.latitude, event.longitude),
      ));
    }
  }

  void _onMoveMap(
      MoveMapEvent event,
      Emitter<MapState> emit,
      ) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(clearCenter: true));
    }
  }
}