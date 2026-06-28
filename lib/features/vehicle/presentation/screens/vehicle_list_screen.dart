import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_tracking_system/features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_tracking_system/features/vehicle/presentation/widgets/vehicle_card.dart';

import '../../domain/entities/vehicle_entity.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import '../widgets/vehicle_filter_chip.dart';

class VehicleListScreen extends StatefulWidget {
  final bool isDriverView;

  const VehicleListScreen({super.key, this.isDriverView = false});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  String? _selectedTypeFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(LoadVehiclesEvent());
  }

  void _applyFilters() {
    context.read<VehicleBloc>().add(
      FilterVehiclesEvent(
        vehicleType: _selectedTypeFilter,
        driverName: _searchQuery.isNotEmpty ? _searchQuery : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        actions: [
          if (widget.isDriverView)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push('/driver/vehicle/register'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by driver name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                    _applyFilters();
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _applyFilters();
              },
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                VehicleFilterChip(
                  label: 'All',
                  isSelected: _selectedTypeFilter == null,
                  onSelected: () {
                    setState(() => _selectedTypeFilter = null);
                    _applyFilters();
                  },
                ),
                ...VehicleType.values.map((type) => VehicleFilterChip(
                  label: '${type.emoji} ${type.displayName}',
                  isSelected: _selectedTypeFilter == type.name,
                  onSelected: () {
                    setState(() => _selectedTypeFilter = type.name);
                    _applyFilters();
                  },
                )),
              ],
            ),
          ),

          // Vehicle List
          Expanded(
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is VehicleError) {
                  return Center(child: Text(state.message));
                }

                if (state is VehiclesLoaded) {
                  final vehicles = state.filteredVehicles;

                  if (vehicles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No vehicles found', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return VehicleCard(
                        vehicle: vehicles[index],
                        onTap: () {
                          // Show details or navigate
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

