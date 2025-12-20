import uuid
from typing import Dict, Optional, List
from app.schemas import FarmerContext, Recommendation
from app.services.recommendation_engine import engine
from app.services.map_service import map_service
import re

# Multi-language Dictionary corresponding to state machine messages
TRANSLATIONS = {
    'en': {
        'intro': "Hello! I am your farming assistant. Let's find the best crops for you. First, where is your farm located?",
        'found_loc': "I've detected your location as {address}. Is this correct?",
        'loc_fail': "Could not detect location details. Please type your location manually.",
        'loc_error': "Error processing location. Please type manually.",
        'manual_loc_prompt': "Please allow location access on your device or type manually.",
        'manual_verify': "Found {place}. Is this correct?",
        'manual_fail': "I couldn't verify '{input}' on the map, but I'll note it down. Now, what type of soil do you have?",
        'ask_soil': "Great. Now, what type of soil do you have?",
        'ask_manual_dist': "Please type your district/city name manually.",
        'ask_soil_manual': "Please type your soil type.",
        'ask_season': "Which farming season is this for?",
        'ask_area': "What is the total land area (in acres)?",
        'area_error': "Land area must be greater than 0. Please enter a valid positive number (e.g. 5).",
        'area_invalid': "I couldn't understand that number. Please enter a value like '5' or '2.5'.",
        'ask_irrigation': "Is irrigation available?",
        'analyzing': "Analyzing your farm profile...",
        'found_crops': "Found {count} suitable crops.",
        'no_crops': "No specific crops found for these exact conditions.",
        'error_recs': "Error generating recommendations.",
        'reset_prompt': "Type 'reset' to start over.",
        'options': {
            'Use Current Location': 'Use Current Location',
            'Type Manually': 'Type Manually',
            'Yes': 'Yes', 
            'No': 'No',
            'No, Type Manually': 'No, Type Manually',
            'Red': 'Red', 'Black': 'Black', 'Sandy': 'Sandy', 'Loam': 'Loam', 'Clay': 'Clay', 'Other': 'Other',
            'Kharif': 'Kharif', 'Rabi': 'Rabi', 'Zaid': 'Zaid'
        }
    },
    'hi': {
        'intro': "नमस्ते! मैं आपका कृषि सहायक हूँ। आइए आपके लिए सर्वोत्तम फसलें खोजें। सबसे पहले, आपका खेत कहाँ स्थित है?",
        'found_loc': "मैंने आपके स्थान का पता {address} लगाया है। क्या यह सही है?",
        'loc_fail': "स्थान का विवरण नहीं मिल सका। कृपया अपना स्थान मैन्युअल रूप से लिखें।",
        'loc_error': "स्थान संसाधित करने में त्रुटि। कृपया मैन्युअल रूप से लिखें।",
        'manual_loc_prompt': "कृपया अपने डिवाइस पर स्थान एक्सेस की अनुमति दें या मैन्युअल रूप से लिखें।",
        'manual_verify': "{place} मिला। क्या यह सही है?",
        'manual_fail': "मैं मानचित्र पर '{input}' को सत्यापित नहीं कर सका, लेकिन मैंने इसे नोट कर लिया है। अब, आपके पास किस प्रकार की मिट्टी है?",
        'ask_soil': "बहुत बढ़िया। अब, आपके पास किस प्रकार की मिट्टी है?",
        'ask_manual_dist': "कृपया अपना जिला/शहर का नाम मैन्युअल रूप से लिखें।",
        'ask_soil_manual': "कृपया अपनी मिट्टी के प्रकार लिखें।",
        'ask_season': "यह किस खेती के मौसम के लिए है?",
        'ask_area': "कुल भूमि क्षेत्र (एकड़ में) कितना है?",
        'area_error': "भूमि का क्षेत्रफल 0 से अधिक होना चाहिए। कृपया एक मान्य सकारात्मक संख्या दर्ज करें (जैसे 5)।",
        'area_invalid': "मैं उस संख्या को समझ नहीं सका। कृपया '5' या '2.5' जैसा मान दर्ज करें।",
        'ask_irrigation': "क्या सिंचाई उपलब्ध है?",
        'analyzing': "आपके कृषि प्रोफ़ाइल का विश्लेषण कर रहा हूँ...",
        'found_crops': "{count} उपयुक्त फसलें मिलीं।",
        'no_crops': "इन सटीक स्थितियों के लिए कोई विशेष फसल नहीं मिली।",
        'error_recs': "अनुशंसाएँ उत्पन्न करने में त्रुटि।",
        'reset_prompt': "पुनः आरंभ करने के लिए 'reset' टाइप करें।",
        'options': {
            'Use Current Location': 'वर्तमान स्थान का उपयोग करें',
            'Type Manually': 'मैन्युअल रूप से लिखें',
            'Yes': 'हाँ', 
            'No': 'नहीं',
            'No, Type Manually': 'नहीं, मैन्युअल रूप से लिखें',
            'Red': 'लाल', 'Black': 'काली', 'Sandy': 'रेतीली', 'Loam': 'दोमट', 'Clay': 'चिकनी', 'Other': 'अन्य',
            'Kharif': 'खरीफ', 'Rabi': 'रबी', 'Zaid': 'जायद'
        }
    },
    'te': {
        'intro': "నమస్కారం! నేను మీ వ్యవసాయ సహాయకుడిని. మీ కోసం ఉత్తమ పంటలను కనుగొందాం. ముందుగా, మీ పొలం ఎక్కడ ఉంది?",
        'found_loc': "నేను మీ స్థానాన్ని {address} గా గుర్తించాను. ఇది సరైనదేనా?",
        'loc_fail': "స్థాన వివరాలను గుర్తించలేకపోయాను. దయచేసి మీ స్థానాన్ని మాన్యువల్‌గా టైప్ చేయండి.",
        'loc_error': "స్థానాన్ని ప్రాసెస్ చేయడంలో లోపం. దయచేసి మాన్యువల్‌గా టైప్ చేయండి.",
        'manual_loc_prompt': "దయచేసి మీ పరికరంలో స్థాన ప్రాప్యతను అనుమతించండి లేదా మాన్యువల్‌గా టైప్ చేయండి.",
        'manual_verify': "{place} కనుగొనబడింది. ఇది సరైనదేనా?",
        'manual_fail': "నేను మ్యాప్‌లో '{input}' ని ధృవీకరించలేకపోయాను, కానీ నేను గమనించాను. ఇప్పుడు, మీ నేల రకం ఏమిటి?",
        'ask_soil': "బాగుంది. ఇప్పుడు, మీ నేల రకం ఏమిటి?",
        'ask_manual_dist': "దయచేసి మీ జిల్లా/నగరం పేరును మాన్యువల్‌గా టైప్ చేయండి.",
        'ask_soil_manual': "దయచేసి మీ నేల రకాన్ని టైప్ చేయండి.",
        'ask_season': "ఇది ఏ వ్యవసాయ సీజన్ కోసం?",
        'ask_area': "మొత్తం భూమి విస్తీర్ణం (ఎకరాల్లో) ఎంత?",
        'area_error': "భూమి విస్తీర్ణం 0 కంటే ఎక్కువగా ఉండాలి. దయచేసి సరైన సంఖ్యను నమోదు చేయండి (ఉదా. 5).",
        'area_invalid': "ఆ సంఖ్య నాకు అర్థం కాలేదు. దయచేసి '5' లేదా '2.5' వంటి విలువను నమోదు చేయండి.",
        'ask_irrigation': "నీటిపారుదల సౌకర్యం ఉందా?",
        'analyzing': "మీ వ్యవసాయ ప్రొఫైల్‌ను విశ్లేషిస్తున్నాను...",
        'found_crops': "{count} అనుకూలమైన పంటలు కనుగొనబడ్డాయి.",
        'no_crops': "ఈ పరిస్థితులకు తగిన పంటలు కనుగొనబడలేదు.",
        'error_recs': "సిఫార్సులను రూపొందించడంలో లోపం.",
        'reset_prompt': "మళ్లీ ప్రారంభించడానికి 'reset' అని టైప్ చేయండి.",
        'options': {
            'Use Current Location': 'ప్రస్తుత స్థానాన్ని ఉపయోగించండి',
            'Type Manually': 'మాన్యువల్‌గా టైప్ చేయండి',
            'Yes': 'అవును', 
            'No': 'కాదు',
            'No, Type Manually': 'కాదు, మాన్యువల్‌గా టైప్ చేయండి',
            'Red': 'ఎరుపు', 'Black': 'నల్ల', 'Sandy': 'ఇసుక', 'Loam': 'లోమ్', 'Clay': 'బంకమట్టి', 'Other': 'ఇతర',
            'Kharif': 'ఖరీఫ్', 'Rabi': 'రబీ', 'Zaid': 'జైద్'
        }
    }
}

