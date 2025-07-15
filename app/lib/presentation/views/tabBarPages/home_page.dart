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
import 'package:app/data/services/user_session_manager.dart';
import 'package:app/main.dart' as main_app;

final homepageGreeting = 'Hello there'; // Replace with actual greeting logic

final _logger = Logger('MufantApp');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isSkeletonLoading = true;
  String _username = 'User'; // Default fallback username
  List<DetailsModel> _events = [];
  List<DetailsModel> _rooms = [];

  String get homePageMessage => '$homepageGreeting, $_username!';

  // Public method to refresh user session
  void refreshUserSession() {
    _logger.info('Manually refreshing user session from external call');
    _loadUserSession();
  }

  @override
  void initState() {
    super.initState();

    // Add observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Load user session and activities data
    _initializeData();

    // Set isLoading to false after 6 seconds
    _mockDataLoadingUISkeletonEffect();
  }

  @override
  void dispose() {
    // Remove observer when disposing
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh user session when app resumes
    if (state == AppLifecycleState.resumed) {
      _logger.info('App resumed, refreshing user session');
      _loadUserSession();
    }
  }

  Future<void> _initializeData() async {
    // For testing purposes, you can uncomment this line to create a test user
    // await _createTestUserIfNeeded();

    await _loadUserSession();
    await _loadActivitiesData();
  }

  Future<void> _loadUserSession() async {
    try {
      _logger.info('Loading user session...');

      // First check if user is already logged in
      bool isLoggedIn = await UserSessionManager.isLoggedIn();
      _logger.info('Is user logged in: $isLoggedIn');

      if (isLoggedIn) {
        _logger.info('User is logged in, checking current user...');

        // Check if current user is already loaded
        if (UserSessionManager.currentUser != null) {
          _logger.info(
            'Current user already loaded: ${UserSessionManager.currentUser!.username}',
          );
        } else {
          _logger.info('Current user not loaded, loading session...');
          // Load user session from shared preferences
          bool sessionLoaded = await UserSessionManager.loadSession();
          _logger.info('Session loaded: $sessionLoaded');
        }

        if (UserSessionManager.currentUser != null) {
          final user = UserSessionManager.currentUser!;
          String displayName = 'User'; // Default fallback

          _logger.info(
            'User data: username=${user.username}, firstName=${user.firstName}, lastName=${user.lastName}',
          );

          // Prefer first name if available, otherwise use username
          if (user.firstName != null && user.firstName!.isNotEmpty) {
            displayName = user.firstName!;
            _logger.info('Using firstName: $displayName');
          } else if (user.username.isNotEmpty) {
            // If username is in format like "John_Doe", extract first part
            List<String> nameParts = user.username.split('_');
            if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
              displayName = nameParts[0];
              _logger.info('Using parsed username: $displayName');
            } else {
              displayName = user.username;
              _logger.info('Using full username: $displayName');
            }
          }

          _logger.info('Final display name: $displayName');

          if (mounted) {
            setState(() {
              _username = displayName;
            });
            _logger.info('Updated UI with username: $_username');
          }
        } else {
          _logger.warning('Current user is null after loading session');
        }
      } else {
        _logger.info('No user session found - user not logged in');
        // Set a more welcoming default message for visitors
        if (mounted) {
          setState(() {
            _username = 'Visitor';
          });
        }
      }
    } catch (e, stackTrace) {
      _logger.severe('Error loading user session: $e');
      _logger.severe('Stack trace: $stackTrace');
      // Keep default "User" username
    }
  }

  Future<void> _loadActivitiesData() async {
    try {
      _logger.fine('Waiting for database initialization...');

      // Wait for database to be fully initialized
      bool dbReady = await main_app.waitForDatabaseInitialization();

      if (!dbReady) {
        _logger.severe('Database initialization failed');
        return;
      }

      _logger.finer('Database is ready, loading activities...');

      // Debug: List all available activities
      await DBMuseumActivityManager.debugListAllActivities();

      final events = await DBMuseumActivityManager.getEventsAsDetailsModels();
      final rooms = await DBMuseumActivityManager.getRoomsAsDetailsModels();

      _logger.finest(
        'Loaded ${events.length} events and ${rooms.length} rooms',
      );
      for (final event in events) {
        _logger.finer('Event: ${event.name}');
      }
      for (final room in rooms) {
        _logger.finer('Room: ${room.name}');
      }

      if (mounted) {
        setState(() {
          _events = events;
          _rooms = rooms;
        });
      }
    } catch (e) {
      // Handle error - could show a snackbar or log the error
      _logger.severe('Error loading activities from database: $e');
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
                  forceHideBackButton:
                      true, // Never show back button on home page
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
