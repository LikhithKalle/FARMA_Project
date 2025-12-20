from sqlmodel import SQLModel, create_engine, Session
import os

# SQLite Database URL (Local file, no setup required)
DATABASE_URL = "sqlite:///./farma.db"

# Create engine for SQLite
# check_same_thread=False is needed for SQLite with FastAPI
engine = create_engine(DATABASE_URL, echo=True, connect_args={"check_same_thread": False})

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
