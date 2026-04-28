import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String address;
  final String? doctor;
  final String? emergencyContact;
  final List<String> medications;
  final DateTime createdAt;
  final bool isActive;
  final String? photoUrl; // Nueva propiedad para la foto

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    this.doctor,
    this.emergencyContact,
    required this.medications,
    required this.createdAt,
    required this.isActive,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
      'doctor': doctor,
      'emergencyContact': emergencyContact,
      'medications': medications,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      phone: map['phone'],
      address: map['address'],
      doctor: map['doctor'],
      emergencyContact: map['emergencyContact'],
      medications: List<String>.from(map['medications']),
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'],
      photoUrl: map['photoUrl'],
    );
  }

  Color getRoleColor() {
    switch (role) {
      case 'Adulto Mayor':
        return Colors.teal;
      case 'Familiar/Cuidador':
        return Colors.orange;
      case 'Médico':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getRoleIcon() {
    switch (role) {
      case 'Adulto Mayor':
        return Icons.elderly;
      case 'Familiar/Cuidador':
        return Icons.family_restroom;
      case 'Médico':
        return Icons.local_hospital;
      default:
        return Icons.person;
    }
  }

  String getInitials() {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  String getStatusText() {
    return isActive ? 'Activo' : 'Inactivo';
  }

  Color getStatusColor() {
    return isActive ? Colors.green : Colors.red;
  }

  IconData getStatusIcon() {
    return isActive ? Icons.check_circle : Icons.cancel;
  }

  int getMedicationCount() {
    return medications.length;
  }

  String getFormattedCreatedAt() {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String getRoleDisplayName() {
    switch (role) {
      case 'Adulto Mayor':
        return '👴 Adulto Mayor';
      case 'Familiar/Cuidador':
        return '👨‍👩‍👧 Familiar/Cuidador';
      case 'Médico':
        return '👨‍⚕️ Médico';
      default:
        return '👤 Usuario';
    }
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? doctor,
    String? emergencyContact,
    List<String>? medications,
    DateTime? createdAt,
    bool? isActive,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      doctor: doctor ?? this.doctor,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      medications: medications ?? this.medications,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  bool isComplete() {
    return name.isNotEmpty &&
           email.isNotEmpty &&
           phone.isNotEmpty &&
           address.isNotEmpty &&
           role.isNotEmpty;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}