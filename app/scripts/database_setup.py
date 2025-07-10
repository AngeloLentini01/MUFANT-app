#!/usr/bin/env python3
"""
Database setup script for MUFANT Museum app
This script creates and populates the mufant_museum.db database
"""

import sqlite3
import os
import sys
from datetime import datetime, timedelta

# Add the project root to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def create_database():
    """Create the database and tables"""
    db_path = "mufant_museum.db"
    
    # Remove existing database
    if os.path.exists(db_path):
        os.remove(db_path)
        print(f"Removed existing database: {db_path}")
    
    # Create new database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Create users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create museum_activities table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS museum_activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            description TEXT,
            start_date TIMESTAMP,
            end_date TIMESTAMP,
            location TEXT DEFAULT 'Mufant',
            notes TEXT,
            price REAL DEFAULT 0.0,
            image_path TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create carts table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS carts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (username) REFERENCES users(username)
        )
    ''')
    
    # Create tickets table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS tickets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cart_id INTEGER NOT NULL,
            museum_activity_id INTEGER NOT NULL,
            quantity INTEGER DEFAULT 1,
            charging_rate REAL DEFAULT 0.0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (cart_id) REFERENCES carts(id),
            FOREIGN KEY (museum_activity_id) REFERENCES museum_activities(id)
        )
    ''')
    
    # Create coupons table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS coupons (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT UNIQUE NOT NULL,
            discount_percentage REAL DEFAULT 0.0,
            is_active BOOLEAN DEFAULT TRUE,
            expires_at TIMESTAMP,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create payments table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS payments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            amount REAL NOT NULL,
            currency TEXT DEFAULT 'EUR',
            status TEXT DEFAULT 'pending',
            transaction_id TEXT,
            payment_method TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (username) REFERENCES users(username)
        )
    ''')
    
    conn.commit()
    print("Database tables created successfully!")
    
    return conn, cursor

def populate_database(conn, cursor):
    """Populate the database with sample data"""
    
    # Insert sample museum activities
    activities = [
        ("MUFANT - Full price", "Museum", "Full price museum entry for visitors over 10 years", 
         None, None, "Mufant", "", 8.00, "assets/images/logo.png"),
        ("MUFANT - Reduced price", "Museum", "Reduced price for University students, Senior over 65 years, AIACE Torino Partners", 
         None, None, "Mufant", "", 7.00, "assets/images/logo.png"),
        ("MUFANT - Disabled", "Museum", "Reduced price for disabled people (free companion), possessors Torino+Piemonte Card", 
         None, None, "Mufant", "", 6.00, "assets/images/logo.png"),
        ("MUFANT - Kids", "Museum", "Kids entry from 4 to 10 years", 
         None, None, "Mufant", "", 5.00, "assets/images/logo.png"),
        ("MUFANT - Free", "Museum", "Free entry for under 4 years, possessors 'Abbonamento Musei Piemonte e Valle d'Aosta'", 
         None, None, "Mufant", "", 0.00, "assets/images/logo.png"),
        ("Star Wars Exhibition", "Event", "Explore the Star Wars universe with rare collectibles and props", 
         datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 
         (datetime.now() + timedelta(days=90)).strftime('%Y-%m-%d %H:%M:%S'), 
         "Mufant", "Special exhibition featuring Han Solo carbonite prop", 12.00, "assets/images/starwars.jpg"),
        ("Superhero Collection", "Event", "Discover the world of superheroes through comics and memorabilia", 
         datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 
         (datetime.now() + timedelta(days=60)).strftime('%Y-%m-%d %H:%M:%S'), 
         "Mufant", "Interactive superhero experience", 10.00, "assets/images/superhero.jpg"),
        ("Library Tour", "Tour", "Guided tour of the museum's extensive library collection", 
         datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 
         (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d %H:%M:%S'), 
         "Mufant", "1-hour guided tour", 5.00, "assets/images/library.jpg"),
    ]
    
    for activity in activities:
        cursor.execute('''
            INSERT INTO museum_activities 
            (name, type, description, start_date, end_date, location, notes, price, image_path)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', activity)
    
    # Insert sample coupons
    coupons = [
        ("WELCOME10", 10.0, True, (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d %H:%M:%S')),
        ("STUDENT15", 15.0, True, (datetime.now() + timedelta(days=60)).strftime('%Y-%m-%d %H:%M:%S')),
        ("FAMILY20", 20.0, True, (datetime.now() + timedelta(days=90)).strftime('%Y-%m-%d %H:%M:%S')),
    ]
    
    for coupon in coupons:
        cursor.execute('''
            INSERT INTO coupons (code, discount_percentage, is_active, expires_at)
            VALUES (?, ?, ?, ?)
        ''', coupon)
    
    conn.commit()
    print("Database populated with sample data!")

def main():
    """Main function to setup and populate the database"""
    print("Setting up MUFANT Museum database...")
    
    conn, cursor = create_database()
    populate_database(conn, cursor)
    
    # Print summary
    cursor.execute("SELECT COUNT(*) FROM museum_activities")
    activities_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM coupons")
    coupons_count = cursor.fetchone()[0]
    
    print(f"\nDatabase setup complete!")
    print(f"- Museum activities: {activities_count}")
    print(f"- Coupons: {coupons_count}")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
