import os
import logging
from twilio.rest import Client
from dotenv import load_dotenv

load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

account_sid = os.getenv("TWILIO_ACCOUNT_SID", "").strip('"')
auth_token = os.getenv("TWILIO_AUTH_TOKEN", "").strip('"')
twilio_number = os.getenv("TWILIO_PHONE_NUMBER", "").strip('"')

# Validate credentials
if not all([account_sid, auth_token, twilio_number]):
    logger.warning("Twilio credentials missing. SMS will fail.")

try:
    client = Client(account_sid, auth_token) if account_sid and auth_token else None
except Exception as e:
    logger.error(f"Failed to initialize Twilio client: {e}")
    client = None

def send_otp(phone_number: str, otp: str):
    """
    Sends an OTP to the specified phone number using Twilio.
    """
    if not client:
        logger.error("Twilio client not initialized. Cannot send SMS.")
        print(f"DEV MODE (No Client): OTP for {phone_number} is {otp}")
        return False

    try:
        logger.info(f"Attempting to send OTP to {phone_number}")
        message = client.messages.create(
            body=f"Your FARMA Verification Code is: {otp}",
            from_=twilio_number,
            to=phone_number
        )
        logger.info(f"OTP sent to {phone_number}: SID {message.sid}")
        return True
    except Exception as e:
        logger.error(f"Failed to send OTP to {phone_number}: {str(e)}")
        # For Hackathon/Dev purposes, print the OTP so we can proceed even if SMS fails
        print(f"DEV MODE (Send Failed): OTP for {phone_number} is {otp}")
        return False
