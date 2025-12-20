import requests

MAPTILER_KEY = "YImAWWEWi6rTSIyvNnMW"

class MapService:
    def reverse_geocode(self, lat: float, lon: float) -> dict:
        """
        Returns {'district': str, 'state': str} or None
        """
        url = f"https://api.maptiler.com/geocoding/{lon},{lat}.json?key={MAPTILER_KEY}"
        try:
            response = requests.get(url)
            if response.status_code == 200:
                data = response.json()
                features = data.get("features", [])
                if features:
                    # Look for relevant context in the first feature
                    # MapTiler returns Place, Region, Country etc usually in context or place_type
                    
                    # Heuristic: Try to find 'state' (region) and 'district' (county/unknown)
                    district = "Unknown District"
                    state_name = "Unknown State"
                    
                    # Often the most specific feature is at index 0
                    place_name = features[0].get("place_name", "")
                    
                    # Let's try to parse from context if available
                    # Example context: [{'id': 'region.123', 'text': 'Andhra Pradesh'}, ...]
                    
                    # Simplification: specific logic depends on MapTiler payload structure for India
                    # Usually "place_name" is like "Anantapur, Andhra Pradesh, India"
                    parts = place_name.split(",")
                    if len(parts) >= 2:
                        district = parts[0].strip()
                        state_name = parts[1].strip()
                    elif len(parts) == 1:
                         district = parts[0].strip()
                         
                    return {"district": district, "state": state_name, "raw": place_name}
            return None
        except Exception as e:
            print(f"MapTiler Error: {e}")
            return None

    def search_place(self, query: str) -> dict:
        """
        Validates if a place exists. Returns {'name': str, 'lat': float, 'lon': float}
        """
        url = f"https://api.maptiler.com/geocoding/{query}.json?key={MAPTILER_KEY}"
        try:
            response = requests.get(url)
            if response.status_code == 200:
                data = response.json()
                features = data.get("features", [])
                if features:
                    best = features[0]
                    return {
                        "name": best.get("place_name", query),
                        "center": best.get("center", [0, 0]) # [lon, lat]
                    }
            return None
        except Exception as e:
            print(f"MapTiler Search Error: {e}")
            return None

map_service = MapService()
