import asyncio

from sqlalchemy import select

from .auth import hash_password
from .database import async_session, init_db
from .models import AlertItem, Geofence, TripRecord, User, Vehicle


async def seed():
    await init_db()

    async with async_session() as session:
        result = await session.execute(select(User).limit(1))
        if result.scalar_one_or_none():
            print("Database already seeded, skipping.")
            return

        users = [
            User(id="admin", name="Fleet Manager", email="admin@fleet.co", hashed_password=hash_password("admin123"), role="Admin"),
            User(name="James K.", email="james@fleet.co", hashed_password=hash_password("james123"), role="Manager"),
            User(name="Sarah P.", email="sarah@fleet.co", hashed_password=hash_password("sarah123"), role="Manager"),
            User(name="Ben M.", email="ben@fleet.co", hashed_password=hash_password("ben123"), role="Viewer"),
        ]
        session.add_all(users)

        vehicles = [
            Vehicle(id="v1", name="Toyota Hiace", plate="MWI-2341", status="moving", speed=62, location="M1 Road, Lilongwe", mileage=45230, lat=-13.9600, lng=33.7800, icon_name="airport_shuttle_rounded"),
            Vehicle(id="v2", name="Isuzu Pickup", plate="MWI-5512", status="parked", speed=0, location="Mzuzu Depot, Area 18", mileage=38110, lat=-13.9850, lng=33.7880, icon_name="local_shipping_rounded"),
            Vehicle(id="v3", name="Mitsubishi L200", plate="MWI-7789", status="alert", speed=0, location="Mzuzu M1 Rd", mileage=19111, lat=-13.9700, lng=33.7700, icon_name="directions_car_rounded"),
        ]
        session.add_all(vehicles)

        alerts = [
            AlertItem(title="V3 — Tamper detected", message="Device cover opened at 14:32 · Mzuzu M1 Rd", time="14:32", severity="critical", vehicle_id="v3"),
            AlertItem(title="V1 — Speed limit exceeded", message="Toyota Hiace exceeded 80 km/h on M1 Road", time="09:15", severity="warning", vehicle_id="v1"),
            AlertItem(title="V2 — Geofence exit", message="Isuzu Pickup left Mzuzu Depot zone", time="08:44", severity="info", vehicle_id="v2"),
            AlertItem(title="V1 — Low battery", message="GPS device battery at 12%", time="07:30", severity="warning", vehicle_id="v1"),
        ]
        session.add_all(alerts)

        trips = [
            TripRecord(id="t1", vehicle_id="v1", start_time="07:14", end_time="09:41", distance_km=142, duration_hrs=2.45, avg_speed=58, origin="Mzuzu Depot, Area 18", destination="M1 Road · In Progress", is_active=True),
            TripRecord(id="t2", vehicle_id="v1", start_time="13:10", end_time="16:45", distance_km=203, duration_hrs=3.58, avg_speed=57, origin="Lilongwe City Centre", destination="Kasungu Depot", is_active=False),
        ]
        session.add_all(trips)

        geofences = [
            Geofence(name="Mzuzu Depot", zone_type="circular", radius_m=500, lat=-11.4643, lng=34.0155, status="active", trigger_on="enter_exit"),
            Geofence(name="Lilongwe CBD", zone_type="circular", radius_m=1200, lat=-13.9833, lng=33.7833, status="active", trigger_on="exit_only"),
            Geofence(name="Restricted Zone A", zone_type="polygon", radius_m=None, lat=-13.9700, lng=33.7700, status="paused", trigger_on="enter_only"),
        ]
        session.add_all(geofences)

        await session.commit()
        print("Database seeded successfully!")


if __name__ == "__main__":
    asyncio.run(seed())
