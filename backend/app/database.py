from sqlmodel import SQLModel, create_engine, Session
import os

# Get DB URL from env or use SQLite fallback
DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///./farma.db")

# Railway/Heroku sometimes provide "postgres://", which SQLAlchemy doesn't like. Needs "postgresql://"
if DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

# Create engine (check_same_thread is for SQLite only)
connect_args = {"check_same_thread": False} if "sqlite" in DATABASE_URL else {}
engine = create_engine(DATABASE_URL, echo=True, connect_args=connect_args)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
