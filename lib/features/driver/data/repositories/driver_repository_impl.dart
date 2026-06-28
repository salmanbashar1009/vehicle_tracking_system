import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/driver/data/datasources/driver_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/driver/data/models/driver_model.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';
import 'package:vehicle_tracking_system/features/driver/domain/repositories/driver_repository.dart';

class DriverRepositoryImpl implements DriverRepository {
  final DriverRemoteDatasource remoteDatasource;

  DriverRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, DriverEntity>> registerDriver(DriverEntity driver) async {
    try {
      final model = DriverModel.fromEntity(driver);
      final result = await remoteDatasource.registerDriver(model);
      return Right(result.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverEntity>> getDriver(String id) async {
    try {
      final result = await remoteDatasource.getDriver(id);
      return Right(result.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DriverEntity>> updateDriver(DriverEntity driver) async {
    try {
      final model = DriverModel.fromEntity(driver);
      final result = await remoteDatasource.updateDriver(model);
      return Right(result.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DriverEntity>>> getAllDrivers() async {
    try {
      final results = await remoteDatasource.getAllDrivers();
      return Right(results.map((model) => model.toEntity()).toList());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDriver(String id) async {
    try {
      await remoteDatasource.deleteDriver(id);
      return const Right(null);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}