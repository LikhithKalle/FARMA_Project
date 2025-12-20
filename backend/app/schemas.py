from typing import Optional, List
from enum import Enum
from sqlmodel import SQLModel, Field
from pydantic import BaseModel as PydanticBaseModel

class RiskLevel(str, Enum):
    Low = "Low"
    Medium = "Medium"
    High = "High"

# --- DB Models ---
class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    phone: str = Field(index=True, unique=True)
    full_name: Optional[str] = None
    language: str = "en"
    created_at: Optional[str] = None

# --- API Request/Response Schemas ---
class UserCreate(PydanticBaseModel):
    phone: str
    full_name: str
    language: str = "en"

class OTPRequest(PydanticBaseModel):
    phone: str

class OTPVerify(PydanticBaseModel):
    phone: str
    otp: str

class Token(PydanticBaseModel):
    access_token: str
    token_type: str
    user_id: int

class FarmerContext(PydanticBaseModel):
    district: Optional[str] = None
    state: Optional[str] = None
    soilType: Optional[str] = None
    season: Optional[str] = None
    landArea: Optional[float] = None
    hasIrrigation: Optional[bool] = None

class Recommendation(PydanticBaseModel):
    cropName: str
    suitabilityExplanation: str
    waterRequirement: str
    riskLevel: RiskLevel
    confidence: float
    imageUrl: Optional[str] = None
