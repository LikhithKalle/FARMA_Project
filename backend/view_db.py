from sqlmodel import Session, select, create_engine
# from app.models import User  # This import might fail if I didn't fix models -> schemas everywhere?
# Wait, I fixed `setup_local_db.py` to use `app.schemas`. 
# backend/app/models.py does NOT exist? The user had `app/schemas.py`.
# I should use `app.schemas`.
from app.schemas import User
from app.database import engine

def view_users():
    print(f"Connecting to database: {engine.url}")
    try:
        with Session(engine) as session:
            statement = select(User)
            users = session.exec(statement).all()
            
            print(f"\nFound {len(users)} users:\n")
            print(f"{'ID':<5} | {'Phone':<15} | {'Name':<20} | {'Password Hash (Prefix)'}")
            print("-" * 65)
            
            first_user = None
            for user in users:
                if not first_user: first_user = user
                hash_prefix = user.password_hash[:20] + "..." if user.password_hash else "NO PASSWORD"
                print(f"{user.id:<5} | {user.phone:<15} | {user.full_name:<20} | {hash_prefix}")
            
            print("\n" + "="*50)
            if first_user and first_user.password_hash:
                import bcrypt
                print(f"Testing Verification for user {first_user.phone}")
                print("We will test with PIN '1234' (assuming that is what you set) and '0000' (wrong).")
                
                # Test logic derived from auth_service.py
                stored_hash_bytes = first_user.password_hash.encode('utf-8')
                
                # Test 1: PIN 1234
                pin1 = "1234"
                res1 = bcrypt.checkpw(pin1.encode('utf-8'), stored_hash_bytes)
                print(f"Check PIN '{pin1}': {'✅ MATCH' if res1 else '❌ INVALID'}")
                
                # Test 2: PIN 0000
                pin2 = "0000"
                res2 = bcrypt.checkpw(pin2.encode('utf-8'), stored_hash_bytes)
                print(f"Check PIN '{pin2}': {'✅ MATCH (BAD!)' if res2 else '❌ INVALID (GOOD!)'}")
            else:
                print("No user found with password to test.")

    except Exception as e:
        print(f"Error reading database: {e}")

if __name__ == "__main__":
    view_users()
