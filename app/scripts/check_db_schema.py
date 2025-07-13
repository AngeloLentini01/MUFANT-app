import sqlite3

# Database connection
db_path = '../mufant_museum.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

try:
    # Get all table names
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    
    print("Tables in the database:")
    for table in tables:
        print(f"- {table[0]}")
    
    print("\nTable schemas:")
    for table in tables:
        table_name = table[0]
        cursor.execute(f"PRAGMA table_info({table_name});")
        columns = cursor.fetchall()
        print(f"\n{table_name}:")
        for col in columns:
            print(f"  {col[1]} {col[2]} {'NOT NULL' if col[3] else ''} {'PRIMARY KEY' if col[5] else ''}")

except Exception as e:
    print(f"Error: {e}")

finally:
    conn.close()
