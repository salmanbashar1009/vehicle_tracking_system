import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime? createdAt;

  const DriverEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, phone, createdAt];

  DriverEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}