from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..auth import get_current_user
from ..database import get_db
from ..models import Geofence, User
from ..schemas import GeofenceOut

router = APIRouter(prefix="/geofences", tags=["geofences"])


@router.get("/", response_model=List[GeofenceOut])
async def list_geofences(
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(Geofence).order_by(Geofence.name))
    return [GeofenceOut.model_validate(g) for g in result.scalars()]
