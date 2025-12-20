from sqlmodel import create_engine, text, Session, SQLModel
import bcrypt

# Monkey patch for passlib < 1.7.4 compatibility with bcrypt >= 4.0.0
# The error "module 'bcrypt' has no attribute '__about__'" is caused by this mismatch.
if not hasattr(bcrypt, '__about__'):
    class About:
        __version__ = bcrypt.__version__
    bcrypt.__about__ = About()

# DISABLE Passlib's "wrap bug" check which sends an 80-byte password to bcrypt
# causing "ValueError: password cannot be longer than 72 bytes"
import passlib.handlers.bcrypt
passlib.handlers.bcrypt.bcrypt.detect_wrap_bug = lambda *args, **kwargs: False

from passlib.context import CryptContext

DATABASE_URL = "postgresql://neondb_owner:npg_LzqZ9pfvTU0X@ep-restless-wave-a4w4nvhv-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require"
engine = create_engine(DATABASE_URL)
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def run_diagnostics():
    with engine.connect() as conn:
        print("--- Diagnostic Start ---")
        
        # 1. Check Schema
        print("Checking 'user' table schema...")
        result = conn.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name = 'user';"))
        columns = [row[0] for row in result]
        print(f"Columns found: {columns}")
        
        if 'password_hash' not in columns:
            print("CRITICAL: password_hash column missing. adding it now...")
            try:
                conn.execute(text('ALTER TABLE "user" ADD COLUMN IF NOT EXISTS password_hash VARCHAR;'))
                conn.commit()
                print("Added password_hash column.")
            except Exception as e:
                print(f"Error adding column: {e}")
        else:
            print("password_hash column present.")
            
        # 2. Test Insertion
        print("\nAttempting Manual User Insertion...")
        phone = "+919999988888" # specific test user
        pin = "1234"
        hashed = pwd_context.hash(pin)
        
        # Clean up first
        conn.execute(text(f"DELETE FROM \"user\" WHERE phone = '{phone}';"))
        conn.commit()
        
        insert_sql = text("""
            INSERT INTO "user" (phone, full_name, language, password_hash, created_at)
            VALUES (:phone, :name, :lang, :hash, :created)
            RETURNING id;
        """)
        
        try:
            result = conn.execute(insert_sql, {
                "phone": phone,
                "name": "Debug User",
                "lang": "en",
                "hash": hashed,
                "created": "now"
            })
            user_id = result.scalar()
            conn.commit()
            print(f"SUCCESS! Manually inserted user with ID: {user_id}")
            print(f"Please try logging in with {phone} and PIN {pin} after restarting backend.")
        except Exception as e:
            print(f"INSERT FAILED: {e}")
            
    print("--- Diagnostic End ---")

if __name__ == "__main__":
    run_diagnostics()
