import sqlite3
import datetime

# Database connection
db_path = '../mufant_museum.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

try:
    # Sample museum activities data
    activities = [
        {
            'name': '30 ANNI DI SAILOR',
            'type': 'event',
            'description': 'Mostra commemorativa per i 30 anni della serie Sailor Moon',
            'location': 'Sala A - Piano Terra',
            'price': 15.0,
            'image_path': 'assets/images/mocks/sailor_moon.jpg',
            'start_date': '2024-01-15 10:00:00',
            'end_date': '2024-03-15 18:00:00',
            'notes': 'Mostra speciale con oggetti da collezione originali'
        },
        {
            'name': 'STAR WARS COLLECTION',
            'type': 'event',
            'description': 'Collezione completa di memorabilia di Star Wars',
            'location': 'Sala B - Primo Piano',
            'price': 20.0,
            'image_path': 'assets/images/starwars.jpg',
            'start_date': '2024-02-01 09:00:00',
            'end_date': '2024-04-30 19:00:00',
            'notes': 'Include costumi originali e repliche di navi spaziali'
        },
        {
            'name': 'SUPERHERO EXHIBITION',
            'type': 'event',
            'description': 'Esposizione dedicata ai supereroi del fumetto',
            'location': 'Sala C - Secondo Piano',
            'price': 12.0,
            'image_path': 'assets/images/superhero.jpg',
            'start_date': '2024-03-01 10:00:00',
            'end_date': '2024-05-31 18:00:00',
            'notes': 'Fumetti rari e action figures da collezione'
        },
        {
            'name': 'MAIN LIBRARY',
            'type': 'room',
            'description': 'Biblioteca principale del museo con collezioni storiche',
            'location': 'Piano Terra - Ala Est',
            'price': 5.0,
            'image_path': 'assets/images/library.jpg',
            'start_date': '2024-01-01 08:00:00',
            'end_date': '2024-12-31 20:00:00',
            'notes': 'Accesso permanente alla biblioteca storica'
        },
        {
            'name': 'HALL OF HEROES',
            'type': 'room',
            'description': 'Sala dedicata agli eroi della cultura pop',
            'location': 'Primo Piano - Ala Ovest',
            'price': 8.0,
            'image_path': 'assets/images/mocks/heroes_hall.jpg',
            'start_date': '2024-01-01 09:00:00',
            'end_date': '2024-12-31 19:00:00',
            'notes': 'Sala interattiva con postazioni multimediali'
        }
    ]

    for activity in activities:
        # Insert into museum_activities table
        cursor.execute('''
            INSERT INTO museum_activities (name, type, description, start_date, end_date, location, notes, price, image_path, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            activity['name'],
            activity['type'],
            activity['description'],
            activity['start_date'],
            activity['end_date'],
            activity['location'],
            activity['notes'],
            activity['price'],
            activity['image_path'],
            datetime.datetime.now().isoformat(),
            datetime.datetime.now().isoformat()
        ))
        
        print(f"Added activity: {activity['name']} ({activity['type']})")

    # Commit the changes
    conn.commit()
    print("Successfully populated the database with museum activities!")
    
    # Verify the data was inserted
    cursor.execute('SELECT id, name, type, price FROM museum_activities')
    
    results = cursor.fetchall()
    print(f"\nVerification: Found {len(results)} museum activities:")
    for result in results:
        print(f"- {result[1]} ({result[2]}) - €{result[3]}")

except Exception as e:
    print(f"Error: {e}")
    conn.rollback()

finally:
    conn.close()
