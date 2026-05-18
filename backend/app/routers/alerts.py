from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..auth import get_current_user
from ..database import get_db
from ..models import AlertItem, User
from sqlalchemy import delete as sa_delete
from ..schemas import AlertCreate, AlertOut

router = APIRouter(prefix="/alerts", tags=["alerts"])


@router.get("/", response_model=List[AlertOut])
async def list_alerts(
    vehicle_id: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    stmt = select(AlertItem).order_by(AlertItem.created_at.desc())
    if vehicle_id:
        stmt = stmt.where(AlertItem.vehicle_id == vehicle_id)
    result = await db.execute(stmt)
    return [AlertOut.model_validate(a) for a in result.scalars()]


@router.post("/", response_model=AlertOut, status_code=status.HTTP_201_CREATED)
async def create_alert(
    body: AlertCreate,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    alert = AlertItem(**body.model_dump())
    db.add(alert)
    await db.commit()
    await db.refresh(alert)
    return AlertOut.model_validate(alert)


@router.delete("/{alert_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_alert(
    alert_id: str,
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
):
    result = await db.execute(select(AlertItem).where(AlertItem.id == alert_id))
    alert = result.scalar_one_or_none()
    if not alert:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Alert not found")
    await db.delete(alert)
    await db.commit()


@router.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_all_alerts(
    db: AsyncSession = Depends(get_db),
    _: User = Depends(get_current_user),
    vehicle_id: Optional[str] = Query(None),
):
    stmt = sa_delete(AlertItem)
    if vehicle_id:
        stmt = stmt.where(AlertItem.vehicle_id == vehicle_id)
    await db.execute(stmt)
    await db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
