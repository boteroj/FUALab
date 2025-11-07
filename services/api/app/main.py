from datetime import datetime
from functools import lru_cache

from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel, ConfigDict, Field
from pydantic_settings import BaseSettings
from sqlalchemy.orm import Session

from .database import Base, engine, get_db
from .models import Item


class Settings(BaseSettings):
    service_name: str = "FUALab API"
    database_url: str = "postgresql://postgres:postgres@db:5432/fualab"
    redis_url: str = "redis://redis:6379/0"

    class Config:
        env_prefix = "FUALAB_"
        env_file = ".env"


class ItemIn(BaseModel):
    name: str = Field(..., max_length=255)


class ItemOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    created_at: datetime


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
app = FastAPI(title=settings.service_name)


@app.on_event("startup")
def on_startup() -> None:
    # Keep metadata creation until Alembic migrations are fully adopted.
    Base.metadata.create_all(bind=engine)


@app.get("/health", tags=["Health"])
async def healthcheck() -> dict[str, str]:
    return {"status": "ok", "service": settings.service_name}


@app.get("/api/health", tags=["Health"])
async def api_healthcheck() -> dict[str, str]:
    return {"status": "ok", "service": settings.service_name}


@app.get("/api/items", response_model=list[ItemOut], tags=["Items"])
def list_items(db: Session = Depends(get_db)) -> list[Item]:
    return db.query(Item).order_by(Item.id).all()


@app.get("/api/items/{item_id}", response_model=ItemOut, tags=["Items"])
def get_item(item_id: int, db: Session = Depends(get_db)) -> Item:
    obj = db.get(Item, item_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Item not found")
    return obj


@app.post("/api/items", response_model=ItemOut, status_code=status.HTTP_201_CREATED, tags=["Items"])
def create_item(payload: ItemIn, db: Session = Depends(get_db)) -> Item:
    item = Item(name=payload.name)
    db.add(item)
    db.commit()
    db.refresh(item)
    return item
