from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.database import create_db_and_tables
from app.routers import auth
from app.routers import recommendations 
from app.routers import chat

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Create DB tables
    create_db_and_tables()
    yield

app = FastAPI(title="FARMA Backend", version="1.0.0", lifespan=lifespan)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(auth.router)
app.include_router(recommendations.router)
app.include_router(chat.router)

@app.get("/")
def read_root():
    return {"message": "Farm Advisory Backend is Running"}
