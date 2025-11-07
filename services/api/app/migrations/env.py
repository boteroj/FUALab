import os
import sys
from alembic import context
from sqlalchemy import engine_from_config, pool
from pathlib import Path

# We are at /app/app/migrations/env.py
# We need /app in sys.path so that "import app.*" works.
PROJECT_ROOT = Path(__file__).resolve().parents[2]  # -> /app
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

# Now these imports work
from app.database import Base  # noqa: E402
from app import models         # noqa: F401,E402  (ensure models are registered)

config = context.config

def get_url() -> str:
    return os.getenv("FUALAB_DATABASE_URL", "postgresql://postgres:postgres@db:5432/fualab")

target_metadata = Base.metadata

def run_migrations_offline():
    url = get_url()
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        compare_type=True,
        compare_server_default=True,
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online():
    cfg_section = config.get_section(config.config_ini_section) or {}
    cfg_section["sqlalchemy.url"] = get_url()

    connectable = engine_from_config(
        cfg_section,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
        future=True,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
        )
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
