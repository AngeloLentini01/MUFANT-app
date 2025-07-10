import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String databaseName = 'mufant_museum.db';
  static const int databaseVersion = 1;

  // Get the database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
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
    // Create BaseEntity table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BaseEntity (
        id TEXT PRIMARY KEY,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        last_update_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

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

    // Create MuseumActivity table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MuseumActivity (
        id TEXT PRIMARY KEY,
        museum_activity_details_fk TEXT NOT NULL,
        FOREIGN KEY (museum_activity_details_fk) REFERENCES MuseumActivityDetails(id),
        FOREIGN KEY (id) REFERENCES BaseEntity(id)
      )
    ''');

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
  }

  // Drop tables if they exist
  static Future<void> _dropTables(Database db) async {
    // Drop tables in reverse order to avoid foreign key constraints
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

    // Check if sample data already exists
    final languages = await db.query('SupportedLanguage');
    if (languages.isNotEmpty) {
      // Sample data already exists, don't insert again
      return;
    }

    // Start a transaction
    await db.transaction((txn) async {
      // Add sample data as needed
      // For example, add supported languages
      await txn.insert('SupportedLanguage', {
        'id': 'lang_en_001',
        'name': 'English',
      });

      await txn.insert('SupportedLanguage', {
        'id': 'lang_it_001',
        'name': 'Italian',
      });

      // Add phone country codes
      await txn.insert('PhoneCountryCode', {
        'id': 'pcc_it_001',
        'country_code': '+39',
      });

      await txn.insert('PhoneCountryCode', {
        'id': 'pcc_us_001',
        'country_code': '+1',
      });
    });
  }

  // Helper method to reset the database
  static Future<void> resetDatabase() async {
    final db = await database;
    await _dropTables(db);
    await _createTables(db);
  }
}
