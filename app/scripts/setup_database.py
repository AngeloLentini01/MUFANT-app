import sqlite3
import datetime

# Database connection
db_path = '../mufant_museum.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

try:
    # Create the museum_activities table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS museum_activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            description TEXT,
            start_date TIMESTAMP,
            end_date TIMESTAMP,
            location TEXT,
            notes TEXT,
            price REAL,
            image_path TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    print("✓ Created museum_activities table")
    
    # Sample museum activities data
    activities = [
        {
            'name': '30 ANNI DI SAILOR',
            'description': 'Mostra commemorativa per i 30 anni della serie Sailor Moon',
            'type': 'event',
            'image_path': 'assets/images/locandine/sailor-moon.jpg',
            'price': 15.0,
            'notes': '01-28 nov•MUFANT Museum\nFree entry'
        },
        {
            'name': 'STAR WARS COLLECTION',
            'description': 'Collezione completa di memorabilia di Star Wars',
            'type': 'event',
            'image_path': 'assets/images/starwars.jpg',
            'price': 20.0,
            'notes': '01-28 nov•MUFANT Museum\nStarting from 5€'
        },
        {
            'name': 'SUPERHERO EXHIBITION',
            'description': 'Esposizione dedicata ai supereroi del fumetto',
            'type': 'event',
            'image_path': 'assets/images/superhero.jpg',
            'price': 12.0,
            'notes': '01-28 nov•MUFANT Museum\nStarting from 5€'
        },
        {
            'name': 'Riccardo Valla\'s Library',
            'description': 'Biblioteca principale del museo con collezioni storiche',
            'type': 'room',
            'image_path': 'assets/images/library.jpg',
            'price': 5.0,
            'notes': 'Quiet reading space'
        },
        {
            'name': 'Star Wars',
            'description': 'Sala dedicata all\'universo di Star Wars',
            'type': 'room',
            'image_path': 'assets/images/starwars.jpg',
            'price': 8.0,
            'notes': 'Enter the Star Wars universe'
        },
        {
            'name': 'Superheroes',
            'description': 'Sala dedicata agli eroi della cultura pop',
            'type': 'room',
            'image_path': 'assets/images/superhero.jpg',
            'price': 8.0,
            'notes': 'Superhero themed room'
        }
    ]

    # Clear existing data first
    cursor.execute('DELETE FROM museum_activities')
    
    # Insert the activities
    for activity in activities:
        cursor.execute('''
            INSERT INTO museum_activities (name, type, description, image_path, price, notes, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            activity['name'],
            activity['type'],
            activity['description'],
            activity['image_path'],
            activity['price'],
            activity['notes'],
            datetime.datetime.now().isoformat(),
            datetime.datetime.now().isoformat()
        ))
        
        print(f"✓ Added activity: {activity['name']} ({activity['type']})")

    # Commit the changes
    conn.commit()
    print("\n✓ Successfully created and populated the database with museum activities!")
    
    # Verify the data was inserted
    cursor.execute('SELECT COUNT(*) FROM museum_activities WHERE type = ?', ('event',))
    events_count = cursor.fetchone()[0]
    
    cursor.execute('SELECT COUNT(*) FROM museum_activities WHERE type = ?', ('room',))
    rooms_count = cursor.fetchone()[0]
    
    print(f"✓ Verification: {events_count} events and {rooms_count} rooms added to database")

except Exception as e:
    print(f"✗ Error: {e}")
    conn.rollback()

finally:
    conn.close()
