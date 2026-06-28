import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_tracking_system/features/driver/domain/usecases/get_driver_usecase.dart';
import 'package:vehicle_tracking_system/features/driver/domain/usecases/register_driver_usecase.dart';
import 'package:vehicle_tracking_system/features/driver/domain/usecases/update_driver_usecase.dart';
import 'driver_event.dart';
import 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final RegisterDriverUseCase registerDriverUseCase;
  final GetDriverUseCase getDriverUseCase;
  final UpdateDriverUseCase updateDriverUseCase;

  DriverBloc({
    required this.registerDriverUseCase,
    required this.getDriverUseCase,
    required this.updateDriverUseCase,
  }) : super(DriverInitial()) {
    on<RegisterDriverEvent>(_onRegisterDriver);
    on<GetDriverEvent>(_onGetDriver);
    on<UpdateDriverEvent>(_onUpdateDriver);
    on<LoadAllDriversEvent>(_onLoadAllDrivers);
    on<ClearDriverErrorEvent>(_onClearError);
  }

  Future<void> _onRegisterDriver(
      RegisterDriverEvent event,
      Emitter<DriverState> emit,
      ) async {
    emit(DriverLoading());
    final result = await registerDriverUseCase(event.driver);

    result.fold(
          (failure) => emit(DriverError(failure.message)),
          (driver) => emit(DriverRegistered(driver)),
    );
  }

  Future<void> _onGetDriver(
      GetDriverEvent event,
      Emitter<DriverState> emit,
      ) async {
    emit(DriverLoading());
    final result = await getDriverUseCase(event.id);

    result.fold(
          (failure) => emit(DriverError(failure.message)),
          (driver) => emit(DriverLoaded(driver)),
    );
  }

  Future<void> _onUpdateDriver(
      UpdateDriverEvent event,
      Emitter<DriverState> emit,
      ) async {
    emit(DriverLoading());
    final result = await updateDriverUseCase(event.driver);

    result.fold(
          (failure) => emit(DriverError(failure.message)),
          (driver) => emit(DriverUpdated(driver)),
    );
  }

  Future<void> _onLoadAllDrivers(
      LoadAllDriversEvent event,
      Emitter<DriverState> emit,
      ) async {
    emit(DriverLoading());
    // This would use a GetAllDriversUseCase in a full implementation
    emit(const DriversLoaded([]));
  }

  void _onClearError(
      ClearDriverErrorEvent event,
      Emitter<DriverState> emit,
      ) {
    emit(DriverInitial());
  }
}