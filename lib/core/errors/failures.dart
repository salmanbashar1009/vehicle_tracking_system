import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred', super.code});

  @override
  String toString() => 'ServerFailure: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});

  @override
  String toString() => 'NetworkFailure: $message';
}

class FirestoreFailure extends Failure {
  const FirestoreFailure({super.message = 'Database error occurred', super.code});

  @override
  String toString() => 'FirestoreFailure: $message';
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed', super.code});

  @override
  String toString() => 'AuthFailure: $message';
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheFailure: $message';
}

class LocationFailure extends Failure {
  const LocationFailure({super.message = 'Location error occurred'});

  @override
  String toString() => 'LocationFailure: $message';
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failed'});

  @override
  String toString() => 'ValidationFailure: $message';
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred'});

  @override
  String toString() => 'UnknownFailure: $message';
}