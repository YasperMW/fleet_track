from datetime import datetime, timedelta

from fastapi import APIRouter, Depends
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from ..auth import get_current_user
from ..database import get_db
from ..models import AlertItem, TripRecord, User, Vehicle

router = APIRouter(prefix="/reports", tags=["reports"])


@router.get("/summary")
async def get_summary(
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    mileage_result = await db.execute(select(func.sum(Vehicle.mileage)))
    total_mileage = mileage_result.scalar() or 0

    trips_result = await db.execute(select(func.count(TripRecord.id)))
    total_trips = trips_result.scalar() or 0

    alerts_result = await db.execute(select(func.count(AlertItem.id)))
    total_alerts = alerts_result.scalar() or 0

    today = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    daily = []
    for i in range(6, -1, -1):
        day_start = today - timedelta(days=i)
        day_end = day_start + timedelta(days=1)
        stmt = select(func.coalesce(func.sum(TripRecord.distance_km), 0)).where(
            TripRecord.created_at >= day_start, TripRecord.created_at < day_end
        )
        result = await db.execute(stmt)
        daily.append(float(result.scalar() or 0))

    return {
        "total_mileage": total_mileage,
        "total_trips": total_trips,
        "total_alerts": total_alerts,
        "daily_mileage": daily,
        "week_days": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
        "date_range_start": (today - timedelta(days=6)).strftime("%d %b %Y"),
        "date_range_end": today.strftime("%d %b %Y"),
    }
