import joblib
import pickle
import os
import pandas as pd
import numpy as np
from ..schemas import FarmerContext, Recommendation, RiskLevel

# Model Paths
MODEL_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "models")
MODEL_PATH = os.path.join(MODEL_DIR, "crop_recommendation_model.pkl")
SOIL_ENCODER_PATH = os.path.join(MODEL_DIR, "soil_encoder.pkl")
CROP_ENCODER_PATH = os.path.join(MODEL_DIR, "crop_encoder.pkl")

# Static Metadata (since model doesn't provide this)
# Static Metadata (since model doesn't provide this)
CROP_METADATA = {
    "rice": {"water": "High", "risk": RiskLevel.Low, "reason": "Suitable for clayey/loamy soil with high water.", "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=200"},
    "paddy": {"water": "High", "risk": RiskLevel.Low, "reason": "Requires standing water and clayey soil.", "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=200"},
    "maize": {"water": "Medium", "risk": RiskLevel.Low, "reason": "Hardy crop, suitable for well-drained loamy soil.", "image": "https://images.unsplash.com/photo-1551754655-cd27e38d2076?q=80&w=200"},
    "cotton": {"water": "Medium", "risk": RiskLevel.Medium, "reason": "Good for black soil, but watch for pests.", "image": "https://images.unsplash.com/photo-1593444053930-b49d569d6600?q=80&w=200"},
    "coffee": {"water": "Medium", "risk": RiskLevel.Medium, "reason": "Needs specific altitude and shade.", "image": "https://images.unsplash.com/photo-1552345375-f703271ae96d?q=80&w=200"},
    "jute": {"water": "High", "risk": RiskLevel.Medium, "reason": "Requires alluvial soil and high humidity.", "image": "https://plus.unsplash.com/premium_photo-1661907727181-432d603a1d94?q=80&w=200"},
    "sugarcane": {"water": "High", "risk": RiskLevel.Low, "reason": "Long duration crop, loves deep loamy soil.", "image": "https://images.unsplash.com/photo-1605284429718-4e11d0413008?q=80&w=200"},
    "wheat": {"water": "Medium", "risk": RiskLevel.Low, "reason": "Cool season crop, loam/clay-loam is best.", "image": "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=200"},
    "millets": {"water": "Low", "risk": RiskLevel.Low, "reason": "Drought resistant, good for poor soils.", "image": "https://images.unsplash.com/photo-1662541810453-277180155b9a?q=80&w=200"},
    "tobacco": {"water": "Medium", "risk": RiskLevel.High, "reason": "Sensitive to waterlogging, needs specific processing.", "image": "https://images.unsplash.com/photo-1534078652233-030616b24d26?q=80&w=200"},
    "barley": {"water": "Low", "risk": RiskLevel.Low, "reason": "Can tolerate saline soil better than wheat.", "image": "https://images.unsplash.com/photo-1522003882101-7cb242407b9e?q=80&w=200"},
    "oil seeds": {"water": "Low", "risk": RiskLevel.Medium, "reason": "Diverse group, generally needs well-drained soil.", "image": "https://images.unsplash.com/photo-1457530378979-3ec709df73c4?q=80&w=200"},
    "ground nuts": {"water": "Medium", "risk": RiskLevel.Medium, "reason": "Prefers sandy loam, sensitive to aflatoxin.", "image": "https://images.unsplash.com/photo-1622549221808-410a0827293a?q=80&w=200"},
    "pulses": {"water": "Low", "risk": RiskLevel.Low, "reason": "Nitrogen fixing, good for soil health.", "image": "https://images.unsplash.com/photo-1515543904379-3d757afe9c6c?q=80&w=200"},
}

