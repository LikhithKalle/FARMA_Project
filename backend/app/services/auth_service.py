import random
from datetime import datetime, timedelta
from jose import jwt
from passlib.context import CryptContext
from sqlmodel import Session, select
from app.database import engine
from app.schemas import User
from app.services.sms_service import send_otp

# Secret key for JWT (should be in .env, using hardcoded for hackathon speed)
SECRET_KEY = "hackathon_secret_key_change_me"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30 * 24 * 60 # 30 days

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Simple in-memory OTP storage: {phone: otp}
# In production, use Redis or a DB table with expiration
otp_storage = {}

def generate_otp() -> str:
    return str(random.randint(1000, 9999))

def register_user_step1(phone: str, full_name: str, language: str):
    """
    Initiates registration/login.
    1. Checks if user exists (optional, or just updates info).
    2. Generates OTP.
    3. Sends OTP.
    """
    # Generate OTP
    otp = generate_otp()
    
    # Store OTP
    otp_storage[phone] = otp
    
    # Send OTP
    send_otp(phone, otp)
    
    # In a real app, we might create the user here partially, but we can do it at verification too.
    # For now, we will store the temp user info in memory or just trust the phone number on verification.
    # Let's save the user info to DB now if new, or update text.
    with Session(engine) as session:
        statement = select(User).where(User.phone == phone)
        user = session.exec(statement).first()
        if not user:
            user = User(phone=phone, full_name=full_name, language=language)
            session.add(user)
            session.commit()
            session.refresh(user)
        else:
            # Update info if provided
            user.full_name = full_name
            user.language = language
            session.add(user)
            session.commit()
            
    return {"message": "OTP sent successfully"}

def verify_otp_step2(phone: str, otp: str):
    """
    Verifies OTP and returns access token.
    """
    stored_otp = otp_storage.get(phone)
    
    # Backdoor for testing if SMS fails or testing quickly: '0000'
    if otp == "0000": 
        pass 
    elif stored_otp != otp:
        return None
    
    # Clear OTP
    if phone in otp_storage:
        del otp_storage[phone]
        
    # Get user from DB
    with Session(engine) as session:
        statement = select(User).where(User.phone == phone)
        user = session.exec(statement).first()
        if not user:
            # Should not happen if step1 was called, but handle it
            return None
            
        # Create Access Token
        access_token = create_access_token(data={"sub": user.phone, "user_id": user.id})
        return {"access_token": access_token, "token_type": "bearer", "user_id": user.id}

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt
