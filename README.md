# FleetTrack

A fleet vehicle tracking app built with Flutter, backed by a FastAPI + SQLite API.
The UI uses a dark navy theme, Material Design 3, and live OpenStreetMap tiles.

![Flutter](https://img.shields.io/badge/Flutter-3.38%2B-02569B?logo=flutter)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115-009688?logo=fastapi)
![Python](https://img.shields.io/badge/Python-3.10--3.13-3776AB?logo=python)

## Features

- Live map with vehicle markers, legend, and fleet status overlay
- Vehicle list with search, status filters, and add/edit vehicle flows
- Alert management with severity filters and resolve actions
- Reports with mileage charts, vehicle breakdown, and trip logs
- Trip history and route replay
- Geofence management
- User preferences, user management, and JWT authentication

## Screens

| Tab | Description |
|-----|-------------|
| Map | Live map with vehicle dots and fleet status |
| Fleet | Vehicle list, filters, and add vehicle |
| Alerts | Alert list with severity filters |
| Reports | Mileage charts, breakdown, and trip log |
| Settings | Profile, notifications, users, and organization settings |

Sub-screens include vehicle detail, trip history, route replay, geofences, and security settings.

## Tech Stack

**Client:** Flutter, Dart, `flutter_map`, `latlong2`, `google_fonts`, `http`, `shared_preferences`, `geolocator`, `url_launcher`

**Server:** FastAPI, SQLAlchemy (async), SQLite, `python-jose` (JWT), `passlib` + `bcrypt`

## Project Structure

```
.
├── lib/                      # Flutter app
│   ├── main.dart
│   ├── models/               # Data models
│   ├── screens/              # App screens
│   ├── services/             # API client and service layer
│   ├── theme/                # Colors and ThemeData
│   └── widgets/              # Shared widgets
├── backend/                  # FastAPI server
│   ├── main.py               # App entry point
│   ├── requirements.txt
│   └── app/
│       ├── auth.py           # JWT + password hashing
│       ├── config.py         # Environment settings
│       ├── database.py       # Async engine and session
│       ├── models.py         # SQLAlchemy models
│       ├── schemas.py        # Pydantic schemas
│       ├── seed.py           # Demo data seeder
│       └── routers/          # API route modules
├── docs/
│   └── ui-design.html        # Original UI design prototype
├── test/                     # Flutter widget tests
├── android/ ios/ web/ ...    # Platform projects
└── pubspec.yaml
```

## Getting Started

### Prerequisites

- Flutter 3.38+ with Dart 3.11+
- Python 3.10–3.13 (the pinned `pydantic` version does not support Python 3.14)
- (Optional) An Android emulator or physical device

### 1. Run the backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python -m app.seed
uvicorn main:app --reload
```

The API runs at `http://localhost:8000`. Interactive docs are available at
`http://localhost:8000/docs`.

`python -m app.seed` creates the tables and inserts demo data. It is safe to
run again: it skips seeding if users already exist.

### 2. Run the app

```bash
flutter pub get
flutter run
```

The app reads its API URL from the `API_BASE_URL` compile-time variable and
defaults to `http://localhost:8000`.

```bash
# Android emulator (host machine is reachable at 10.0.2.2)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Physical device (use your computer's LAN IP)
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
```

### Build

```bash
flutter build apk --release
flutter build ios --release   # macOS + Xcode required
flutter build web
```

### Tests

```bash
flutter test
flutter analyze
```

## Demo Accounts

The seeder creates the following development-only accounts:

| Email | Password | Role |
|-------|----------|------|
| `admin@fleet.co` | `admin123` | Admin |
| `james@fleet.co` | `james123` | Manager |
| `sarah@fleet.co` | `sarah123` | Manager |
| `ben@fleet.co` | `ben123` | Viewer |

The login screen is pre-filled with the admin account for convenience.

## Configuration

Backend settings are read from environment variables or `backend/.env`:

| Variable | Default | Description |
|----------|---------|-------------|
| `DATABASE_URL` | `sqlite+aiosqlite:///./fleet_track.db` | Async SQLAlchemy database URL |
| `SECRET_KEY` | insecure dev placeholder | JWT signing key |
| `ALGORITHM` | `HS256` | JWT algorithm |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `1440` | Token lifetime |

See `backend/.env.example` for a template. Never commit your real `.env`.

## API Overview

All routes except `/`, `/auth/login`, and `/auth/register` require a Bearer token.

| Prefix | Routes |
|--------|--------|
| `/auth` | `POST /login`, `POST /register`, `GET /me`, `GET /users` |
| `/vehicles` | `GET /`, `GET /{id}`, `POST /`, `PATCH /{id}` |
| `/alerts` | `GET /`, `POST /`, `DELETE /{id}`, `DELETE /` |
| `/geofences` | `GET /` |
| `/trips` | `GET /`, `POST /`, `PATCH /{id}/end`, `POST /{id}/points`, `GET /{id}/points` |
| `/preferences` | `GET /`, `PATCH /` |
| `/reports` | `GET /summary` |

## Design Tokens

| Token | Value |
|-------|-------|
| Navy (background) | `#0B1628` |
| Teal (primary) | `#00D4AA` |
| Amber (warning) | `#FFB930` |
| Red (alert) | `#FF4D6D` |
| Blue (accent) | `#4C8EFF` |
| Muted text | `#9FB3CE` |

Fonts: DM Sans (body), Syne (headings), Space Mono (plates, IDs, timestamps).

The original HTML prototype lives in `docs/ui-design.html`.

## Production Notes

This project is configured for local development. Before deploying publicly:

- Replace `SECRET_KEY` with a long random value and keep it out of source control.
- Remove or change the demo seed accounts and the pre-filled login credentials.
- Restrict CORS (`allow_origins`) to your app's domains.
- Disable or protect the open `/auth/register` endpoint as appropriate.
- Put the API behind HTTPS and use a production database.
