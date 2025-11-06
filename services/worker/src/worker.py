import asyncio
import logging
from contextlib import asynccontextmanager
from datetime import datetime, timezone

import asyncpg
import redis.asyncio as redis
from pydantic_settings import BaseSettings

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")


class Settings(BaseSettings):
    service_name: str = "FUALab Worker"
    database_url: str = "postgresql://postgres:postgres@db:5432/fualab"
    redis_url: str = "redis://redis:6379/0"
    heartbeat_interval_seconds: int = 15
    heartbeat_key: str = "fualab:worker:heartbeat"
    heartbeat_ttl_seconds: int = 45

    class Config:
        env_prefix = "FUALAB_"
        env_file = ".env"


settings = Settings()


@asynccontextmanager
async def postgres_pool():
    pool = await asyncpg.create_pool(dsn=settings.database_url, min_size=1, max_size=4)
    try:
        yield pool
    finally:
        await pool.close()


async def ensure_database(pool: asyncpg.Pool) -> None:
    async with pool.acquire() as connection:
        await connection.execute("SELECT 1;")


async def heartbeat_task() -> None:
    redis_client = redis.from_url(settings.redis_url, encoding="utf-8", decode_responses=True)
    async with postgres_pool() as pool:
        await ensure_database(pool)
        while True:
            timestamp = datetime.now(timezone.utc).isoformat()
            async with pool.acquire() as connection:
                await connection.execute("SELECT 1;")
            await redis_client.set(
                settings.heartbeat_key,
                timestamp,
                ex=settings.heartbeat_ttl_seconds,
            )
            logging.info("Heartbeat sent at %s", timestamp)
            await asyncio.sleep(settings.heartbeat_interval_seconds)


async def main() -> None:
    await heartbeat_task()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logging.info("Worker shutdown requested. Exiting gracefully.")

