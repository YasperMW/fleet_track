import 'package:flutter/material.dart';

export 'api_client.dart' show ApiException;

import '../models/models.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient _client = ApiClient();

  ApiClient get client => _client;

  // ── Auth ────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await _client.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    await _client.setToken(data['access_token']);
    return data['user'];
  }

  Future<void> logout() => _client.clearToken();

  Future<Map<String, dynamic>> getCurrentUser() async {
    final data = await _client.get('/auth/me');
    return data;
  }

  // ── Vehicles ────────────────────────────────────────────
  Future<List<Vehicle>> getVehicles() async {
    final data = await _client.get('/vehicles/') as List;
    return data.map((v) => _vehicleFromJson(v)).toList();
  }

  Future<Vehicle> getVehicle(String id) async {
    final data = await _client.get('/vehicles/$id');
    return _vehicleFromJson(data);
  }

  // ── Reports ─────────────────────────────────────────────
  Future<Map<String, dynamic>> getReportSummary() async {
    final data = await _client.get('/reports/summary');
    return data;
  }

  // ── Alerts ──────────────────────────────────────────────
  Future<List<AlertItem>> getAlerts({String? vehicleId}) async {
    final query = vehicleId != null ? {'vehicle_id': vehicleId} : null;
    final data = await _client.get('/alerts/', query: query) as List;
    return data.map((a) => _alertFromJson(a)).toList();
  }

  Future<void> deleteAlert(String id) async {
    await _client.delete('/alerts/$id');
  }

  Future<void> clearAllAlerts() async {
    await _client.delete('/alerts/');
  }

  // ── Vehicles ────────────────────────────────────────────
  Future<Vehicle> createVehicle(Map<String, dynamic> data) async {
    final result = await _client.post('/vehicles/', body: data);
    return _vehicleFromJson(result);
  }

  // ── Trips ───────────────────────────────────────────────
  Future<List<TripRecord>> getTrips({String? vehicleId, bool? activeOnly}) async {
    final query = <String, String>{};
    if (vehicleId != null) query['vehicle_id'] = vehicleId;
    if (activeOnly != null) query['active_only'] = activeOnly.toString();
    final data = await _client.get('/trips/', query: query.isNotEmpty ? query : null) as List;
    return data.map((t) => _tripFromJson(t)).toList();
  }

  Future<TripRecord> createTrip(Map<String, dynamic> data) async {
    final result = await _client.post('/trips/', body: data);
    return _tripFromJson(result);
  }

  // ── Route Points ────────────────────────────────────────
  Future<Map<String, dynamic>> addRoutePoints(String tripId, List<Map<String, dynamic>> points) async {
    final data = await _client.post('/trips/$tripId/points', body: points);
    return data;
  }

  Future<List<RoutePoint>> getRoutePoints(String tripId) async {
    final data = await _client.get('/trips/$tripId/points') as List;
    return data.map((p) => _routePointFromJson(p)).toList();
  }

  // ── Geofences ───────────────────────────────────────────
  Future<List<Geofence>> getGeofences() async {
    final data = await _client.get('/geofences/') as List;
    return data.map((g) => _geofenceFromJson(g)).toList();
  }

  // ── Preferences ─────────────────────────────────────────
  Future<Map<String, dynamic>> getPreferences() async {
    final data = await _client.get('/preferences/');
    return data;
  }

  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> body) async {
    final data = await _client.patch('/preferences/', body: body);
    return data;
  }

  // ── Users ───────────────────────────────────────────────
  Future<Map<String, dynamic>> inviteUser(String email, String password, String name) async {
    final data = await _client.post('/auth/register', body: {
      'email': email,
      'password': password,
      'name': name,
    });
    return data;
  }


  Future<List<AppUser>> getUsers() async {
    final data = await _client.get('/auth/users') as List;
    return data.map((u) => _userFromJson(u)).toList();
  }

  // ── JSON parsers ────────────────────────────────────────
  Vehicle _vehicleFromJson(Map<String, dynamic> v) {
    return Vehicle(
      id: v['id'],
      name: v['name'],
      plate: v['plate'],
      status: VehicleStatus.values.firstWhere(
        (s) => s.name == v['status'],
        orElse: () => VehicleStatus.parked,
      ),
      speed: (v['speed'] as num).toDouble(),
      location: v['location'] ?? '',
      icon: _iconFromString(v['icon_name']),
      mileage: v['mileage'] ?? 0,
      lat: (v['lat'] as num?)?.toDouble(),
      lng: (v['lng'] as num?)?.toDouble(),
    );
  }

  AlertItem _alertFromJson(Map<String, dynamic> a) {
    return AlertItem(
      title: a['title'],
      message: a['message'] ?? '',
      time: a['time'] ?? '',
      severity: AlertSeverity.values.firstWhere(
        (s) => s.name == a['severity'],
        orElse: () => AlertSeverity.info,
      ),
      vehicleId: a['vehicle_id'],
    );
  }

  RoutePoint _routePointFromJson(Map<String, dynamic> p) {
    return RoutePoint(
      id: p['id'],
      tripId: p['trip_id'],
      lat: (p['lat'] as num).toDouble(),
      lng: (p['lng'] as num).toDouble(),
      recordedAt: p['recorded_at'] ?? '',
    );
  }

  TripRecord _tripFromJson(Map<String, dynamic> t) {
    return TripRecord(
      id: t['id'],
      vehicleId: t['vehicle_id'],
      startTime: t['start_time'] ?? '',
      endTime: t['end_time'] ?? '',
      distanceKm: (t['distance_km'] as num).toDouble(),
      durationHrs: (t['duration_hrs'] as num).toDouble(),
      avgSpeed: (t['avg_speed'] as num).toDouble(),
      origin: t['origin'] ?? '',
      destination: t['destination'] ?? '',
      isActive: t['is_active'] ?? false,
    );
  }

  Geofence _geofenceFromJson(Map<String, dynamic> g) {
    return Geofence(
      id: g['id'],
      name: g['name'],
      zoneType: g['zone_type'] ?? 'circular',
      radiusM: g['radius_m'],
      lat: (g['lat'] as num).toDouble(),
      lng: (g['lng'] as num).toDouble(),
      status: g['status'] ?? 'active',
      triggerOn: g['trigger_on'] ?? 'enter_exit',
    );
  }

  AppUser _userFromJson(Map<String, dynamic> u) {
    final name = u['name'] ?? '';
    final parts = name.split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty ? name[0].toUpperCase() : '??';
    final color = switch (u['role']) {
      'Admin' => const Color(0xFF00D4AA),
      'Manager' => const Color(0xFF4C8EFF),
      _ => const Color(0xFFFFB930),
    };
    return AppUser(
      initials: initials,
      name: name,
      email: u['email'] ?? '',
      role: u['role'] ?? 'Viewer',
      avatarColor: color,
    );
  }

  IconData _iconFromString(String? name) {
    switch (name) {
      case 'airport_shuttle_rounded':
        return Icons.airport_shuttle_rounded;
      case 'local_shipping_rounded':
        return Icons.local_shipping_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }
}
