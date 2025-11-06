from sqlalchemy import Column, DateTime, Integer, String, text

from .database import Base


class Item(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=text("CURRENT_TIMESTAMP"), nullable=False)

