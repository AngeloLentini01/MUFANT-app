import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart'; // Add this import

final _logger = Logger('MufantApp'); // Define a logger

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print - Only used during development
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Set system UI overlay style to ensure status bar matches app theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2D2D35),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUFANT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.exoTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF2D2D35),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D2D35),
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2D2D35),
          secondary: const Color(0xFFFF8EB4),
        ),
      ),
      home: const MufantHomePage(),
    );
  }
}

class MufantHomePage extends StatelessWidget {
  const MufantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFFF8EB4);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D35),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Replace print with logger
              _logger.warning('Error loading logo: $error');
              return Text(
                'MUFANT',
                style: TextStyle(
                  color: pinkColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HELLO THERE,',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: pinkColor,
              ),
            ),
            Text(
              'USER!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: pinkColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Discover our rooms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  _buildRoomCard('Star Wars', 'assets/images/starwars.jpg'),
                  const SizedBox(width: 12),
                  _buildRoomCard('Library', 'assets/images/library.jpg'),
                  const SizedBox(width: 12),
                  _buildRoomCard('Superhero', 'assets/images/superhero.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildVisitorsGuide(pinkColor),
            const SizedBox(height: 24),
            _buildUpcomingEvents(pinkColor),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRoomCard(String title, String imagePath) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorsGuide(Color pinkColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VISITOR\'S GUIDE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: pinkColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.access_time, color: pinkColor),
            const SizedBox(width: 8),
            Text(
              'Opening hours',
              style: TextStyle(
                color: pinkColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Mon - Wed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text('Closed', style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Thu - Sun',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text('15.30 - 19.00', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.location_on, color: pinkColor),
            const SizedBox(width: 8),
            Text(
              'How to reach us',
              style: TextStyle(
                color: pinkColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Text(
            'P.za Riccardo Valla, 5, 10148 Torino TO',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(Color pinkColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UPCOMING EVENTS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: pinkColor,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildEventCard('assets/images/locandine/sailor-moon.jpg'),
              const SizedBox(width: 12),
              _buildEventCard('assets/images/locandine/locandina1.png'),
              const SizedBox(width: 12),
              _buildEventCard(
                'assets/images/locandine/profezie-artificiali.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(String imagePath) {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF2D2D35),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
