import 'package:equatable/equatable.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';

abstract class DriverEvent extends Equatable {
  const DriverEvent();

  @override
  List<Object?> get props => [];
}

class RegisterDriverEvent extends DriverEvent {
  final DriverEntity driver;

  const RegisterDriverEvent(this.driver);

  @override
  List<Object?> get props => [driver];
}

class GetDriverEvent extends DriverEvent {
  final String id;

  const GetDriverEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateDriverEvent extends DriverEvent {
  final DriverEntity driver;

  const UpdateDriverEvent(this.driver);

  @override
  List<Object?> get props => [driver];
}

class LoadAllDriversEvent extends DriverEvent {}

class ClearDriverErrorEvent extends DriverEvent {}