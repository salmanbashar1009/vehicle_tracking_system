import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/core/constants/app_constants.dart';

class Validators {
  Validators._();

  static ValidationFailure? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationFailure(message: 'Name is required');
    }
    if (value.trim().length < AppConstants.minNameLength) {
      return ValidationFailure(
        message: 'Name must be at least ${AppConstants.minNameLength} characters',
      );
    }
    if (value.trim().length > AppConstants.maxNameLength) {
      return ValidationFailure(
        message: 'Name must be at most ${AppConstants.maxNameLength} characters',
      );
    }
    return null;
  }

  static ValidationFailure? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationFailure(message: 'Email is required');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return const ValidationFailure(message: 'Enter a valid email address');
    }
    return null;
  }

  static ValidationFailure? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationFailure(message: 'Phone number is required');
    }
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{10,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return const ValidationFailure(message: 'Enter a valid phone number');
    }
    return null;
  }

  static ValidationFailure? validateVehicleName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationFailure(message: 'Vehicle name is required');
    }
    if (value.trim().length < AppConstants.minNameLength) {
      return ValidationFailure(
        message: 'Vehicle name must be at least ${AppConstants.minNameLength} characters',
      );
    }
    return null;
  }

  static ValidationFailure? validateRegistrationNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationFailure(message: 'Registration number is required');
    }
    if (value.trim().length < AppConstants.minRegistrationLength) {
      return ValidationFailure(
        message: 'Registration must be at least ${AppConstants.minRegistrationLength} characters',
      );
    }
    if (value.trim().length > AppConstants.maxRegistrationLength) {
      return ValidationFailure(
        message: 'Registration must be at most ${AppConstants.maxRegistrationLength} characters',
      );
    }
    return null;
  }

  static ValidationFailure? validateVehicleType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const ValidationFailure(message: 'Vehicle type is required');
    }
    return null;
  }
}