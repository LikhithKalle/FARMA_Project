from fastapi import APIRouter, HTTPException, status
from app.schemas import UserCreate, OTPRequest, OTPVerify, Token, User
from app.services import auth_service

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register")
def register(user_in: UserCreate):
    result = auth_service.register_user_step1(user_in.phone, user_in.full_name, user_in.language)
    return result

@router.post("/verify-otp", response_model=Token)
def verify_otp(otp_in: OTPVerify):
    token_data = auth_service.verify_otp_step2(otp_in.phone, otp_in.otp)
    if not token_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid OTP",
        )
    return token_data
