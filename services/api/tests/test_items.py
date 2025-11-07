import os
from collections.abc import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.database import Base, get_db
from app.main import app


TEST_DATABASE_URL = os.getenv("FUALAB_DATABASE_URL", "sqlite:///./tests_api.db")


engine = create_engine(TEST_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False, future=True)


def override_get_db() -> Generator[Session, None, None]:
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()


@pytest.fixture(scope="session", autouse=True)
def setup_database() -> Generator[None, None, None]:
    Base.metadata.create_all(bind=engine)
    app.dependency_overrides[get_db] = override_get_db
    yield
    app.dependency_overrides.pop(get_db, None)
    Base.metadata.drop_all(bind=engine)


@pytest.fixture()
def client() -> Generator[TestClient, None, None]:
    with TestClient(app) as test_client:
        yield test_client


def test_health_endpoint(client: TestClient) -> None:
    response = client.get("/api/health")
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert "service" in body


def test_items_flow(client: TestClient) -> None:
    create_response = client.post("/api/items", json={"name": "Sample"})
    assert create_response.status_code == 201
    created = create_response.json()
    assert created["name"] == "Sample"
    assert "id" in created
    assert "created_at" in created

    list_response = client.get("/api/items")
    assert list_response.status_code == 200
    items = list_response.json()
    assert any(item["id"] == created["id"] for item in items)

    detail_response = client.get(f"/api/items/{created['id']}")
    assert detail_response.status_code == 200

    missing_response = client.get("/api/items/999999")
    assert missing_response.status_code == 404