class RecommendationEngine:
    def __init__(self):
        self.model = None
        self.soil_encoder = None
        self.crop_encoder = None
        self.load_models()

    def load_models(self):
        try:
            # Try loading with pickle first, fallback to joblib (based on inspection)
            try:
                with open(MODEL_PATH, 'rb') as f: self.model = pickle.load(f)
            except:
                self.model = joblib.load(MODEL_PATH)

            try:
                with open(SOIL_ENCODER_PATH, 'rb') as f: self.soil_encoder = pickle.load(f)
            except:
                self.soil_encoder = joblib.load(SOIL_ENCODER_PATH)
                
            try:
                with open(CROP_ENCODER_PATH, 'rb') as f: self.crop_encoder = pickle.load(f)
            except:
                self.crop_encoder = joblib.load(CROP_ENCODER_PATH)
                
            print("Models loaded successfully.")
        except Exception as e:
            print(f"Error loading models: {e}")
            self.model = None

    def get_recommendations(self, context: FarmerContext) -> list[Recommendation]:
        if not self.model or not context.soilType:
            return []

        try:
            # 1. Preprocess Input (Only Soil Type is used by this specific model)
            soil_lower = context.soilType.lower()
            
            # 1. Encode Soil Type
            try:
                # Check if soilType is in encoder classes
                # Note: Scikit-learn LabelEncoder might raise ValueError if label is unseen
                # Standard encoders are strict.
                encoded_soil = self.soil_encoder.transform([soil_lower])[0]
            except (ValueError, AttributeError, Exception):
                # Fallback for "Other" or unknown strings
                # Ideally we might map "Red Soil" -> "Red" etc.
                # For now, return empty or default? 
                # Let's map "Other" to a generic one or just fail gracefully.
                print(f"Unknown soil type: {context.soilType}")
                return [] # No specific ML recommendation possible without valid soil
            
            # 2. Predict (Get probabilities to suggest top crops)
            # Note: Model expects a DataFrame or 2D array. Inspection showed feature name 'soil_enc'.
            input_data = pd.DataFrame({'soil_enc': [encoded_soil]}) 
            
            probs = self.model.predict_proba(input_data)[0]
            
            # Get indices of top 5 probabilities (fetching more to filter)
            top_indices = probs.argsort()[-5:][::-1]
            
            recommendations = []
            for idx in top_indices:
                if probs[idx] > 0.05: # Threshold to ignore very unlikely crops
                    crop_label = self.crop_encoder.inverse_transform([idx])[0]
                    crop_key = crop_label.lower()
                    meta = CROP_METADATA.get(crop_key, {
                        "water": "Medium", "risk": RiskLevel.Medium, "reason": f"suitable for {context.soilType} soil."
                    })

                    # --- Hybrid Rule-Based Filtering ---
                    score_modifier = 0
                    rejection_reason = None

                    # 1. Season Filter (Basic Logic)
                    if context.season:
                        season_lower = context.season.lower()
                        # Example Rules (Expand based on agricultural knowledge)
                        if season_lower == "kharif":
                            if crop_key in ["wheat", "barley", "gram"]: rejection_reason = "Not suitable for Kharif season"
                        elif season_lower == "rabi":
                            if crop_key in ["rice", "cotton", "jute"]: rejection_reason = "Requires high water/warmth (Kharif mainly)"
                        elif season_lower == "zaid":
                            if crop_key not in ["watermelon", "muskmelon", "cucumber", "maize", "fodder"]: 
                                score_modifier -= 0.5 # Discourage non-Zaid crops

                    # 2. Irrigation Check
                    if context.hasIrrigation is False:
                        if meta["water"] == "High":
                            rejection_reason = "Requires high water, but irrigation is unavailable."

                    # 3. Land Area Check (Minimum viability, purely illustrative)
                    if context.landArea and context.landArea < 1.0:
                         if crop_key in ["sugarcane", "cotton"]: 
                             score_modifier -= 0.2 # Cash crops might need more scale

                    # Decision
                    if rejection_reason:
                        print(f"Skipping {crop_label}: {rejection_reason}")
                        continue
                    
                    # Generate Recommendation
                    rec = Recommendation(
                        cropName=crop_label.capitalize(),
                        suitabilityExplanation=f"{meta['reason']} (Match: {int(probs[idx]*100)}%)",
                        waterRequirement=meta["water"],
                        riskLevel=meta["risk"],
                        confidence=float(probs[idx]),
                        imageUrl=meta.get("image")
                    )
                    recommendations.append(rec)
                    
                    if len(recommendations) >= 1:
                        break
            
            return recommendations

        except Exception as e:
            print(f"Prediction error: {e}")
            return []

engine = RecommendationEngine()
