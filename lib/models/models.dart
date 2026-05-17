import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum VehicleStatus { moving, parked, alert }

class Vehicle {
  final String id;
  final String name;
  final String plate;
  final VehicleStatus status;
  final double speed;
  final String location;
  final IconData icon;
  final int mileage;

  const Vehicle({
    required this.id,
    required this.name,
    required this.plate,
    required this.status,
    required this.speed,
    required this.location,
    required this.icon,
    required this.mileage,
  });
}

class AlertItem {
  final String title;
  final String message;
  final String time;
  final AlertSeverity severity;
  final String vehicleId;

  const AlertItem({
    required this.title,
    required this.message,
    required this.time,
    required this.severity,
    required this.vehicleId,
  });
}

enum AlertSeverity { critical, warning, info }

class TripRecord {
  final String id;
  final String vehicleId;
  final String startTime;
  final String endTime;
  final double distanceKm;
  final double durationHrs;
  final double avgSpeed;
  final String origin;
  final String destination;
  final bool isActive;

  const TripRecord({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.durationHrs,
    required this.avgSpeed,
    required this.origin,
    required this.destination,
    required this.isActive,
  });
}

class AppUser {
  final String initials;
  final String name;
  final String email;
  final String role;
  final Color avatarColor;

  const AppUser({
    required this.initials,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarColor,
  });
}

// Sample data
class SampleData {
  static const vehicles = [
    Vehicle(
      id: 'v1',
      name: 'Toyota Hiace',
      plate: 'MWI-2341',
      status: VehicleStatus.moving,
      speed: 62,
      location: 'M1 Road, Lilongwe',
      icon: Icons.airport_shuttle_rounded,
      mileage: 45230,
    ),
    Vehicle(
      id: 'v2',
      name: 'Isuzu Pickup',
      plate: 'MWI-5512',
      status: VehicleStatus.parked,
      speed: 0,
      location: 'Mzuzu Depot, Area 18',
      icon: Icons.local_shipping_rounded,
      mileage: 38110,
    ),
    Vehicle(
      id: 'v3',
      name: 'Mitsubishi L200',
      plate: 'MWI-7789',
      status: VehicleStatus.alert,
      speed: 0,
      location: 'Mzuzu M1 Rd',
      icon: Icons.directions_car_rounded,
      mileage: 19111,
    ),
  ];

  static const alerts = [
    AlertItem(
      title: 'V3 — Tamper detected',
      message: 'Device cover opened at 14:32 · Mzuzu M1 Rd',
      time: '14:32',
      severity: AlertSeverity.critical,
      vehicleId: 'v3',
    ),
    AlertItem(
      title: 'V1 — Speed limit exceeded',
      message: 'Toyota Hiace exceeded 80 km/h on M1 Road',
      time: '09:15',
      severity: AlertSeverity.warning,
      vehicleId: 'v1',
    ),
    AlertItem(
      title: 'V2 — Geofence exit',
      message: 'Isuzu Pickup left Mzuzu Depot zone',
      time: '08:44',
      severity: AlertSeverity.info,
      vehicleId: 'v2',
    ),
    AlertItem(
      title: 'V1 — Low battery',
      message: 'GPS device battery at 12%',
      time: '07:30',
      severity: AlertSeverity.warning,
      vehicleId: 'v1',
    ),
  ];

  static final trips = [
    const TripRecord(
      id: 't1',
      vehicleId: 'v1',
      startTime: '07:14',
      endTime: '09:41',
      distanceKm: 142,
      durationHrs: 2.45,
      avgSpeed: 58,
      origin: 'Mzuzu Depot, Area 18',
      destination: 'M1 Road · In Progress',
      isActive: true,
    ),
    const TripRecord(
      id: 't2',
      vehicleId: 'v1',
      startTime: '13:10',
      endTime: '16:45',
      distanceKm: 203,
      durationHrs: 3.58,
      avgSpeed: 57,
      origin: 'Lilongwe City Centre',
      destination: 'Kasungu Depot',
      isActive: false,
    ),
  ];

  static const users = [
    AppUser(
      initials: 'FM',
      name: 'Fleet Manager',
      email: 'admin@fleet.co',
      role: 'Admin',
      avatarColor: AppColors.teal,
    ),
    AppUser(
      initials: 'JK',
      name: 'James K.',
      email: 'james@fleet.co',
      role: 'Manager',
      avatarColor: AppColors.blue,
    ),
    AppUser(
      initials: 'SP',
      name: 'Sarah P.',
      email: 'sarah@fleet.co',
      role: 'Manager',
      avatarColor: AppColors.amber,
    ),
    AppUser(
      initials: 'BM',
      name: 'Ben M.',
      email: 'ben@fleet.co',
      role: 'Viewer',
      avatarColor: Color(0xFF8B5CF6),
    ),
  ];

  static const weeklyMileage = [120.0, 180.0, 150.0, 210.0, 95.0, 160.0, 200.0];
  static const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
}
