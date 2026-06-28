import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/vehicle/data/models/vehicle_model.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDatasource remoteDatasource;

  VehicleRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, VehicleEntity>> addVehicle(VehicleEntity vehicle) async {
    try {
      final model = VehicleModel.fromEntity(vehicle);
      final result = await remoteDatasource.addVehicle(model);
      return Right(result.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> updateVehicle(VehicleEntity vehicle) async {
    try {
      final model = VehicleModel.fromEntity(vehicle);
      final result = await remoteDatasource.updateVehicle(model);
      return Right(result.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> getVehicle(String id) async {
    try {
      final result = await remoteDatasource.getVehicle(id);
      return Right(result.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VehicleEntity>>> getVehicles() async {
    try {
      final results = await remoteDatasource.getVehicles();
      return Right(results.map((model) => model.toEntity()).toList());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VehicleEntity>>> getVehiclesByDriver(String driverId) async {
    try {
      final results = await remoteDatasource.getVehiclesByDriver(driverId);
      return Right(results.map((model) => model.toEntity()).toList());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVehicle(String id) async {
    try {
      await remoteDatasource.deleteVehicle(id);
      return const Right(null);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTrackingStatus(String vehicleId, bool isTracking) async {
    try {
      await remoteDatasource.updateTrackingStatus(vehicleId, isTracking);
      return const Right(null);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<VehicleEntity>> get vehiclesStream {
    return remoteDatasource.vehiclesStream.map(
          (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}