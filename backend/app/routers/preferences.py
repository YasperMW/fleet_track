from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ..auth import get_current_user
from ..database import get_db
from ..models import User, UserPreference
from ..schemas import PreferenceOut, PreferenceUpdate

router = APIRouter(prefix="/preferences", tags=["preferences"])


async def _get_or_create_prefs(
    user_id: str, db: AsyncSession
) -> UserPreference:
    result = await db.execute(
        select(UserPreference).where(UserPreference.user_id == user_id)
    )
    prefs = result.scalar_one_or_none()
    if prefs is None:
        prefs = UserPreference(user_id=user_id)
        db.add(prefs)
        await db.commit()
        await db.refresh(prefs)
    return prefs


@router.get("/", response_model=PreferenceOut)
async def get_preferences(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    prefs = await _get_or_create_prefs(current_user.id, db)
    return PreferenceOut.model_validate(prefs)


@router.patch("/", response_model=PreferenceOut)
async def update_preferences(
    body: PreferenceUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    prefs = await _get_or_create_prefs(current_user.id, db)
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(prefs, field, value)
    await db.commit()
    await db.refresh(prefs)
    return PreferenceOut.model_validate(prefs)
