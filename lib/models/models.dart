import 'package:flutter/material.dart';

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
  final double? lat;
  final double? lng;

  const Vehicle({
    required this.id,
    required this.name,
    required this.plate,
    required this.status,
    required this.speed,
    required this.location,
    required this.icon,
    required this.mileage,
    this.lat,
    this.lng,
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

class RoutePoint {
  final String id;
  final String tripId;
  final double lat;
  final double lng;
  final String recordedAt;

  const RoutePoint({
    required this.id,
    required this.tripId,
    required this.lat,
    required this.lng,
    required this.recordedAt,
  });
}

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

class Geofence {
  final String id;
  final String name;
  final String zoneType;
  final int? radiusM;
  final double lat;
  final double lng;
  final String status;
  final String triggerOn;

  const Geofence({
    required this.id,
    required this.name,
    required this.zoneType,
    this.radiusM,
    required this.lat,
    required this.lng,
    required this.status,
    required this.triggerOn,
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


