import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, Float, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .database import Base

vehicle_status_enum = Enum("moving", "parked", "alert", name="vehicle_status")
alert_severity_enum = Enum("critical", "warning", "info", name="alert_severity")


class UserPreference(Base):
    __tablename__ = "user_preferences"

    user_id: Mapped[str] = mapped_column(String, ForeignKey("users.id"), primary_key=True)
    push_alerts: Mapped[bool] = mapped_column(Boolean, default=True)
    speed_alerts: Mapped[bool] = mapped_column(Boolean, default=True)
    email_reports: Mapped[bool] = mapped_column(Boolean, default=False)
    update_interval: Mapped[int] = mapped_column(default=5)
    geofence_precision: Mapped[str] = mapped_column(String(20), default="high")


class User(Base):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4())[:8])
    name: Mapped[str] = mapped_column(String(100))
    email: Mapped[str] = mapped_column(String(100), unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255))
    role: Mapped[str] = mapped_column(String(20), default="Viewer")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


class Vehicle(Base):
    __tablename__ = "vehicles"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4())[:8])
    name: Mapped[str] = mapped_column(String(100))
    plate: Mapped[str] = mapped_column(String(20), unique=True)
    status: Mapped[str] = mapped_column(vehicle_status_enum, default="parked")
    speed: Mapped[float] = mapped_column(Float, default=0.0)
    location: Mapped[str] = mapped_column(String(200), default="")
    mileage: Mapped[int] = mapped_column(default=0)
    lat: Mapped[float | None] = mapped_column(Float, nullable=True)
    lng: Mapped[float | None] = mapped_column(Float, nullable=True)
    icon_name: Mapped[str] = mapped_column(String(50), default="directions_car_rounded")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    alerts: Mapped[list["AlertItem"]] = relationship(back_populates="vehicle", cascade="all, delete-orphan")
    trips: Mapped[list["TripRecord"]] = relationship(back_populates="vehicle", cascade="all, delete-orphan")


class AlertItem(Base):
    __tablename__ = "alerts"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4())[:8])
    title: Mapped[str] = mapped_column(String(200))
    message: Mapped[str] = mapped_column(Text, default="")
    time: Mapped[str] = mapped_column(String(20), default="")
    severity: Mapped[str] = mapped_column(alert_severity_enum, default="info")
    vehicle_id: Mapped[str] = mapped_column(String, ForeignKey("vehicles.id"))
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    vehicle: Mapped["Vehicle"] = relationship(back_populates="alerts")


class TripRecord(Base):
    __tablename__ = "trips"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4())[:8])
    vehicle_id: Mapped[str] = mapped_column(String, ForeignKey("vehicles.id"))
    start_time: Mapped[str] = mapped_column(String(20), default="")
    end_time: Mapped[str] = mapped_column(String(20), default="")
    distance_km: Mapped[float] = mapped_column(Float, default=0.0)
    duration_hrs: Mapped[float] = mapped_column(Float, default=0.0)
    avg_speed: Mapped[float] = mapped_column(Float, default=0.0)
    origin: Mapped[str] = mapped_column(String(200), default="")
    destination: Mapped[str] = mapped_column(String(200), default="")
    is_active: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

    vehicle: Mapped["Vehicle"] = relationship(back_populates="trips")


class RoutePoint(Base):
    __tablename__ = "route_points"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4())[:8])
    trip_id: Mapped[str] = mapped_column(String, ForeignKey("trips.id"))
    lat: Mapped[float] = mapped_column(Float)
    lng: Mapped[float] = mapped_column(Float)
    recorded_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


class Geofence(Base):
    __tablename__ = "geofences"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4())[:8])
    name: Mapped[str] = mapped_column(String(100))
    zone_type: Mapped[str] = mapped_column(String(30), default="circular")
    radius_m: Mapped[int | None] = mapped_column(default=None)
    lat: Mapped[float] = mapped_column(Float)
    lng: Mapped[float] = mapped_column(Float)
    status: Mapped[str] = mapped_column(String(20), default="active")
    trigger_on: Mapped[str] = mapped_column(String(50), default="enter_exit")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
