from fastapi import APIRouter, HTTPException, Body
from pydantic import BaseModel
from typing import Optional, List, Dict
from app.services.chat_service import chat_service
from app.schemas import Recommendation

router = APIRouter(
    prefix="/chat",
    tags=["chat"],
    responses={404: {"description": "Not found"}},
)

class ChatRequest(BaseModel):
    message: str
    session_id: Optional[str] = None
    language: Optional[str] = "en" # 'en', 'hi', 'te'

class ChatResponse(BaseModel):
    session_id: str
    response: str
    state: str
    options: Optional[List[str]] = None
    input_type: Optional[str] = "text" # text, options, location, manual_entry
    recommendations: Optional[List[Recommendation]] = None

@router.post("/", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    Process a chat message and return the bot's response and current state.
    """
    try:
        result = chat_service.process_message(request.session_id, request.message, request.language)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
