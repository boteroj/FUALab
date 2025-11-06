from functools import lru_cache

from fastapi import FastAPI
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    service_name: str = "FUALab API"
    database_url: str = "postgresql+asyncpg://postgres:postgres@db:5432/fualab"
    redis_url: str = "redis://redis:6379/0"

    class Config:
        env_prefix = "FUALAB_"
        env_file = ".env"


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
app = FastAPI(title=settings.service_name)


@app.get("/health", tags=["Health"])
async def healthcheck() -> dict[str, str]:
    return {
        "status": "ok",
        "service": settings.service_name,
    }

