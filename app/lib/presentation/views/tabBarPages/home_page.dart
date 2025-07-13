import 'package:app/presentation/styles/spacing/generic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/all.dart';

import 'package:app/presentation/widgets/all.dart';
import 'package:app/presentation/views/tabBarPages/map_page.dart';
import 'package:app/presentation/views/events/event_page.dart';
import 'package:app/presentation/views/events/room_details_page.dart';
import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/main.dart' as main_app;

final homepageGreeting = 'Hello there'; // Replace with actual greeting logic
// Replace with actual username logic

final _logger = Logger('MufantApp');

// TODO: Implement logic to retrieve the actual username from user profile or authentication state.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSkeletonLoading = true;
  final _username = 'User'; // Replace with actual username logic
  List<DetailsModel> _events = [];
  List<DetailsModel> _rooms = [];

  String get homePageMessage => '$homepageGreeting, $_username!';

  @override
  void initState() {
    super.initState();

    // Load data from database
    _loadActivitiesData();

    // Set isLoading to false after 6 seconds
    _mockDataLoadingUISkeletonEffect();
  }

  Future<void> _loadActivitiesData() async {
    try {
      print('Waiting for database initialization...');

      // Wait for database to be fully initialized
      bool dbReady = await main_app.waitForDatabaseInitialization();

      if (!dbReady) {
        print('Database initialization failed');
        return;
      }

      print('Database is ready, loading activities...');

      // Debug: List all available activities
      await DBMuseumActivityManager.debugListAllActivities();

      final events = await DBMuseumActivityManager.getEventsAsDetailsModels();
      final rooms = await DBMuseumActivityManager.getRoomsAsDetailsModels();

      print('Loaded ${events.length} events and ${rooms.length} rooms');
      for (final event in events) {
        print('Event: ${event.name}');
      }
      for (final room in rooms) {
        print('Room: ${room.name}');
      }

      if (mounted) {
        setState(() {
          _events = events;
          _rooms = rooms;
        });
      }
    } catch (e) {
      // Handle error - could show a snackbar or log the error
      print('Error loading activities from database: $e');
    }
  }

  void _mockDataLoadingUISkeletonEffect() {
    Future.delayed(
      const Duration(seconds: kSkeletonLoadingDurationSeconds),
      () {
        if (mounted) {
          setState(() {
            isSkeletonLoading = false;
          });
        }
      },
    );
  }

  void _navigateToEventDetails(DetailsModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(eventTitle: event.name),
      ),
    );
  }

  void _navigateToRoomDetails(DetailsModel room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailsPage(title: room.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          right: 4.0,
        ), // Più sollevato
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()),
            );
          },
          backgroundColor: kPinkColor,
          child: const Icon(Icons.map_outlined, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Skeletonizer(
        enabled: isSkeletonLoading,
        effect: ShimmerEffect(
          baseColor: kSkeletonBaseColor,
          highlightColor: kSkeletonHighlightColor,
          duration: Duration(seconds: kSkeletonLoadingWaveSeconds),
        ), // Wrap the home page with Skeletonizer
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kBlackColor, Colors.grey[900]!],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                AppBarWidget(
                  textColor: kWhiteColor,
                  backgroundColor: kBlackColor,
                  logger: _logger,
                  iconImage: Icons.search,
                  text: homePageMessage,
                  onButtonPressed: () {
                    /*todo: implement search functionality*/
                  },
                  showLogo: true, // Show logo on homepage
                ),
                SliverPadding(
                  padding: kBodyPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Removed homePageMessage text since it's now in the app bar
                      CustomListWidget(
                        title: "Our Events",
                        textColor: kPinkColor,
                        onItemTap: _navigateToEventDetails,
                        activities: _events.isNotEmpty
                            ? _events
                            : [
                                // Fallback data if no events are loaded
                                DetailsModel(
                                  name: 'Loading Events...',
                                  description:
                                      'Please wait while we load events',
                                  imageUrlOrPath: 'assets/images/logo.png',
                                ),
                              ],
                      ),
                      kSpaceBetweenSections,
                      CustomListWidget(
                        title: "Discover the Rooms",
                        textColor: kPinkColor,
                        onItemTap: _navigateToRoomDetails,
                        activities: _rooms.isNotEmpty
                            ? _rooms
                            : [
                                // Fallback data if no rooms are loaded
                                DetailsModel(
                                  name: 'Loading Rooms...',
                                  description:
                                      'Please wait while we load rooms',
                                  imageUrlOrPath: 'assets/images/logo.png',
                                ),
                              ],
                      ), // Replace with actual data
                      kSpaceBetweenSections,
                      // Community Chat Section
                      CommunityChatSectionWidget(),
                      kSpaceBetweenSections,
                      const VisitorsGuideWidget(textColor: kPinkColor),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
