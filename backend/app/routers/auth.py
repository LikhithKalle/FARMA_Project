from fastapi import APIRouter, HTTPException, status
from app.schemas import UserCreate, OTPRequest, OTPVerify, Token, User, LoginRequest
from app.services import auth_service

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register")
def register(user_in: UserCreate):
    result = auth_service.register_user_step1(
        user_in.phone, 
        user_in.full_name, 
        user_in.language,
        password=user_in.password
    )
    if result.get("error"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=result.get("message", "Registration failed"),
        )
    return result

@router.post("/login")
def login(login_in: LoginRequest):
    """Login with phone and password."""
    result = auth_service.login_user(login_in.phone, login_in.password)
    if result.get("error"):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=result.get("error", "Invalid credentials"),
        )
    return result

@router.post("/verify-otp", response_model=Token)
def verify_otp(otp_in: OTPVerify):
    try:
        token_data = auth_service.verify_otp_step2(otp_in.phone, otp_in.otp)
        if not token_data:
            # None returned means input mismatch (wrong OTP)
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid OTP",
            )
        return token_data
    except HTTPException:
        raise
    except Exception as e:
        # Catch explicit database exceptions raised by service
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        )

