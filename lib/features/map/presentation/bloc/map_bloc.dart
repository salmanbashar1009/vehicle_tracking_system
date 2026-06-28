import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vehicle_tracking_system/features/map/domain/repositories/map_repository.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepository;

  StreamSubscription? _vehiclesSubscription; // ← Important

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

    // Cancel previous subscription if exists
    await _vehiclesSubscription?.cancel();

    final result = await mapRepository.getAllVehiclesWithLocations();

    result.fold(
          (failure) => emit(MapError(failure.message)),
          (vehicles) => emit(MapLoaded(vehicles: vehicles)),
    );

    // Set up real-time listener
    _vehiclesSubscription = mapRepository.getVehiclesWithLocationsStream().listen(
          (vehicles) {
        if (isClosed || emit.isDone) return; // Safety check

        if (state is MapLoaded) {
          emit((state as MapLoaded).copyWith(vehicles: vehicles));
        } else {
          emit(MapLoaded(vehicles: vehicles));
        }
      },
      onError: (error) {
        if (isClosed || emit.isDone) return;
        emit(MapError(error.toString()));
      },
    );
  }

  // Other handlers remain the same
  void _onMapReady(MapReadyEvent event, Emitter<MapState> emit) {}

  void _onSelectVehicle(SelectVehicleEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(selectedVehicleId: event.vehicleId));
    }
  }

  void _onDeselectVehicle(DeselectVehicleEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(clearSelection: true));
    }
  }

  void _onCenterOnVehicle(CenterOnVehicleEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(
        selectedVehicleId: event.vehicleId,
        centerOn: LatLng(event.latitude, event.longitude),
      ));
    }
  }

  void _onMoveMap(MoveMapEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit((state as MapLoaded).copyWith(clearCenter: true));
    }
  }

  @override
  Future<void> close() async {
    await _vehiclesSubscription?.cancel();
    await super.close();
  }
}