import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vehicle_tracking_system/core/constants/app_constants.dart';
import 'package:vehicle_tracking_system/features/map/presentation/bloc/map_bloc.dart';

import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/vehicle_marker.dart';
import '../widgets/vehicle_bottom_sheet.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(LoadMapDataEvent());
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MapBloc>().add(LoadMapDataEvent()),
          ),
        ],
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading || state is MapInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is MapLoaded) {
            // Handle map centering
            if (state.centerOn != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mapController.move(state.centerOn!, 15.0);
              });
            }

            final markers = state.vehicles
                .where((v) => v.location != null)
                .map((v) => VehicleMarker.createMarker(
              vehicleWithLocation: v,
              isSelected: state.selectedVehicleId == v.vehicle.id,
              onTap: () {
                context.read<MapBloc>().add(SelectVehicleEvent(v.vehicle.id));
                _showBottomSheet(context, state, v.vehicle.id);
              },
            ))
                .toList();

            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(
                      AppConstants.initialLatitude,
                      AppConstants.initialLongitude,
                    ),
                    zoom: AppConstants.defaultMapZoom,
                    onTap: (_, _) {
                      context.read<MapBloc>().add(DeselectVehicleEvent());
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // Close bottom sheet if open
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.vehicletracker.app',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),

                // Map Legend
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Active: ${state.vehicles.where((v) => v.vehicle.isTracking).length}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('Total: ${state.vehicles.length}', style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, MapLoaded state, String vehicleId) {
    final vehicleData = state.vehicles.firstWhere((v) => v.vehicle.id == vehicleId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => VehicleBottomSheet(
        vehicle: vehicleData.vehicle,
        driver: vehicleData.driver,
        location: vehicleData.location,
        onCenterMap: () {
          if (vehicleData.location != null) {
            context.read<MapBloc>().add(
              CenterOnVehicleEvent(
                vehicleId: vehicleId,
                latitude: vehicleData.location!.latitude,
                longitude: vehicleData.location!.longitude,
              ),
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
