from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "sqlite+aiosqlite:///./fleet_track.db"
    secret_key: str = "change-this-to-a-random-secret-key-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 1440

    model_config = {"env_file": ".env"}


settings = Settings()
