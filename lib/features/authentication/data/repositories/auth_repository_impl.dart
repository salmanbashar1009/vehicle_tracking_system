import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/entities/user_entity.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDatasource.signIn(email: email, password: password);
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final result = await remoteDatasource.signUp(
        email: email,
        password: password,
        role: role,
      );
      return Right(result.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDatasource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final result = await remoteDatasource.getCurrentUser();
      return Right(result?.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDatasource.authStateChanges.map(
          (user) => user?.toEntity(),
    );
  }
}