from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..auth import get_current_user
from ..database import get_db
from ..models import User, Vehicle
from ..schemas import VehicleCreate, VehicleOut, VehicleUpdate

router = APIRouter(prefix="/vehicles", tags=["vehicles"])


@router.get("/", response_model=List[VehicleOut])
async def list_vehicles(
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(Vehicle).order_by(Vehicle.name))
    return [VehicleOut.model_validate(v) for v in result.scalars()]


@router.get("/{vehicle_id}", response_model=VehicleOut)
async def get_vehicle(
    vehicle_id: str,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(Vehicle).where(Vehicle.id == vehicle_id))
    vehicle = result.scalar_one_or_none()
    if not vehicle:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Vehicle not found")
    return VehicleOut.model_validate(vehicle)


@router.post("/", response_model=VehicleOut, status_code=status.HTTP_201_CREATED)
async def create_vehicle(
    body: VehicleCreate,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    vehicle = Vehicle(**body.model_dump())
    db.add(vehicle)
    await db.commit()
    await db.refresh(vehicle)
    return VehicleOut.model_validate(vehicle)


@router.patch("/{vehicle_id}", response_model=VehicleOut)
async def update_vehicle(
    vehicle_id: str,
    body: VehicleUpdate,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(Vehicle).where(Vehicle.id == vehicle_id))
    vehicle = result.scalar_one_or_none()
    if not vehicle:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Vehicle not found")

    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(vehicle, field, value)

    await db.commit()
    await db.refresh(vehicle)
    return VehicleOut.model_validate(vehicle)
