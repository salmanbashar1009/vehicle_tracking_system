import 'package:flutter/material.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleTypeSelector extends StatelessWidget {
  final VehicleType selectedType;
  final ValueChanged<VehicleType> onTypeSelected;

  const VehicleTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: VehicleType.values.map((type) {
            final isSelected = type == selectedType;
            return ChoiceChip(
              avatar: Text(type.emoji),
              label: Text(type.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onTypeSelected(type);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}