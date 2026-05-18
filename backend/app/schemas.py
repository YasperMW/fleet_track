from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr


# ── Auth ──────────────────────────────────────────────────
class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: "UserOut"


class UserOut(BaseModel):
    id: str
    name: str
    email: str
    role: str

    model_config = {"from_attributes": True}


# ── Vehicle ───────────────────────────────────────────────
class VehicleOut(BaseModel):
    id: str
    name: str
    plate: str
    status: str
    speed: float
    location: str
    mileage: int
    lat: Optional[float] = None
    lng: Optional[float] = None
    icon_name: str

    model_config = {"from_attributes": True}


class VehicleCreate(BaseModel):
    name: str
    plate: str
    location: str = ""
    mileage: int = 0
    lat: Optional[float] = None
    lng: Optional[float] = None


class VehicleUpdate(BaseModel):
    name: Optional[str] = None
    status: Optional[str] = None
    speed: Optional[float] = None
    location: Optional[str] = None
    mileage: Optional[int] = None
    lat: Optional[float] = None
    lng: Optional[float] = None


# ── Alert ─────────────────────────────────────────────────
class AlertOut(BaseModel):
    id: str
    title: str
    message: str
    time: str
    severity: str
    vehicle_id: str

    model_config = {"from_attributes": True}


class AlertCreate(BaseModel):
    title: str
    message: str = ""
    time: str = ""
    severity: str = "info"
    vehicle_id: str


# ── Geofence ──────────────────────────────────────────────
class GeofenceOut(BaseModel):
    id: str
    name: str
    zone_type: str
    radius_m: Optional[int] = None
    lat: float
    lng: float
    status: str
    trigger_on: str

    model_config = {"from_attributes": True}


# ── Preferences ──────────────────────────────────────────
class PreferenceOut(BaseModel):
    push_alerts: bool = True
    speed_alerts: bool = True
    email_reports: bool = False
    update_interval: int = 5
    geofence_precision: str = "high"

    model_config = {"from_attributes": True}


class PreferenceUpdate(BaseModel):
    push_alerts: Optional[bool] = None
    speed_alerts: Optional[bool] = None
    email_reports: Optional[bool] = None
    update_interval: Optional[int] = None
    geofence_precision: Optional[str] = None


# ── Route Points ─────────────────────────────────────────
class RoutePointOut(BaseModel):
    id: str
    trip_id: str
    lat: float
    lng: float
    recorded_at: str

    model_config = {"from_attributes": True}


class RoutePointCreate(BaseModel):
    lat: float
    lng: float


# ── Trip ──────────────────────────────────────────────────
class TripOut(BaseModel):
    id: str
    vehicle_id: str
    start_time: str
    end_time: str
    distance_km: float
    duration_hrs: float
    avg_speed: float
    origin: str
    destination: str
    is_active: bool

    model_config = {"from_attributes": True}


class TripCreate(BaseModel):
    vehicle_id: str
    start_time: str = ""
    end_time: str = ""
    distance_km: float = 0.0
    duration_hrs: float = 0.0
    avg_speed: float = 0.0
    origin: str = ""
    destination: str = ""
    is_active: bool = False
