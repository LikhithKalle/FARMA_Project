from fastapi import APIRouter, HTTPException, Body
from typing import List
from ..schemas import FarmerContext, Recommendation
from ..services.recommendation_engine import engine

router = APIRouter()

@router.post("/recommendations", response_model=List[Recommendation])
async def get_recommendations(context: FarmerContext = Body(...)):
    """
    Get crop recommendations based on the farmer's context.
    Currently primarily uses Soil Type for prediction.
    """
    if not context.soilType:
        raise HTTPException(status_code=400, detail="Soil Type is required for recommendations.")
    
    recommendations = engine.get_recommendations(context)
    
    if not recommendations:
        # Fallback or empty if no soil type matches known types
        raise HTTPException(status_code=404, detail="No suitable crops found for the given soil type.")
        
    return recommendations
