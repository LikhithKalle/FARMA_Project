import random
import os
import bcrypt
from datetime import datetime, timedelta
from jose import jwt
from sqlmodel import Session, select
from app.database import engine
from app.schemas import User
from app.services.sms_service import send_otp

# Monkey patch removed - using bcrypt directly
# from passlib.context import CryptContext

# Secret key to sign JWTs
SECRET_KEY = os.getenv("SECRET_KEY", "supersecretkey") # Change this in production!
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30 * 24 * 60 # 30 days

# pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Simple in-memory storage for pending registrations
# {phone: {"otp": "1234", "full_name": "...", "language": "en", "password": "..."}}
pending_registrations = {}

def generate_otp() -> str:
    return str(random.randint(1000, 9999))

def hash_password(password: str) -> str:
    """Hash a password for storing (using pure bcrypt)."""
    if password is None: return None
    
    # bcrypt requires bytes
    password_bytes = password.encode('utf-8')
    
    # Generate salt and hash
    hashed = bcrypt.hashpw(password_bytes, bcrypt.gensalt())
    
    # Return as string for storage
    return hashed.decode('utf-8')

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a stored password against provided password."""
    if not hashed_password: return False
    
    # Convert both to bytes
    password_bytes = plain_password.encode('utf-8')
    hashed_bytes = hashed_password.encode('utf-8')
    
    return bcrypt.checkpw(password_bytes, hashed_bytes)

def register_user_step1(phone: str, full_name: str, language: str, password: str = None):
    """
    Initiates registration.
    1. Generates OTP.
    2. Stores temp registration data (NOT in DB yet).
    3. Sends OTP.
    """
    # Check if user already exists in DB
    with Session(engine) as session:
        statement = select(User).where(User.phone == phone)
        existing_user = session.exec(statement).first()
        if existing_user:
            # User already exists - can't register again
            return {"message": "User already registered. Please login.", "is_existing_user": True, "error": True}
    
    # New user - store temp data including password, don't create in DB yet
    otp = generate_otp()
    pending_registrations[phone] = {
        "otp": otp,
        "full_name": full_name,
        "language": language,
        "password": password,
        "is_existing": False
    }
    
    # Send OTP
    send_otp(phone, otp)
            
    return {"message": "OTP sent successfully", "is_existing_user": False}

def verify_otp_step2(phone: str, otp: str):
    """
    Verifies OTP and returns access token.
    Only creates user in DB after successful OTP verification.
    """
    # Normalize inputs
    phone = phone.strip()
    otp = otp.strip()
    
    print(f"DEBUG: Verifying OTP for {phone}. Input OTP: '{otp}'")
    print(f"DEBUG: Current pending registrations: {list(pending_registrations.keys())}")
    
    pending = pending_registrations.get(phone)
    
    if not pending:
        # No pending registration for this phone
        print(f"DEBUG: No pending registration found for {phone}")
        return None
    
    stored_otp = pending.get("otp")
    print(f"DEBUG: Stored OTP for {phone}: '{stored_otp}'")
    
    # Verify OTP - NO backdoor, must match exactly
    if stored_otp != otp:
        print(f"DEBUG: OTP Mismatch! stored='{stored_otp}' vs input='{otp}'")
        return None  # Return None means "Invalid credentials" (401)
    
    # OTP verified! Now create user with hashed password
    try:
        with Session(engine) as session:
            statement = select(User).where(User.phone == phone)
            user = session.exec(statement).first()
            
            if not user:
                # Create new user now that OTP is verified
                password = pending.get("password")
                print(f"DEBUG: Creating new user {phone}.")
                password_hash = hash_password(password) if password else None
                
                user = User(
                    phone=phone, 
                    full_name=pending.get("full_name", "User"),
                    password_hash=password_hash,
                    language=pending.get("language", "en")
                )
                session.add(user)
                session.commit()
                session.refresh(user)
                print(f"DEBUG: User created successfully with ID: {user.id}")
            
            # Clear pending registration
            if phone in pending_registrations:
                del pending_registrations[phone]
                
            # Create Access Token
            access_token = create_access_token(data={"sub": user.phone, "user_id": user.id})
            return {
                "access_token": access_token, 
                "token_type": "bearer", 
                "user_id": user.id,
                "full_name": user.full_name,
                "phone": user.phone,
                "language": user.language
            }
    except Exception as e:
        print(f"DEBUG: Error during user creation: {e}")
        # Raise exception to be caught by router
        raise Exception(f"Database Error: {str(e)}")

def login_user(phone: str, password: str):
    """
    Login with phone and password.
    Returns access token if credentials are valid, None otherwise.
    """
    with Session(engine) as session:
        statement = select(User).where(User.phone == phone)
        user = session.exec(statement).first()
        
        if not user:
            # User not found
            return {"error": "User not found. Please register first."}
        
        if not user.password_hash:
            # User exists but no password set (legacy user)
            return {"error": "Please register again to set a password."}
        
        # Verify password
        if not verify_password(password, user.password_hash):
            return {"error": "Invalid password."}
        
        # Password verified! Create token
        access_token = create_access_token(data={"sub": user.phone, "user_id": user.id})
        return {
            "access_token": access_token, 
            "token_type": "bearer", 
            "user_id": user.id,
            "full_name": user.full_name,
            "phone": user.phone,
            "language": user.language
        }

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

