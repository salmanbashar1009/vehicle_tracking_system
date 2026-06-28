import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_tracking_system/core/services/location_service.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/usecases/get_live_locations_usecase.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/usecases/start_tracking_usecase.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/usecases/stop_tracking_usecase.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/usecases/update_location_usecase.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final StartTrackingUseCase startTrackingUseCase;
  final StopTrackingUseCase stopTrackingUseCase;
  final UpdateLocationUseCase updateLocationUseCase;
  final GetLiveLocationsUseCase getLiveLocationsUseCase;
  final LocationService locationService;

  StreamSubscription? _locationSubscription;
  StreamSubscription? _liveLocationsSubscription;
  final Map<String, StreamSubscription?> _vehicleTrackingSubscriptions = {};

  TrackingBloc({
    required this.startTrackingUseCase,
    required this.stopTrackingUseCase,
    required this.updateLocationUseCase,
    required this.getLiveLocationsUseCase,
    required this.locationService,
  }) : super(TrackingInitial()) {
    on<StartTrackingEvent>(_onStartTracking);
    on<StopTrackingEvent>(_onStopTracking);
    on<LocationUpdatedEvent>(_onLocationUpdated);
    on<LoadLiveLocationsEvent>(_onLoadLiveLocations);
    on<TrackingErrorEvent>(_onTrackingError);
  }

  Future<void> _onStartTracking(
      StartTrackingEvent event,
      Emitter<TrackingState> emit,
      ) async {
    emit(TrackingLoading());

    // Update Firestore tracking status
    final result = await startTrackingUseCase(event.vehicleId);

    result.fold(
          (failure) => emit(TrackingError(failure.message)),
          (_) {
        // Start simulated GPS for this vehicle
        _startGpsSimulation(event.vehicleId);
        emit(TrackingActive(vehicleId: event.vehicleId));
      },
    );
  }

  void _startGpsSimulation(String vehicleId) {
    // Cancel existing subscription if any
    _vehicleTrackingSubscriptions[vehicleId]?.cancel();

    // Create a new location service instance for this vehicle
    final vehicleLocationService = SimulatedLocationService();
    _vehicleTrackingSubscriptions[vehicleId] = vehicleLocationService.locationStream.listen(
          (location) {
        add(LocationUpdatedEvent(
          vehicleId: vehicleId,
          latitude: location.latitude,
          longitude: location.longitude,
        ));
      },
    );

    vehicleLocationService.startTracking();
    _vehicleTrackingSubscriptions[vehicleId] = vehicleLocationService.locationStream.listen(
          (location) {
        add(LocationUpdatedEvent(
          vehicleId: vehicleId,
          latitude: location.latitude,
          longitude: location.longitude,
        ));
      },
    );
    vehicleLocationService.startTracking();
  }

  Future<void> _onStopTracking(
      StopTrackingEvent event,
      Emitter<TrackingState> emit,
      ) async {
    // Stop GPS simulation
    _vehicleTrackingSubscriptions[event.vehicleId]?.cancel();
    _vehicleTrackingSubscriptions.remove(event.vehicleId);

    // Update Firestore tracking status
    final result = await stopTrackingUseCase(event.vehicleId);

    result.fold(
          (failure) => emit(TrackingError(failure.message)),
          (_) => emit(TrackingStopped(event.vehicleId)),
    );
  }

  Future<void> _onLocationUpdated(
      LocationUpdatedEvent event,
      Emitter<TrackingState> emit,
      ) async {
    final location = LocationEntity(
      vehicleId: event.vehicleId,
      latitude: event.latitude,
      longitude: event.longitude,
      timestamp: DateTime.now(),
    );

    await updateLocationUseCase(location);

    if (state is TrackingActive) {
      final currentState = state as TrackingActive;
      if (currentState.vehicleId == event.vehicleId) {
        emit(TrackingActive(
          vehicleId: event.vehicleId,
          currentLocation: location,
        ));
      }
    }
  }

  void _onLoadLiveLocations(
      LoadLiveLocationsEvent event,
      Emitter<TrackingState> emit,
      ) {
    _liveLocationsSubscription?.cancel();
    _liveLocationsSubscription = getLiveLocationsUseCase().listen(
          (locations) {
        emit(LiveLocationsLoaded(locations));
      },
      onError: (error) {
        emit(TrackingError(error.toString()));
      },
    );
  }

  void _onTrackingError(
      TrackingErrorEvent event,
      Emitter<TrackingState> emit,
      ) {
    emit(TrackingError(event.message));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _liveLocationsSubscription?.cancel();
    for (final sub in _vehicleTrackingSubscriptions.values) {
      sub?.cancel();
    }
    _vehicleTrackingSubscriptions.clear();
    return super.close();
  }
}