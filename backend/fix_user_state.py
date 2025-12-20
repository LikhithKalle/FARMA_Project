from sqlmodel import create_engine, text, Session
import os

DATABASE_URL = "postgresql://neondb_owner:npg_LzqZ9pfvTU0X@ep-restless-wave-a4w4nvhv-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require"
engine = create_engine(DATABASE_URL)

def fix_state():
    with engine.connect() as conn:
        print("Checking 'user' table columns...")
        result = conn.execute(text("SELECT column_name FROM information_schema.columns WHERE table_name = 'user';"))
        columns = [row[0] for row in result]
        print(f"Columns: {columns}")
        
        if 'password_hash' not in columns:
            print("CRITICAL: password_hash column missing! Attempting add...")
            conn.execute(text('ALTER TABLE "user" ADD COLUMN IF NOT EXISTS password_hash VARCHAR;'))
            conn.commit()
            print("Added password_hash column.")
        else:
            print("password_hash column exists.")

        # Delete the specific user to reset state
        phone_to_reset = "+919392777519"
        print(f"Resetting user {phone_to_reset}...")
        conn.execute(text(f"DELETE FROM \"user\" WHERE phone = '{phone_to_reset}';"))
        conn.commit()
        print(f"User {phone_to_reset} deleted. You can now register again.")

if __name__ == "__main__":
    fix_state()
