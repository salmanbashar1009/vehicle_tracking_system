import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_tracking_system/features/vehicle/presentation/widgets/vehicle_type_selector.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/widgets/auth_button.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/widgets/auth_text_field.dart';

import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';

class VehicleEditScreen extends StatefulWidget {
  final VehicleEntity vehicle;

  const VehicleEditScreen({super.key, required this.vehicle});

  @override
  State<VehicleEditScreen> createState() => _VehicleEditScreenState();
}

class _VehicleEditScreenState extends State<VehicleEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _regController;
  late VehicleType _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vehicle.vehicleName);
    _regController = TextEditingController(text: widget.vehicle.registrationNo);
    _selectedType = widget.vehicle.vehicleType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regController.dispose();
    super.dispose();
  }

  void _onUpdate() {
    final updatedVehicle = widget.vehicle.copyWith(
      vehicleName: _nameController.text.trim(),
      registrationNo: _regController.text.trim(),
      vehicleType: _selectedType,
    );

    context.read<VehicleBloc>().add(UpdateVehicleEvent(updatedVehicle));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleBloc, VehicleState>(
      listener: (context, state) {
        if (state is VehicleUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle updated successfully')),
          );
          context.pop();
        } else if (state is VehicleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Vehicle')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              VehicleTypeSelector(
                selectedType: _selectedType,
                onTypeSelected: (type) => setState(() => _selectedType = type),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: _nameController,
                label: 'Vehicle Name',
                prefixIcon: Icons.directions_car,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _regController,
                label: 'Registration Number',
                prefixIcon: Icons.badge,
              ),
              const SizedBox(height: 32),
              BlocBuilder<VehicleBloc, VehicleState>(
                builder: (context, state) {
                  return AuthButton(
                    text: 'Save Changes',
                    isLoading: state is VehicleLoading,
                    onPressed: _onUpdate,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}