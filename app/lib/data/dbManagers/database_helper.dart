import 'dart:math';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'museum_app.db';
  static const int _databaseVersion = 8;

  // ULID generation constants
  static const String _ulidAlphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  static final Random _random = Random();
  static final Logger _logger = Logger('DatabaseHelper');

  // Generate a ULID string
  static String generateUlid() {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Time component (10 characters)
    final timeStr = _encodeTime(now);

    // Random component (16 characters)
    final randomStr = _encodeRandom();

    return timeStr + randomStr;
  }

  static String _encodeTime(int time) {
    String result = '';
    for (int i = 0; i < 10; i++) {
      result = _ulidAlphabet[time % 32] + result;
      time = time ~/ 32;
    }
    return result;
  }

  static String _encodeRandom() {
    String result = '';
    for (int i = 0; i < 16; i++) {
      result += _ulidAlphabet[_random.nextInt(32)];
    }
    return result;
  }

  // Get the database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create database tables
  static Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  // Upgrade database schema
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < newVersion) {
      // Drop existing tables that need to be recreated
      await _dropTables(db);

      // Create new tables
      await _createTables(db);
    }
  }

  // Create all tables in the database
  static Future<void> _createTables(Database db) async {
    _logger.fine('DEBUG: Creating tables...');

    // Create BaseEntity table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BaseEntity (
        id TEXT PRIMARY KEY,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        last_update_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    _logger.fine('DEBUG: BaseEntity table created');

    // Create Details table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Details (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        imageUrlOrPath TEXT NOT NULL DEFAULT '',
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');
    _logger.fine('DEBUG: Details table created');

    // Create DateTimeRange table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS DateTimeRange (
        id TEXT PRIMARY KEY,
        start_date TEXT DEFAULT CURRENT_TIMESTAMP,
        end_date TEXT NOT NULL
      )
    ''');

    // Create SupportedLanguage table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS SupportedLanguage (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    // Create User table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS User (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash BLOB NOT NULL,
        community_chat_fk TEXT,
        details_fk TEXT,
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (community_chat_fk) REFERENCES CommunityChat(id),
        FOREIGN KEY (id) REFERENCES BaseEntity(id)
      )
    ''');

    // Create StaffMember table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS StaffMember (
        id TEXT PRIMARY KEY,
        user_fk TEXT NOT NULL,
        role TEXT NOT NULL,
        FOREIGN KEY (user_fk) REFERENCES User(id)
      )
    ''');

    // Create MuseumVisitorDetails table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MuseumVisitorDetails (
        id TEXT PRIMARY KEY,
        user_fk TEXT,
        subscription_fk TEXT,
        FOREIGN KEY (user_fk) REFERENCES User(id),
        FOREIGN KEY (subscription_fk) REFERENCES Subscription(id)
      )
    ''');

    // Create PhoneCountryCode table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PhoneCountryCode (
        id TEXT PRIMARY KEY,
        country_code TEXT NOT NULL
      )
    ''');

    // Create PhoneContact table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS PhoneContact (
        id TEXT PRIMARY KEY,
        user_fk TEXT,
        local_phone_number TEXT NOT NULL,
        country_code_fk TEXT NOT NULL,
        details_fk TEXT,
        FOREIGN KEY (user_fk) REFERENCES User(id),
        FOREIGN KEY (country_code_fk) REFERENCES PhoneCountryCode(id),
        FOREIGN KEY (details_fk) REFERENCES Details(id)
      )
    ''');

    // Create CommunityChat table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CommunityChat (
        id TEXT PRIMARY KEY,
        details_fk TEXT,
        FOREIGN KEY (details_fk) REFERENCES Details(id)
      )
    ''');

    // Create CommunityChatMessages table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CommunityChatMessages (
        id TEXT PRIMARY KEY,
        community_fk TEXT NOT NULL,
        sender_fk TEXT NOT NULL,
        content TEXT NOT NULL,
        FOREIGN KEY (community_fk) REFERENCES CommunityChat(id),
        FOREIGN KEY (sender_fk) REFERENCES User(id),
        FOREIGN KEY (id) REFERENCES BaseEntity(id)
      )
    ''');

    // Create Subscription table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Subscription (
        id TEXT PRIMARY KEY,
        details_fk TEXT NOT NULL,
        validity_datetime_range_fk TEXT NOT NULL,
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (validity_datetime_range_fk) REFERENCES DateTimeRange(id)
      )
    ''');

    // Create Cart table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Cart (
        id TEXT PRIMARY KEY,
        user_fk TEXT NOT NULL,
        coupon_fk TEXT,
        FOREIGN KEY (user_fk) REFERENCES User(id),
        FOREIGN KEY (coupon_fk) REFERENCES Coupon(id),
        FOREIGN KEY (id) REFERENCES BaseEntity(id)
      )
    ''');

    // Create Coupon table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Coupon (
        id TEXT PRIMARY KEY,
        code_hash BLOB NOT NULL,
        usages INTEGER DEFAULT 1,
        discount_percentage INTEGER NOT NULL,
        validity_datetime_range_fk TEXT NOT NULL,
        details_fk TEXT NOT NULL,
        FOREIGN KEY (validity_datetime_range_fk) REFERENCES DateTimeRange(id),
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (id) REFERENCES BaseEntity(id)
      )
    ''');

    // Create CartItem table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CartItem (
        id TEXT PRIMARY KEY,
        cart_fk TEXT NOT NULL,
        details_fk TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        type_of_cart_item_fk TEXT NOT NULL,
        FOREIGN KEY (cart_fk) REFERENCES Cart(id),
        FOREIGN KEY (details_fk) REFERENCES Details(id)
      )
    ''');

    // Create Product table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Product (
        id TEXT PRIMARY KEY,
        product_type TEXT NOT NULL
      )
    ''');

    // Create Ticket table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Ticket (
        id TEXT PRIMARY KEY,
        museum_activity_fk TEXT NOT NULL,
        chargingRate TEXT NOT NULL,
        FOREIGN KEY (museum_activity_fk) REFERENCES MuseumActivity(id)
      )
    ''');

    // Create Payment table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Payment (
        id TEXT PRIMARY KEY,
        cart_fk TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        total_amount REAL NOT NULL,
        transaction_id TEXT UNIQUE NOT NULL,
        status TEXT CHECK (status IN ('pending', 'success', 'failed')),
        FOREIGN KEY (cart_fk) REFERENCES Cart(id),
        FOREIGN KEY (id) REFERENCES BaseEntity(id)
      )
    ''');

    // Create MuseumActivity table (flat structure for compatibility)
    _logger.fine('DEBUG: Creating MuseumActivity table...');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MuseumActivity (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        start_date TEXT DEFAULT CURRENT_TIMESTAMP,
        end_date TEXT NOT NULL,
        location TEXT,
        notes TEXT NOT NULL DEFAULT '',
        price REAL DEFAULT 0.0,
        image_path TEXT NOT NULL DEFAULT '',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    _logger.fine('DEBUG: MuseumActivity table created successfully');

    // Verify the table was created
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='MuseumActivity'",
    );
    _logger.fine('DEBUG: MuseumActivity table exists: ${tables.isNotEmpty}');

    // Create MuseumActivityDetails table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MuseumActivityDetails (
        id TEXT PRIMARY KEY,
        location TEXT,
        details_fk TEXT NOT NULL,
        type_fk TEXT NOT NULL,
        active_datetime_range_fk TEXT NOT NULL,
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (type_fk) REFERENCES TypeOfMuseumActivity(id),
        FOREIGN KEY (active_datetime_range_fk) REFERENCES DateTimeRange(id)
      )
    ''');

    // Create TypeOfMuseumActivity table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS TypeOfMuseumActivity (
        id TEXT PRIMARY KEY,
        details_fk TEXT NOT NULL,
        activity_options TEXT,
        FOREIGN KEY (details_fk) REFERENCES Details(id)
      )
    ''');

    // Create Book table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Book (
        id TEXT PRIMARY KEY,
        author TEXT NOT NULL,
        publisher TEXT NOT NULL,
        book_genre_fk TEXT NOT NULL,
        language_fk TEXT NOT NULL,
        FOREIGN KEY (book_genre_fk) REFERENCES BookGenre(id),
        FOREIGN KEY (language_fk) REFERENCES SupportedLanguage(id)
      )
    ''');

    // Create BookGenre table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BookGenre (
        id TEXT PRIMARY KEY,
        details_fk TEXT NOT NULL,
        datetime_range_fk TEXT NOT NULL,
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (datetime_range_fk) REFERENCES DateTimeRange(id)
      )
    ''');

    // Create VisitDetails table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS VisitDetails (
        id TEXT PRIMARY KEY,
        museum_activity_fk TEXT NOT NULL,
        reservation_datetime_range_fk TEXT NOT NULL,
        details_fk TEXT NOT NULL,
        audio_guide_fk TEXT,
        FOREIGN KEY (museum_activity_fk) REFERENCES MuseumActivity(id),
        FOREIGN KEY (reservation_datetime_range_fk) REFERENCES DateTimeRange(id),
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (audio_guide_fk) REFERENCES AudioGuide(id)
      )
    ''');

    // Create AudioGuide table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS AudioGuide (
        id TEXT PRIMARY KEY,
        details_fk TEXT NOT NULL,
        FOREIGN KEY (details_fk) REFERENCES Details(id)
      )
    ''');

    // Create VoiceCharacter table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS VoiceCharacter (
        id TEXT PRIMARY KEY,
        details_fk TEXT NOT NULL,
        FOREIGN KEY (details_fk) REFERENCES Details(id)
      )
    ''');

    // Create AudioGuideSection table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS AudioGuideSection (
        id TEXT PRIMARY KEY,
        audio_guide_fk TEXT NOT NULL,
        details_fk TEXT NOT NULL,
        stepNumber INTEGER NOT NULL,
        audio_language_fk TEXT NOT NULL,
        voice_character_fk TEXT NOT NULL,
        transcript TEXT,
        FOREIGN KEY (audio_guide_fk) REFERENCES AudioGuide(id),
        FOREIGN KEY (details_fk) REFERENCES Details(id),
        FOREIGN KEY (audio_language_fk) REFERENCES SupportedLanguage(id),
        FOREIGN KEY (voice_character_fk) REFERENCES VoiceCharacter(id)
      )
    ''');

    // Create GuidedVisit table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS GuidedVisit (
        id TEXT PRIMARY KEY,
        num_of_participants_fk TEXT NOT NULL,
        guide_fk TEXT,
        visit_details_fk TEXT NOT NULL,
        FOREIGN KEY (num_of_participants_fk) REFERENCES GuidedVisitNumberOfParticipants(id),
        FOREIGN KEY (guide_fk) REFERENCES StaffMember(id),
        FOREIGN KEY (visit_details_fk) REFERENCES VisitDetails(id)
      )
    ''');

    // Create GuidedVisitNumberOfParticipants table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS GuidedVisitNumberOfParticipants (
        id TEXT PRIMARY KEY,
        numOfAdults INTEGER NOT NULL,
        numOfDisabled INTEGER NOT NULL,
        numOfDisabledPersonsAccompaniers INTEGER NOT NULL,
        numOfKidsBetween4And10 INTEGER NOT NULL
      )
    ''');

    // Create EducationalVisit table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS EducationalVisit (
        id TEXT PRIMARY KEY,
        num_of_participants_fk TEXT NOT NULL,
        visit_details_fk TEXT NOT NULL,
        lab_activity_fk TEXT,
        FOREIGN KEY (num_of_participants_fk) REFERENCES EducationalVisitNumberOfParticipants(id),
        FOREIGN KEY (visit_details_fk) REFERENCES VisitDetails(id),
        FOREIGN KEY (lab_activity_fk) REFERENCES TypeOfMuseumActivity(id)
      )
    ''');

    // Create EducationalVisitNumberOfParticipants table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS EducationalVisitNumberOfParticipants (
        id TEXT PRIMARY KEY,
        numOfParticipants INTEGER NOT NULL,
        numOfAccompaniers INTEGER NOT NULL
      )
    ''');

    // Create simple museum_activities table for compatibility
    await db.execute('''
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
    ''');
  }

  // Drop tables if they exist
  static Future<void> _dropTables(Database db) async {
    // Drop tables in reverse order to avoid foreign key constraints
    await db.execute('DROP TABLE IF EXISTS museum_activities');
    await db.execute(
      'DROP TABLE IF EXISTS EducationalVisitNumberOfParticipants',
    );
    await db.execute('DROP TABLE IF EXISTS EducationalVisit');
    await db.execute('DROP TABLE IF EXISTS GuidedVisitNumberOfParticipants');
    await db.execute('DROP TABLE IF EXISTS GuidedVisit');
    await db.execute('DROP TABLE IF EXISTS AudioGuideSection');
    await db.execute('DROP TABLE IF EXISTS VoiceCharacter');
    await db.execute('DROP TABLE IF EXISTS AudioGuide');
    await db.execute('DROP TABLE IF EXISTS VisitDetails');
    await db.execute('DROP TABLE IF EXISTS BookGenre');
    await db.execute('DROP TABLE IF EXISTS Book');
    await db.execute('DROP TABLE IF EXISTS TypeOfMuseumActivity');
    await db.execute('DROP TABLE IF EXISTS MuseumActivityDetails');
    await db.execute('DROP TABLE IF EXISTS MuseumActivity');
    await db.execute('DROP TABLE IF EXISTS Payment');
    await db.execute('DROP TABLE IF EXISTS Ticket');
    await db.execute('DROP TABLE IF EXISTS Product');
    await db.execute('DROP TABLE IF EXISTS CartItem');
    await db.execute('DROP TABLE IF EXISTS Coupon');
    await db.execute('DROP TABLE IF EXISTS Cart');
    await db.execute('DROP TABLE IF EXISTS Subscription');
    await db.execute('DROP TABLE IF EXISTS CommunityChatMessages');
    await db.execute('DROP TABLE IF EXISTS CommunityChat');
    await db.execute('DROP TABLE IF EXISTS PhoneContact');
    await db.execute('DROP TABLE IF EXISTS PhoneCountryCode');
    await db.execute('DROP TABLE IF EXISTS MuseumVisitorDetails');
    await db.execute('DROP TABLE IF EXISTS StaffMember');
    await db.execute('DROP TABLE IF EXISTS User');
    await db.execute('DROP TABLE IF EXISTS SupportedLanguage');
    await db.execute('DROP TABLE IF EXISTS DateTimeRange');
    await db.execute('DROP TABLE IF EXISTS Details');
    await db.execute('DROP TABLE IF EXISTS BaseEntity');
  }

  // Initialize the database with sample data
  static Future<void> initializeSampleData() async {
    final db = await database;

    _logger.fine('DEBUG: Checking if sample data exists...');

    // Verify MuseumActivity table exists
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='MuseumActivity'",
    );
    _logger.warning(
      'DEBUG: MuseumActivity table exists in sample data: ${tables.isNotEmpty}',
    );

    // Always clear and reload sample data for debugging
    _logger.fine(
      'DEBUG: Clearing all existing data and reloading sample data...',
    );

    // Clear all existing data
    await db.delete('MuseumActivity');
    await db.delete('SupportedLanguage');
    await db.delete('PhoneCountryCode');
    await db.delete('DateTimeRange');
    await db.delete('Details');
    await db.delete('TypeOfMuseumActivity');
    await db.delete('MuseumActivityDetails');

    _logger.fine(
      'DEBUG: Existing data cleared, inserting fresh sample data...',
    );

    // Start a transaction with error handling
    await db.transaction((txn) async {
      try {
        // Generate ULIDs for sample data
        final langEnId = generateUlid();
        final langItId = generateUlid();
        final pccItId = generateUlid();
        final pccUsId = generateUlid();

        // Details for activities
        final eventDetailsId1 = generateUlid();
        final eventDetailsId2 = generateUlid();
        final eventDetailsId3 = generateUlid();
        final roomDetailsId1 = generateUlid();

        // Activity types
        final visitTypeId = generateUlid();
        final exhibitionTypeId = generateUlid();

        // DateTime ranges
        final dateRangeId1 = generateUlid();
        final dateRangeId2 = generateUlid();

        // Museum Activity Details
        final museumActivityDetailsId1 = generateUlid();
        final museumActivityDetailsId2 = generateUlid();
        final museumActivityDetailsId3 = generateUlid();
        final museumActivityDetailsId4 = generateUlid();

        _logger.fine('DEBUG: Starting sample data transaction...');

        // Add supported languages
        await txn.insert('SupportedLanguage', {
          'id': langEnId,
          'name': 'English',
        });

        await txn.insert('SupportedLanguage', {
          'id': langItId,
          'name': 'Italian',
        });

        // Add phone country codes
        await txn.insert('PhoneCountryCode', {
          'id': pccItId,
          'country_code': '+39',
        });

        await txn.insert('PhoneCountryCode', {
          'id': pccUsId,
          'country_code': '+1',
        });

        // Add DateTime ranges
        await txn.insert('DateTimeRange', {
          'id': dateRangeId1,
          'start_date': DateTime.now().toIso8601String(),
          'end_date': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        });

        await txn.insert('DateTimeRange', {
          'id': dateRangeId2,
          'start_date': DateTime.now().toIso8601String(),
          'end_date': DateTime.now().add(Duration(days: 60)).toIso8601String(),
        });

        // Add Details for museum activities
        await txn.insert('Details', {
          'id': eventDetailsId1,
          'name': '30 ANNI DI SAILOR',
          'description':
              'Mostra commemorativa per i 30 anni della serie Sailor Moon',
          'imageUrlOrPath': 'assets/images/locandine/sailor-moon.jpg',
          'notes': '01-28 nov•MUFANT Museum\nFree entry',
        });

        await txn.insert('Details', {
          'id': eventDetailsId2,
          'name': 'STAR WARS COLLECTION',
          'description': 'Collezione completa di memorabilia di Star Wars',
          'imageUrlOrPath': 'assets/images/starwars.jpg',
          'notes': '01-28 nov•MUFANT Museum\nStarting from 5€',
        });

        await txn.insert('Details', {
          'id': eventDetailsId3,
          'name': 'SUPERHERO EXHIBITION',
          'description': 'Esposizione dedicata ai supereroi del fumetto',
          'imageUrlOrPath': 'assets/images/superhero.jpg',
          'notes': '01-28 nov•MUFANT Museum\nStarting from 5€',
        });

        await txn.insert('Details', {
          'id': roomDetailsId1,
          'name': 'Riccardo Valla\'s Library',
          'description': 'Biblioteca specializzata in fantascienza e fantasy',
          'imageUrlOrPath': 'assets/images/library.jpg',
          'notes': '2nd floor\n',
        });

        // Add Type Of Museum Activity details
        await txn.insert('Details', {
          'id': generateUlid(),
          'name': 'Visit',
          'description': 'Standard museum visit',
          'imageUrlOrPath': '',
          'notes': 'Standard visit activity',
        });

        await txn.insert('Details', {
          'id': generateUlid(),
          'name': 'Exhibition',
          'description': 'Special exhibition',
          'imageUrlOrPath': '',
          'notes': 'Special exhibition activity',
        });

        // Add TypeOfMuseumActivity
        await txn.insert('TypeOfMuseumActivity', {
          'id': visitTypeId,
          'details_fk': eventDetailsId1, // Reusing details for simplicity
          'activity_options': 'Visit',
        });

        await txn.insert('TypeOfMuseumActivity', {
          'id': exhibitionTypeId,
          'details_fk': eventDetailsId2,
          'activity_options': 'Visit',
        });

        // Add MuseumActivityDetails
        await txn.insert('MuseumActivityDetails', {
          'id': museumActivityDetailsId1,
          'location': 'Main Exhibition Hall',
          'details_fk': eventDetailsId1,
          'type_fk': visitTypeId,
          'active_datetime_range_fk': dateRangeId1,
        });

        await txn.insert('MuseumActivityDetails', {
          'id': museumActivityDetailsId2,
          'location': 'Gallery A',
          'details_fk': eventDetailsId2,
          'type_fk': exhibitionTypeId,
          'active_datetime_range_fk': dateRangeId1,
        });

        await txn.insert('MuseumActivityDetails', {
          'id': museumActivityDetailsId3,
          'location': 'Gallery B',
          'details_fk': eventDetailsId3,
          'type_fk': exhibitionTypeId,
          'active_datetime_range_fk': dateRangeId2,
        });

        await txn.insert('MuseumActivityDetails', {
          'id': museumActivityDetailsId4,
          'location': 'Library Room',
          'details_fk': roomDetailsId1,
          'type_fk': visitTypeId,
          'active_datetime_range_fk': dateRangeId2,
        });

        _logger.fine('DEBUG: Starting MuseumActivity insertions...');

        // Add sample museum activities with flat structure
        _logger.fine('DEBUG: Inserting Ufo Pop event...');
        await txn.insert('MuseumActivity', {
          'id': generateUlid(),
          'name': 'Ufo Pop',
          'type': 'event',
          'description': 'Mostra dedicata alla cultura pop e agli UFO',
          'start_date': '2024-01-01T10:00:00',
          'end_date': '2024-12-31T18:00:00',
          'location': 'MUFANT Museum - Main Hall',
          'image_path': 'assets/images/locandine/ufo-pop.png',
          'price': 15.0,
          'notes': 'starting_from 5',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.fine('DEBUG: Successfully inserted Ufo Pop event');

        _logger.fine('DEBUG: Inserting Artificial Prophecies event...');
        await txn.insert('MuseumActivity', {
          'id': generateUlid(),
          'name': 'Artificial Prophecies',
          'type': 'event',
          'description': 'Esposizione su intelligenza artificiale e futuro',
          'start_date': '2024-01-01T10:00:00',
          'end_date': '2024-12-31T18:00:00',
          'location': 'MUFANT Museum - Tech Wing',
          'image_path': 'assets/images/locandine/profezie-artificiali.jpg',
          'price': 20.0,
          'notes': '01-28 nov•MUFANT Museum\nComing soon',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.fine(
          'DEBUG: Successfully inserted Artificial Prophecies event',
        );

        _logger.fine('DEBUG: Inserting Sailor Moon Anniversary event...');
        await txn.insert('MuseumActivity', {
          'id': generateUlid(),
          'name': 'Sailor Moon\'s Anniversary',
          'type': 'event',
          'description':
              '30 anni di Sailor - Mostra commemorativa per i 30 anni della serie Sailor Moon',
          'start_date': '2024-01-01T10:00:00',
          'end_date': '2024-12-31T18:00:00',
          'location': 'MUFANT Museum - Main Exhibition Hall',
          'image_path': 'assets/images/locandine/sailor-moon.jpg',
          'price': 0.0,
          'notes': '01-28 nov•MUFANT Museum\nFree entry',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.fine(
          'DEBUG: Successfully inserted Sailor Moon Anniversary event',
        );

        _logger.fine('DEBUG: Inserting Library room...');
        await txn.insert('MuseumActivity', {
          'id': generateUlid(),
          'name': 'Riccardo Valla\'s Library',
          'type': 'room',
          'description': 'Biblioteca specializzata in fantascienza e fantasy',
          'start_date': '2024-01-01T09:00:00',
          'end_date': '2024-12-31T20:00:00',
          'location': 'MUFANT Museum - Library Wing',
          'image_path': 'assets/images/library.jpg',
          'price': 0.0,
          'notes': '2nd floor\n',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.fine('DEBUG: Successfully inserted Library room');

        _logger.fine('DEBUG: Inserting Star Wars room...');
        await txn.insert('MuseumActivity', {
          'id': generateUlid(),
          'name': 'Star Wars',
          'type': 'room',
          'description': 'Collezione completa di memorabilia di Star Wars',
          'start_date': '2024-01-01T09:00:00',
          'end_date': '2024-12-31T20:00:00',
          'location': 'MUFANT Museum - Star Wars Wing',
          'image_path': 'assets/images/starwars.jpg',
          'price': 5.0,
          'notes': '2nd floor\n',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.fine('DEBUG: Successfully inserted Star Wars room');

        _logger.fine('DEBUG: Inserting Superheroes room...');
        await txn.insert('MuseumActivity', {
          'id': generateUlid(),
          'name': 'Superheroes',
          'type': 'room',
          'description':
              'Esposizione dedicata ai supereroi del fumetto e del cinema',
          'start_date': '2024-01-01T09:00:00',
          'end_date': '2024-12-31T20:00:00',
          'location': 'MUFANT Museum - Hero Gallery',
          'image_path': 'assets/images/superhero.jpg',
          'price': 8.0,
          'notes': '1st floor\n',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.fine('DEBUG: Successfully inserted Superheroes room');

        _logger.fine(
          'DEBUG: All MuseumActivity insertions completed successfully',
        );
      } catch (e) {
        _logger.fine('DEBUG: Error during transaction: $e');
        rethrow;
      }
    });

    // Verify data was inserted
    final finalCount = await db.query('MuseumActivity');
    _logger.fine(
      'DEBUG: Sample data insertion completed. Total MuseumActivity records: ${finalCount.length}',
    );
  }

  // Helper method to reset the database
  static Future<void> resetDatabase() async {
    final db = await database;
    await _dropTables(db);
    await _createTables(db);
  }
}
