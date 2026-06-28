import 'package:equatable/equatable.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';

abstract class DriverState extends Equatable {
  const DriverState();

  @override
  List<Object?> get props => [];
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverRegistered extends DriverState {
  final DriverEntity driver;

  const DriverRegistered(this.driver);

  @override
  List<Object?> get props => [driver];
}

class DriverLoaded extends DriverState {
  final DriverEntity driver;

  const DriverLoaded(this.driver);

  @override
  List<Object?> get props => [driver];
}

class DriversLoaded extends DriverState {
  final List<DriverEntity> drivers;

  const DriversLoaded(this.drivers);

  @override
  List<Object?> get props => [drivers];
}

class DriverUpdated extends DriverState {
  final DriverEntity driver;

  const DriverUpdated(this.driver);

  @override
  List<Object?> get props => [driver];
}

class DriverError extends DriverState {
  final String message;

  const DriverError(this.message);

  @override
  List<Object?> get props => [message];
}