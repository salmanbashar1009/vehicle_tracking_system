import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../authentication/presentation/widgets/auth_button.dart';
import '../../../authentication/presentation/widgets/auth_text_field.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import '../widgets/vehicle_type_selector.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() => _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNameController = TextEditingController();
  final _registrationNoController = TextEditingController();
  VehicleType _selectedType = VehicleType.car;

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _registrationNoController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final vehicle = VehicleEntity(
          id: const Uuid().v4(),
          driverId: authState.user.id,
          vehicleType: _selectedType,
          vehicleName: _vehicleNameController.text.trim(),
          registrationNo: _registrationNoController.text.trim(),
          createdAt: DateTime.now(),
        );

        context.read<VehicleBloc>().add(AddVehicleEvent(vehicle));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleBloc, VehicleState>(
      listener: (context, state) {
        if (state is VehicleAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle added successfully!')),
          );
          context.pop();
        } else if (state is VehicleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Vehicle'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Vehicle Information',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                VehicleTypeSelector(
                  selectedType: _selectedType,
                  onTypeSelected: (type) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _vehicleNameController,
                  label: 'Vehicle Name',
                  hintText: 'e.g., Toyota Corolla',
                  prefixIcon: Icons.directions_car,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vehicle name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _registrationNoController,
                  label: 'Registration Number',
                  hintText: 'e.g., DHAKA-12345',
                  prefixIcon: Icons.badge,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Registration number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<VehicleBloc, VehicleState>(
                  builder: (context, state) {
                    return AuthButton(
                      text: 'Register Vehicle',
                      isLoading: state is VehicleLoading,
                      onPressed: _onSubmit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
