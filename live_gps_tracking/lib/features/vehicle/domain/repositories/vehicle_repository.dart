import 'package:live_gps_tracking/features/vehicle/domain/entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<void> addVehicle(VehicleEntity vehicle);
  Future<void> updateVehicle(VehicleEntity vehicle);
  Future<List<VehicleEntity>> getVehicles();
  Stream<List<VehicleEntity>> getVehiclesStream();
}
