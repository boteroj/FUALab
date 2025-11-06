import os
from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, declarative_base, sessionmaker

DEFAULT_DATABASE_URL = "postgresql://postgres:postgres@db:5432/fualab"

DATABASE_URL = os.getenv("FUALAB_DATABASE_URL", DEFAULT_DATABASE_URL)

engine = create_engine(DATABASE_URL, future=True)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False, future=True)
Base = declarative_base()


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

