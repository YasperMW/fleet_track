from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import init_db
from app.routers import alerts, auth_router, geofences, preferences, reports, trips, vehicles


@asynccontextmanager
async def lifespan(_: FastAPI):
    await init_db()
    yield


app = FastAPI(title="FleetTrack API", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router.router)
app.include_router(vehicles.router)
app.include_router(alerts.router)
app.include_router(geofences.router)
app.include_router(trips.router)
app.include_router(preferences.router)
app.include_router(reports.router)


@app.get("/")
async def root():
    return {"message": "FleetTrack API"}
