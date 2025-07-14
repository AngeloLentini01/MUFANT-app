import sqlite3

# Database connection
db_path = '../mufant_museum.db'

try:
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Check if database exists and has data
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='museum_activities';")
    table_exists = cursor.fetchone()
    
    if table_exists:
        print("✓ museum_activities table exists")
        
        # Get count of activities
        cursor.execute("SELECT COUNT(*) FROM museum_activities;")
        count = cursor.fetchone()[0]
        print(f"✓ Total activities in database: {count}")
        
        # Get events and rooms separately
        cursor.execute("SELECT COUNT(*) FROM museum_activities WHERE type = 'event';")
        events_count = cursor.fetchone()[0]
        print(f"✓ Events count: {events_count}")
        
        cursor.execute("SELECT COUNT(*) FROM museum_activities WHERE type = 'room';")
        rooms_count = cursor.fetchone()[0]
        print(f"✓ Rooms count: {rooms_count}")
        
        # Show some sample data
        cursor.execute("SELECT id, name, type FROM museum_activities LIMIT 10;")
        activities = cursor.fetchall()
        print("\nSample activities:")
        for activity in activities:
            print(f"  {activity[0]}: {activity[1]} ({activity[2]})")
            
    else:
        print("✗ museum_activities table does not exist")
        
except Exception as e:
    print(f"✗ Error connecting to database: {e}")
    
finally:
    if 'conn' in locals():
        conn.close()