# Reverse mapping for inputs: Translated text -> English Key
INPUT_MAPPING = {}
for lang in ['hi', 'te']:
    for en_key, trans_val in TRANSLATIONS[lang]['options'].items():
        INPUT_MAPPING[trans_val.lower()] = en_key

class ChatSession:
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.context = FarmerContext()
        self.state = "START" 
        self.history = []

class ChatService:
    def __init__(self):
        self.sessions: Dict[str, ChatSession] = {}

    def get_or_create_session(self, session_id: Optional[str] = None) -> ChatSession:
        if session_id and session_id in self.sessions:
            return self.sessions[session_id]
        
        new_id = str(uuid.uuid4())
        session = ChatSession(new_id)
        self.sessions[new_id] = session
        return session
    
    def _tr(self, key: str, lang: str, **kwargs) -> str:
        """Translate helper"""
        lang_dict = TRANSLATIONS.get(lang, TRANSLATIONS['en'])
        text = lang_dict.get(key, TRANSLATIONS['en'].get(key, key))
        # Simple format replacement if needed
        try:
            return text.format(**kwargs)
        except:
            return text

    def _tr_opts(self, opts: List[str], lang: str) -> List[str]:
        """Translate list of options"""
        if lang == 'en': return opts
        lang_opts = TRANSLATIONS.get(lang, TRANSLATIONS['en']).get('options', {})
        return [lang_opts.get(opt, opt) for opt in opts]

    def process_message(self, session_id: Optional[str], message: str, language: str = "en") -> dict:
        session = self.get_or_create_session(session_id)
        raw_msg = message.strip()
        user_msg = raw_msg # Default to raw
        
        # Normalize input: Check if msg is a translated option, map back to English
        if raw_msg.lower() in INPUT_MAPPING:
            user_msg = INPUT_MAPPING[raw_msg.lower()]
        
        # Fallback: if user typed "అవును" manually and it wasn't caught (e.g. case diff), handle common words
        # (Already handled by strict mapping above if mostly button clicks)
        
        response_text = ""
        options = []
        input_type = "text"
        recommendations = None

        # --- KEYWORD RESET ---
        if user_msg.lower() in ["reset", "start over", "restart", "hi", "hello"]:
            session.state = "START"
            session.context = FarmerContext()

        # --- STATE MACHINE ---
        
        if session.state == "START":
            session.state = "ASK_LOCATION"
            response_text = self._tr('intro', language)
            options = ["Use Current Location", "Type Manually"]
            input_type = "location"

        elif session.state == "ASK_LOCATION":
            if user_msg.startswith("LOC:"):
                # Geolocation used
                try:
                    coords = user_msg.replace("LOC:", "").split(",")
                    lat = float(coords[0])
                    lon = float(coords[1])
                    location_data = map_service.reverse_geocode(lat, lon)
                    
                    if location_data:
                        session.context.district = location_data.get('district', 'Unknown')
                        session.context.state = location_data.get('state', 'Unknown')
                        address = location_data.get('raw', f"{session.context.district}, {session.context.state}")
                        
                        response_text = self._tr('found_loc', language, address=address)
                        options = ["Yes", "No, Type Manually"]
                        input_type = "options"
                        session.state = "CONFIRM_LOCATION"
                    else:
                         response_text = self._tr('loc_fail', language)
                         input_type = "text"
                         session.state = "ASK_LOCATION"
                except Exception:
                     response_text = self._tr('loc_error', language)
                     input_type = "text"
                     session.state = "ASK_LOCATION"

            elif user_msg == "Use Current Location":
                response_text = self._tr('manual_loc_prompt', language)
                options = ["Use Current Location", "Type Manually"]
                input_type = "location"
                session.state = "ASK_LOCATION"

            else:
                # Manual Input Validation
                place = map_service.search_place(user_msg)
                if place:
                     session.context.district = place['name']
                     session.context.state = "Unknown"
                     response_text = self._tr('manual_verify', language, place=place['name'])
                     options = ["Yes", "No"]
                     input_type = "options"
                     session.state = "CONFIRM_LOCATION"
                else:
                    session.context.district = user_msg
                    session.context.state = "Unknown" 
                    response_text = self._tr('manual_fail', language, input=user_msg)
                    options = ["Red", "Black", "Sandy", "Loam", "Clay", "Other"]
                    input_type = "options"
                    session.state = "ASK_SOIL"

        elif session.state == "CONFIRM_LOCATION":
             if user_msg.lower() == "yes" or user_msg == "Yes":
                 response_text = self._tr('ask_soil', language)
                 options = ["Red", "Black", "Sandy", "Loam", "Clay", "Other"]
                 input_type = "options"
                 session.state = "ASK_SOIL"
             else:
                 response_text = self._tr('ask_manual_dist', language)
                 input_type = "text"
                 session.state = "ASK_LOCATION"

        elif session.state == "ASK_SOIL":
            if user_msg == "Other":
                response_text = self._tr('ask_soil_manual', language)
                input_type = "text"
                session.state = "ASK_SOIL_MANUAL"
            else:
                session.context.soilType = user_msg
                response_text = self._tr('ask_season', language)
                options = ["Kharif", "Rabi", "Zaid"]
                input_type = "options"
                session.state = "ASK_SEASON"

        elif session.state == "ASK_SOIL_MANUAL":
            session.context.soilType = raw_msg # Use raw input for manual soil
            response_text = self._tr('ask_season', language)
            options = ["Kharif", "Rabi", "Zaid"]
            input_type = "options"
            session.state = "ASK_SEASON"

        elif session.state == "ASK_SEASON":
            session.context.season = user_msg
            response_text = self._tr('ask_area', language)
            input_type = "text"
            session.state = "ASK_AREA"

        elif session.state == "ASK_AREA":
            numbers = re.findall(r"[-+]?\d*\.?\d+", raw_msg) # Use raw_msg for safety
            
            if numbers:
                try:
                    area = float(numbers[0])
                    if area <= 0:
                        response_text = self._tr('area_error', language)
                        input_type = "text"
                    else:
                        session.context.landArea = area
                        response_text = self._tr('ask_irrigation', language)
                        options = ["Yes", "No"]
                        input_type = "options"
                        session.state = "ASK_IRRIGATION"
                except ValueError:
                    response_text = self._tr('area_invalid', language)
                    input_type = "text"
            else:
                response_text = self._tr('area_error', language)
                input_type = "text"

        elif session.state == "ASK_IRRIGATION":
             session.context.hasIrrigation = (user_msg == "Yes")
             
             response_text = self._tr('analyzing', language)
             input_type = "none"
             session.state = "COMPLETE"
             
             try:
                recs = engine.get_recommendations(session.context)
                recommendations = recs
                if recs:
                    response_text = self._tr('found_crops', language, count=len(recs))
                else:
                    response_text = self._tr('no_crops', language)
             except Exception as e:
                print(f"Error: {e}")
                response_text = self._tr('error_recs', language)

        elif session.state == "COMPLETE":
             response_text = self._tr('reset_prompt', language)
             input_type = "text"

        return {
            "session_id": session.session_id,
            "response": response_text,
            "state": session.state,
            "options": self._tr_opts(options, language), # Translate options before sending
            "input_type": input_type,
            "recommendations": recommendations # Recommendations content is still raw English usually, but that's later
        }

chat_service = ChatService()
