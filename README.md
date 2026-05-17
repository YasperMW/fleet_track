# FleetTrack — Flutter App

A professional fleet vehicle tracking mobile app built with Flutter.
Based on the FleetTrack improved UI design (dark navy theme, Material Design 3).

---

## 📱 Screens

### Main Navigation (Bottom Nav — 5 tabs)
| Tab | Screen | File |
|-----|--------|------|
| Map | Live map with vehicle dots, legend, fleet status overlay | `screens/map_screen.dart` |
| Fleet | Vehicle list with filter chips, FAB, empty state | `screens/fleet_screen.dart` |
| Alerts | Alert list with severity filter, resolve actions | `screens/alerts_screen.dart` |
| Reports | Mileage charts, vehicle breakdown, trip log | `screens/reports_screen.dart` |
| Settings | Profile, notifications, users, org settings | `screens/settings_screen.dart` |

### Sub-screens (pushed on Navigation)
| Screen | File |
|--------|------|
| Vehicle Detail | `screens/vehicle_detail_screen.dart` |
| Trip History | `screens/vehicle_detail_screen.dart` |
| Route Replay | `screens/vehicle_detail_screen.dart` |
| Add Vehicle | `screens/fleet_screen.dart` |
| Notifications Settings | `screens/settings_screen.dart` |
| User Management | `screens/settings_screen.dart` |

---

## 🎨 Design Tokens

| Token | Value |
|-------|-------|
| Navy (bg) | `#0B1628` |
| Teal (primary) | `#00D4AA` |
| Amber (warning) | `#FFB930` |
| Red (alert) | `#FF4D6D` |
| Blue (accent) | `#4C8EFF` |
| Muted text | `#9FB3CE` |

**Fonts:** DM Sans (body), Syne (headings), Space Mono (plates, IDs, timestamps)

---

## 🚀 Setup

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Install
```bash
flutter pub get
flutter run
```

### Build
```bash
# Android APK
flutter build apk --release

# iOS (requires macOS + Xcode)
flutter build ios --release

# Web
flutter build web
```

---

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry, MainShell (bottom nav)
├── theme/
│   └── app_theme.dart         # Colors, ThemeData, AppText helpers
├── models/
│   └── models.dart            # Vehicle, Alert, Trip, User models + sample data
├── widgets/
│   └── shared_widgets.dart    # FleetBottomNav, VehicleCard, AlertBanner,
│                              #   StatusTag, PrimaryButton, MapMock, etc.
└── screens/
    ├── map_screen.dart         # Live map screen
    ├── fleet_screen.dart       # Fleet list + AddVehicleScreen
    ├── vehicle_detail_screen.dart  # Detail + TripHistory + RouteReplay
    ├── alerts_screen.dart      # Alerts list
    ├── reports_screen.dart     # Reports + charts
    └── settings_screen.dart    # Settings + Notifications + UserManagement
```

---

## 🔌 Real Integration Notes

To connect to a real backend, replace `SampleData` with API calls:

- **Map:** Integrate `google_maps_flutter` or `flutter_map` for real maps
- **GPS data:** Connect to your fleet tracking API via HTTP/WebSocket
- **Auth:** Add Firebase Auth or your custom auth layer
- **Push notifications:** Add `firebase_messaging` for real-time alerts

---

## 📦 Dependencies

```yaml
google_fonts: ^6.1.0    # DM Sans, Syne, Space Mono
fl_chart: ^0.68.0       # Charts (ready to use in reports)
cupertino_icons: ^1.0.2
```
