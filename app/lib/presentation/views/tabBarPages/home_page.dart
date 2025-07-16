import 'package:app/presentation/styles/spacing/generic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/presentation/widgets/animated_fade_in_column.dart';

import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/all.dart';

import 'package:app/presentation/widgets/all.dart';
import 'package:app/presentation/views/tabBarPages/map_page.dart';
import 'package:app/presentation/views/events/event_page.dart';
import 'package:app/presentation/views/events/room_details_page.dart';
import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:app/main.dart' as main_app;

import 'package:app/utils/app_text_indexer.dart';
import 'package:app/utils/app_text_search.dart';

final homepageGreeting = 'Hello there'; // Replace with actual greeting logic

final _logger = Logger('MufantApp');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _showContent = false;
  String _username = 'User'; // Default fallback username
  List<DetailsModel> _events = [];
  List<DetailsModel> _rooms = [];

  Future<void> _onSearchPressed() async {
    final TextEditingController controller = TextEditingController();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        List<Map<String, dynamic>> results = [];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                'Search the app',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter search term',
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.trim().isEmpty) {
                          results = [];
                        } else {
                          final searchResults = AppTextSearch.search(
                            value.trim(),
                            limit: 10,
                            threshold: 40,
                          );
                          final inputLower = value.trim().toLowerCase();
                          final startsWithInput = <Map<String, dynamic>>[];
                          final containsInput = <Map<String, dynamic>>[];
                          for (final item in searchResults) {
                            final text = (item['text'] ?? '')
                                .toString()
                                .toLowerCase();
                            if (text.startsWith(inputLower)) {
                              startsWithInput.add(item);
                            } else {
                              containsInput.add(item);
                            }
                          }
                          startsWithInput.sort(
                            (a, b) => (a['text'] ?? '')
                                .toString()
                                .toLowerCase()
                                .compareTo(
                                  (b['text'] ?? '').toString().toLowerCase(),
                                ),
                          );
                          containsInput.sort(
                            (a, b) => (a['text'] ?? '')
                                .toString()
                                .toLowerCase()
                                .compareTo(
                                  (b['text'] ?? '').toString().toLowerCase(),
                                ),
                          );
                          results = [...startsWithInput, ...containsInput];
                        }
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  if (results.isEmpty && controller.text.isNotEmpty)
                    Text(
                      'No results found.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  if (results.isNotEmpty)
                    Flexible(
                      child: SizedBox(
                        width: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: results.length,
                          itemBuilder: (context, idx) {
                            final item = results[idx];
                            return ListTile(
                              title: Text(
                                item['text'],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Score: �${item['score']}',
                                style: TextStyle(color: Colors.white54),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white38,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                // Optionally, do something with the result (e.g., navigate)
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ...existing code...

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
    // No need to pre-initialize the text indexer; we only index app data after loading
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
    if (mounted) {
      setState(() {
        _showContent = true;
      });
    }
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
          if (mounted) {
            setState(() {
              _username = displayName;
            });
            _logger.info('Updated UI with username: $_username');
          }
        }
      }
    } catch (e) {
      // Handle error - could show a snackbar or log the error
      _logger.severe('Error loading user session: $e');
    }
  }

  Future<void> _loadActivitiesData() async {
    try {
      _logger.fine('Waiting for database initialization...');
      bool dbReady = await main_app.waitForDatabaseInitialization();
      if (!dbReady) {
        _logger.severe('Database initialization failed');
        return;
      }
      _logger.finer('Database is ready, loading activities...');
      await DBMuseumActivityManager.debugListAllActivities();
      final events = await DBMuseumActivityManager.getEventsAsDetailsModels();
      final rooms = await DBMuseumActivityManager.getRoomsAsDetailsModels();
      _logger.finest(
        'Loaded ${events.length} events and ${rooms.length} rooms',
      );
      // Index event and room names/descriptions for search (clear first)
      final indexer = AppTextIndexer();
      indexer.clear();
      for (final event in events) {
        _logger.finer('Event: ${event.name}');
        indexer.addText(event.name, source: 'event');
        if (event.description != null) {
          indexer.addText(event.description!, source: 'event');
        }
      }
      for (final room in rooms) {
        _logger.finer('Room: ${room.name}');
        indexer.addText(room.name, source: 'room');
        if (room.description != null) {
          indexer.addText(room.description!, source: 'room');
        }
      }
      if (mounted) {
        setState(() {
          _events = events;
          _rooms = rooms;
        });
      }
    } catch (e) {
      _logger.severe('Error loading activities from database: $e');
    }
  }

  // Removed _mockDataLoadingUISkeletonEffect (no longer needed)

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
        padding: const EdgeInsets.only(bottom: 16.0, right: 4.0),
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
      body: SafeArea(
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
                onButtonPressed: _onSearchPressed,
                showLogo: true, // Show logo on homepage
              ),
              SliverPadding(
                padding: kBodyPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _showContent
                        ? AnimatedFadeInColumn(
                            children: [
                              CustomListWidget(
                                title: "Our Events",
                                textColor: kPinkColor,
                                onItemTap: _navigateToEventDetails,
                                activities: _events.isNotEmpty
                                    ? _events
                                    : [
                                        DetailsModel(
                                          name: 'Loading Events...',
                                          description:
                                              'Please wait while we load events',
                                          imageUrlOrPath:
                                              'assets/images/logo.png',
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
                                        DetailsModel(
                                          name: 'Loading Rooms...',
                                          description:
                                              'Please wait while we load rooms',
                                          imageUrlOrPath:
                                              'assets/images/logo.png',
                                        ),
                                      ],
                              ),
                              kSpaceBetweenSections,
                              CommunityChatSectionWidget(),
                              kSpaceBetweenSections,
                              const VisitorsGuideWidget(textColor: kPinkColor),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kPinkColor,
                              ),
                            ),
                          ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
