import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/usecases/add_vehicle_usecase.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/usecases/get_vehicles_usecase.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/usecases/get_vehicle_usecase.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/usecases/update_vehicle_usecase.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final AddVehicleUseCase addVehicleUseCase;
  final UpdateVehicleUseCase updateVehicleUseCase;
  final GetVehicleUseCase getVehicleUseCase;
  final GetVehiclesUseCase getVehiclesUseCase;

  VehicleBloc({
    required this.addVehicleUseCase,
    required this.updateVehicleUseCase,
    required this.getVehicleUseCase,
    required this.getVehiclesUseCase,
  }) : super(VehicleInitial()) {
    on<AddVehicleEvent>(_onAddVehicle);
    on<UpdateVehicleEvent>(_onUpdateVehicle);
    on<GetVehicleEvent>(_onGetVehicle);
    on<LoadVehiclesEvent>(_onLoadVehicles);
    on<FilterVehiclesEvent>(_onFilterVehicles);
    on<UpdateTrackingStatusEvent>(_onUpdateTrackingStatus);
    on<DeleteVehicleEvent>(_onDeleteVehicle);
  }

  Future<void> _onAddVehicle(
      AddVehicleEvent event,
      Emitter<VehicleState> emit,
      ) async {
    emit(VehicleLoading());
    final result = await addVehicleUseCase(event.vehicle);

    result.fold(
          (failure) => emit(VehicleError(failure.message)),
          (vehicle) => emit(VehicleAdded(vehicle)),
    );
  }

  Future<void> _onUpdateVehicle(
      UpdateVehicleEvent event,
      Emitter<VehicleState> emit,
      ) async {
    emit(VehicleLoading());
    final result = await updateVehicleUseCase(event.vehicle);

    result.fold(
          (failure) => emit(VehicleError(failure.message)),
          (vehicle) => emit(VehicleUpdated(vehicle)),
    );
  }

  Future<void> _onGetVehicle(
      GetVehicleEvent event,
      Emitter<VehicleState> emit,
      ) async {
    emit(VehicleLoading());
    final result = await getVehicleUseCase(event.id);

    result.fold(
          (failure) => emit(VehicleError(failure.message)),
          (vehicle) => emit(VehicleLoaded(vehicle)),
    );
  }

  Future<void> _onLoadVehicles(
      LoadVehiclesEvent event,
      Emitter<VehicleState> emit,
      ) async {
    emit(VehicleLoading());
    final result = await getVehiclesUseCase();

    result.fold(
          (failure) => emit(VehicleError(failure.message)),
          (vehicles) => emit(VehiclesLoaded(vehicles: vehicles)),
    );
  }

  void _onFilterVehicles(
      FilterVehiclesEvent event,
      Emitter<VehicleState> emit,
      ) {
    if (state is! VehiclesLoaded) return;

    final currentState = state as VehiclesLoaded;
    var filtered = currentState.vehicles;

    if (event.vehicleType != null && event.vehicleType!.isNotEmpty) {
      filtered = filtered
          .where((v) => v.vehicleType.name == event.vehicleType)
          .toList();
    }

    if (event.driverName != null && event.driverName!.isNotEmpty) {
      // Would need driver data to filter by name
      // For now, just return filtered by type
    }

    emit(VehiclesLoaded(
      vehicles: currentState.vehicles,
      filteredVehicles: filtered,
    ));
  }

  Future<void> _onUpdateTrackingStatus(
      UpdateTrackingStatusEvent event,
      Emitter<VehicleState> emit,
      ) async {
    final result = await updateVehicleUseCase(
      // Find vehicle and update tracking status
      (state is VehiclesLoaded
          ? (state as VehiclesLoaded).vehicles.firstWhere(
            (v) => v.id == event.vehicleId,
        orElse: () => const VehicleEntity(
          id: '',
          driverId: '',
          vehicleType: VehicleType.car,
          vehicleName: '',
          registrationNo: '',
        ),
      )
          : const VehicleEntity(
        id: '',
        driverId: '',
        vehicleType: VehicleType.car,
        vehicleName: '',
        registrationNo: '',
      ))
          .copyWith(isTracking: event.isTracking),
    );

    result.fold(
          (failure) => emit(VehicleError(failure.message)),
          (_) => emit(TrackingStatusUpdated(
        vehicleId: event.vehicleId,
        isTracking: event.isTracking,
      )),
    );
  }

  Future<void> _onDeleteVehicle(
      DeleteVehicleEvent event,
      Emitter<VehicleState> emit,
      ) async {
    emit(VehicleLoading());
    // Implement delete logic
    emit(VehicleDeleted());
    // Reload vehicles
    add(LoadVehiclesEvent());
  }
}