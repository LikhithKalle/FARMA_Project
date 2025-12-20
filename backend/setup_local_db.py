from sqlmodel import SQLModel, create_engine
from app.database import engine
from app.schemas import User  # Ensure models are imported to register with SQLModel
# Add other models here if needed

print("Initializing Local SQLite Database...")
print("Database URL:", engine.url)

def init_db():
    try:
        print("⚠ Resetting Database... Dropping all tables.")
        SQLModel.metadata.drop_all(engine)
        print("Creating new empty tables...")
        SQLModel.metadata.create_all(engine)
        print("✅ Database reset and initialized successfully in farma.db")
    except Exception as e:
        print(f"❌ Error creating database: {e}")

if __name__ == "__main__":
    init_db()
