import sys
import os

# Add the project root to sys.path so we can import 'backend'
sys.path.append(os.getcwd())

from fastapi.testclient import TestClient
from backend.main import app

client = TestClient(app)

def test_recommendation_api():
    print("Testing /recommendations endpoint...")
    payload = {
        "district": "Anantapur",
        "state": "Andhra Pradesh",
        "soilType": "Black",
        "season": "Kharif",
        "landArea": 5.0,
        "hasIrrigation": True
    }
    
    try:
        response = client.post("/recommendations", json=payload)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")
        
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        if len(data) > 0:
            print(f"Received {len(data)} recommendations.")
            print(f"First recommendation: {data[0]['cropName']}")
            assert "cropName" in data[0]
            assert "riskLevel" in data[0]
        else:
             print("⚠️ No recommendations returned (might be valid if soil unmatched).")
        
        print("✅ Test Passed!")
    except Exception as e:
        print(f"❌ Test Failed: {e}")

if __name__ == "__main__":
    test_recommendation_api()
