import 'package:app/presentation/styles/spacing/generic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/presentation/widgets/animated_fade_in_column.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/all.dart';

import 'package:app/presentation/widgets/all.dart';
import 'package:app/presentation/views/tabBarPages/map_page.dart';
import 'package:app/presentation/views/events/event_page.dart';
import 'package:app/presentation/views/events/room_details_page.dart';
import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/data/dbManagers/db_user_manager.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:app/main.dart' as main_app;

final homepageGreeting = 'greeting_hello'; // Replace with actual greeting logic

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
                'search_title'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  fontSize: 16,
                ),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilteredTextField(
                      controller: controller,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type here to search...',
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
                            // Simple search through available events and rooms
                            final searchTerm = value.trim().toLowerCase();
                            final allItems = <Map<String, dynamic>>[];

                            // Add events
                            for (final event in _events) {
                              allItems.add({
                                'text': event.name,
                                'type': 'Event',
                                'description': event.description,
                                'data': event,
                              });
                            }

                            // Add rooms
                            for (final room in _rooms) {
                              allItems.add({
                                'text': room.name,
                                'type': 'Room',
                                'description': room.description,
                                'data': room,
                              });
                            }

                            // Filter and sort results
                            final filteredResults = allItems.where((item) {
                              final text = item['text']
                                  .toString()
                                  .toLowerCase();
                              final description = item['description']
                                  .toString()
                                  .toLowerCase();
                              return text.contains(searchTerm) ||
                                  description.contains(searchTerm);
                            }).toList();

                            // Sort by relevance (exact matches first, then partial matches)
                            filteredResults.sort((a, b) {
                              final aText = a['text'].toString().toLowerCase();
                              final bText = b['text'].toString().toLowerCase();

                              final aExact = aText == searchTerm;
                              final bExact = bText == searchTerm;

                              if (aExact && !bExact) return -1;
                              if (!aExact && bExact) return 1;

                              final aStartsWith = aText.startsWith(searchTerm);
                              final bStartsWith = bText.startsWith(searchTerm);

                              if (aStartsWith && !bStartsWith) return -1;
                              if (!aStartsWith && bStartsWith) return 1;

                              return aText.compareTo(bText);
                            });

                            results = filteredResults.take(10).toList();
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
                                  item['type'],
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white38,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  // Find the best matching substring in the found text
                                  final foundText = item['text'].toString();
                                  final searchTerm = controller.text.trim();
                                  String highlightText = searchTerm;

                                  // Debug logging
                                  _logger.info(
                                    'DEBUG: Found text: "$foundText"',
                                  );
                                  _logger.info(
                                    'DEBUG: Search term: "$searchTerm"',
                                  );

                                  // Try to find the best matching substring (case-insensitive)
                                  final foundTextLower = foundText
                                      .toLowerCase();
                                  final searchTermLower = searchTerm
                                      .toLowerCase();

                                  if (foundTextLower.contains(
                                    searchTermLower,
                                  )) {
                                    // Use the search term as is
                                    highlightText = searchTerm;
                                    _logger.info(
                                      'DEBUG: Found exact match, highlighting: "$highlightText"',
                                    );
                                  } else {
                                    // Find the longest common substring
                                    final words = searchTermLower.split(' ');
                                    for (final word in words) {
                                      if (word.length > 2 &&
                                          foundTextLower.contains(word)) {
                                        // Find the original case version of the word
                                        final wordIndex = foundTextLower
                                            .indexOf(word);
                                        highlightText = foundText.substring(
                                          wordIndex,
                                          wordIndex + word.length,
                                        );
                                        _logger.info(
                                          'DEBUG: Found word match, highlighting: "$highlightText"',
                                        );
                                        break;
                                      }
                                    }
                                  }

                                  _logger.info(
                                    'DEBUG: Final highlight text: "$highlightText"',
                                  );

                                  // Navigate to the appropriate page with highlighting
                                  if (item['type'] == 'Event') {
                                    _navigateToEventWithHighlight(
                                      item['data'],
                                      highlightText,
                                    );
                                  } else if (item['type'] == 'Room') {
                                    _navigateToRoomWithHighlight(
                                      item['data'],
                                      highlightText,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
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

  String get homePageMessage =>
      'greeting_hello'.tr(namedArgs: {'name': _username});

  // Note: Database is read-only, so we can't update user details
  // The fallback logic in User.fromMap should handle the name extraction

  // Public method to refresh user session
  void refreshUserSession() {
    _logger.info('Manually refreshing user session from external call');
    _loadUserSession();
  }

  // Debug method to check current user state
  void debugUserState() {
    final user = UserSessionManager.currentUser;
    if (user != null) {
      _logger.info('DEBUG - Current user state:');
      _logger.info('  Username: ${user.username}');
      _logger.info('  First Name: ${user.firstName}');
      _logger.info('  Last Name: ${user.lastName}');
      _logger.info('  Email: ${user.email}');

      // Note: Database is read-only, so we can't update user details
      // The fallback logic in User.fromMap should handle the name extraction
      if (user.firstName == null || user.firstName!.isEmpty) {
        _logger.info(
          'No firstName found, but database is read-only - using fallback from username',
        );
      }
    } else {
      _logger.info('DEBUG - No current user found');
    }
  }

  @override
  void initState() {
    super.initState();

    // Add observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Load user session and activities data
    _initializeData();

    // Debug: Check user state after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugUserState();
      // Also inspect the database
      DBUserManager.debugInspectDatabase();
    });
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

        // Force reload session to ensure we get the latest data
        bool sessionLoaded = await UserSessionManager.loadSession();
        _logger.info('Session loaded: $sessionLoaded');

        // Check if current user is already loaded
        if (UserSessionManager.currentUser != null) {
          _logger.info(
            'Current user loaded: ${UserSessionManager.currentUser!.username}',
          );

          // Immediate debug of user data
          final user = UserSessionManager.currentUser!;
          _logger.info('IMMEDIATE DEBUG - User data:');
          _logger.info('  Username: ${user.username}');
          _logger.info('  First Name: ${user.firstName}');
          _logger.info('  Last Name: ${user.lastName}');
          _logger.info('  Email: ${user.email}');
        } else {
          _logger.info('Current user not loaded after session load');
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
              // Properly capitalize the first name
              if (displayName.isNotEmpty) {
                displayName =
                    displayName[0].toUpperCase() +
                    displayName.substring(1).toLowerCase();
              }
              _logger.info('Using parsed username: $displayName');
            } else {
              displayName = user.username;
              // Properly capitalize the username if no underscore found
              if (displayName.isNotEmpty) {
                displayName =
                    displayName[0].toUpperCase() +
                    displayName.substring(1).toLowerCase();
              }
              _logger.info('Using full username: $displayName');
            }
          }

          // Debug: Log all user information
          _logger.info(
            'DEBUG - User info: username=${user.username}, firstName=${user.firstName}, lastName=${user.lastName}',
          );
          _logger.info('DEBUG - Final displayName: $displayName');

          // Note: Database is read-only, so we can't update user details
          // The fallback logic in User.fromMap should handle the name extraction
          if ((user.firstName == null || user.firstName!.isEmpty) &&
              user.username.isNotEmpty) {
            _logger.info(
              'No firstName found, but database is read-only - using fallback from username',
            );
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
      // Log events and rooms for debugging
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

  void _navigateToEventWithHighlight(DetailsModel event, String searchTerm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EventPage(eventTitle: event.name, highlightText: searchTerm),
      ),
    );
  }

  void _navigateToRoomWithHighlight(DetailsModel room, String searchTerm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RoomDetailsPage(title: room.name, highlightText: searchTerm),
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
                                title: "our_events".tr(),
                                textColor: kPinkColor,
                                onItemTap: _navigateToEventDetails,
                                activities: _events.isNotEmpty
                                    ? _events
                                    : [
                                        DetailsModel(
                                          name: "loading_events".tr(),
                                          description:
                                              "loading_events_description".tr(),
                                          imageUrlOrPath:
                                              'assets/images/logo.png',
                                        ),
                                      ],
                              ),
                              kSpaceBetweenSections,
                              CustomListWidget(
                                title: "discover_rooms".tr(),
                                textColor: kPinkColor,
                                onItemTap: _navigateToRoomDetails,
                                activities: _rooms.isNotEmpty
                                    ? _rooms
                                    : [
                                        DetailsModel(
                                          name: "loading_rooms".tr(),
                                          description:
                                              "loading_rooms_description".tr(),
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
