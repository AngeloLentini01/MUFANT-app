import 'package:app/view/app_bar_widget.dart';
import 'package:app/view/home_page_bottom_nav_bar.dart';
import 'package:app/view/rooms_widget.dart';
import 'package:app/view/upcoming_events_widget.dart';
import 'package:app/view/visitors_guide_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart'; // Add this import

final _logger = Logger('MufantApp'); // Define a logger
const pinkColor = Color(0xFFFF8EB4);
const blackColor = Color(0xFF2D2D35);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Set system UI overlay style to ensure status bar matches app theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: blackColor,
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
        scaffoldBackgroundColor: blackColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: blackColor,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: blackColor,
          secondary: pinkColor,
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
    return Scaffold(
      appBar: AppBarWidget(
        textColor: pinkColor,
        backgroundColor: blackColor,
        logger: _logger,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  'HELLO THERE, ',
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
              ],
            ), // Wrap to ensure both texts are on the same line
            const SizedBox(height: 24),
            const Text(
              'Discover our rooms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Use constraints to ensure proper width
            Container(
              constraints: const BoxConstraints(
                maxWidth: double.infinity, // Allow full width
              ),
              child: const RoomsWidget(),
            ),
            const SizedBox(height: 24),
            const VisitorsGuideWidget(textColor: Color(0xFFFF8EB4)),
            const SizedBox(height: 24),
            const UpcomingEventsWidget(textColor: Color(0xFFFF8EB4)),
          ],
        ),
      ),
      bottomNavigationBar: HomePageBottomNavBar(backgroundColor: blackColor),
    );
  }
}
