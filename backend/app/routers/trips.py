from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..auth import get_current_user
from ..database import get_db
from ..models import RoutePoint, TripRecord, User
from ..schemas import RoutePointCreate, RoutePointOut, TripCreate, TripOut
from datetime import datetime

router = APIRouter(prefix="/trips", tags=["trips"])


@router.get("/", response_model=List[TripOut])
async def list_trips(
    vehicle_id: Optional[str] = Query(None),
    active_only: Optional[bool] = Query(None),
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    stmt = select(TripRecord).order_by(TripRecord.created_at.desc())
    if vehicle_id:
        stmt = stmt.where(TripRecord.vehicle_id == vehicle_id)
    if active_only is True:
        stmt = stmt.where(TripRecord.is_active.is_(True))
    result = await db.execute(stmt)
    return [TripOut.model_validate(t) for t in result.scalars()]


@router.post("/", response_model=TripOut, status_code=status.HTTP_201_CREATED)
async def create_trip(
    body: TripCreate,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    trip = TripRecord(**body.model_dump())
    db.add(trip)
    await db.commit()
    await db.refresh(trip)
    return TripOut.model_validate(trip)


@router.patch("/{trip_id}/end", response_model=TripOut)
async def end_trip(
    trip_id: str,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(TripRecord).where(TripRecord.id == trip_id))
    trip = result.scalar_one_or_none()
    if not trip:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
    trip.is_active = False
    await db.commit()
    await db.refresh(trip)
    return TripOut.model_validate(trip)


@router.post("/{trip_id}/points", status_code=status.HTTP_201_CREATED)
async def add_route_points(
    trip_id: str,
    body: List[RoutePointCreate],
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(TripRecord).where(TripRecord.id == trip_id))
    if not result.scalar_one_or_none():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
    now = datetime.utcnow()
    points = [
        RoutePoint(trip_id=trip_id, lat=p.lat, lng=p.lng, recorded_at=now)
        for p in body
    ]
    db.add_all(points)
    await db.commit()
    return {"count": len(points)}


@router.get("/{trip_id}/points", response_model=List[RoutePointOut])
async def get_route_points(
    trip_id: str,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(TripRecord).where(TripRecord.id == trip_id))
    if not result.scalar_one_or_none():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
    stmt = (
        select(RoutePoint)
        .where(RoutePoint.trip_id == trip_id)
        .order_by(RoutePoint.recorded_at)
    )
    result = await db.execute(stmt)
    return [RoutePointOut.model_validate(p) for p in result.scalars()]
