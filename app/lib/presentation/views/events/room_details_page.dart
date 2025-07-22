import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async'; // Added for Timer

class RoomDetailsPage extends StatefulWidget {
  final String title;
  final String? highlightText;
  const RoomDetailsPage({super.key, required this.title, this.highlightText});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage>
    with TickerProviderStateMixin {
  static const lightBlack = Color(
    0x80000000,
  ); // Increased opacity for better text readability
  final Logger _logger = AppLogger.getLogger('RoomDetailsPage');

  Map<String, dynamic>? roomData;
  bool isLoading = true;
  AnimationController? _highlightController;
  Animation<double>? _highlightAnimation;

  @override
  void initState() {
    super.initState();
    _loadRoomData();
    _setupHighlightAnimation();
  }

  void _setupHighlightAnimation() {
    if (widget.highlightText != null && widget.highlightText!.isNotEmpty) {
      _highlightController = AnimationController(
        duration: const Duration(milliseconds: 1000), // 1 second per cycle
        vsync: this,
      );

      _highlightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _highlightController!, curve: Curves.easeInOut),
      );

      // Start the animation and repeat it for 2 seconds
      _highlightController!.repeat(reverse: true);

      // Stop after 2 seconds
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _highlightController!.stop();
        }
      });
    }
  }

  @override
  void dispose() {
    _highlightController?.dispose();
    super.dispose();
  }

  Future<void> _loadRoomData() async {
    try {
      AppLogger.info(
        _logger,
        'RoomDetailsPage: Loading data for room title: "${widget.title}"',
      );

      final data = await DBMuseumActivityManager.getActivityByTitle(
        widget.title,
      );

      if (data != null) {
        AppLogger.info(
          _logger,
          'RoomDetailsPage: Successfully loaded room data: "${data['name']}"',
        );
      } else {
        AppLogger.warning(
          _logger,
          'RoomDetailsPage: No room data found for title: "${widget.title}"',
        );
      }

      setState(() {
        roomData = data;
        isLoading = false;
      });
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error loading room data',
        e,
        StackTrace.current,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper methods for room-specific content
  String _getMapImagePath() {
    final roomName = roomData?['name']?.toLowerCase() ?? '';
    if (roomName.contains('star wars')) {
      return "assets/images/map/museum_map2.jpg";
    } else if (roomName.contains('library')) {
      return "assets/images/map/museum_map1.jpg";
    } else if (roomName.contains('superhero')) {
      return "assets/images/map/museum_map2.jpg";
    }
    return "assets/images/library.jpg"; // Default fallback
  }

  String _getWelcomeMessage() {
    final roomName = roomData?['name']?.toLowerCase() ?? '';
    if (roomName.contains('star wars')) {
      return "welcome_star_wars".tr();
    } else if (roomName.contains('library')) {
      return "welcome_library".tr();
    } else if (roomName.contains('superhero')) {
      return "welcome_superhero".tr();
    }
    final name = roomData?['name'];
    if (name != null) {
      return "welcome_room".tr(namedArgs: {'room': name});
    }
    return "welcome_room_default".tr();
  }

  String _getDetailedDescription() {
    final roomName = roomData?['name']?.toLowerCase() ?? '';
    if (roomName.contains('star wars')) {
      return "room_star_wars_desc".tr();
    } else if (roomName.contains('library')) {
      return "room_library_desc".tr();
    } else if (roomName.contains('superhero')) {
      return "room_superheroes_desc".tr();
    }
    return roomData?['description'] ??
        'Explore this fascinating exhibition and discover its unique treasures and stories.';
  }

  String _getBackgroundImagePath() {
    final roomName = roomData?['name']?.toLowerCase() ?? '';
    if (roomName.contains('star wars')) {
      return "assets/images/starwars.jpg";
    } else if (roomName.contains('library')) {
      return "assets/images/library.jpg";
    } else if (roomName.contains('superhero')) {
      return "assets/images/superhero.jpg";
    }
    return roomData?['image_path'] ??
        "assets/images/library.jpg"; // Default fallback
  }

  Widget _buildHighlightedText(String text) {
    // Provo a mappare il nome stanza a una chiave localizzata
    final lower = text.toLowerCase();
    String localized;
    if (lower.contains('superhero')) {
      localized = 'room_superheroes'.tr();
    } else if (lower.contains('library')) {
      localized = 'room_library'.tr();
    } else if (lower.contains('star wars')) {
      localized = 'room_star_wars'.tr();
    } else {
      localized = text.tr();
    }
    if (widget.highlightText == null || widget.highlightText!.isEmpty) {
      return Text(
        localized.toUpperCase(),
        style: TextStyle(
          color: kPinkColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      );
    }

    final highlightText = widget.highlightText!.toLowerCase();
    final textLower = localized.toLowerCase();
    final index = textLower.indexOf(highlightText);

    if (index == -1) {
      return Text(
        localized.toUpperCase(),
        style: TextStyle(
          color: kPinkColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      );
    }

    // If no animation controller, return normal text
    if (_highlightAnimation == null) {
      return Text(
        localized.toUpperCase(),
        style: TextStyle(
          color: kPinkColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _highlightAnimation!,
      builder: (context, child) {
        final animationValue = _highlightAnimation!.value;

        // Create more prominent color transitions
        final highlightColor = Color.lerp(
          kPinkColor, // Normal color
          Colors.white, // Highlighted color
          animationValue,
        )!;

        // Make background more prominent
        final backgroundColor = animationValue > 0.1
            ? kPinkColor.withValues(alpha: animationValue * 0.9)
            : null;

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: localized.substring(0, index).toUpperCase(),
                style: TextStyle(
                  color: kPinkColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              TextSpan(
                text: localized
                    .substring(index, index + highlightText.length)
                    .toUpperCase(),
                style: TextStyle(
                  color: highlightColor,
                  backgroundColor: backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  // Add shadow for better visibility
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black.withValues(
                        alpha: animationValue * 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: localized
                    .substring(index + highlightText.length)
                    .toUpperCase(),
                style: TextStyle(
                  color: kPinkColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (isLoading) {
        return Scaffold(
          backgroundColor: Color(0xFF1a1a2e),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhiteColor,
                size: 24,
              ),
            ),
            title: Text(
              widget.title.toUpperCase(),
              style: TextStyle(
                color: kPinkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            centerTitle: true,
          ),
          body: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      if (roomData == null) {
        return Scaffold(
          backgroundColor: Color(0xFF1a1a2e),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhiteColor,
                size: 24,
              ),
            ),
            title: Text(
              widget.title.toUpperCase(),
              style: TextStyle(
                color: kPinkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Text(
              'room_not_found'.tr(),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kWhiteColor,
              size: 24,
            ),
          ),
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0x80000000), // Semi-transparent black background
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildHighlightedText(roomData!['name'] ?? widget.title),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Image.asset(
                    _getBackgroundImagePath(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFF1a1a2e), // Dark fallback color
                      );
                    },
                  ),
                ),
              ), //background image
              Positioned.fill(child: Container(color: lightBlack)),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Map/Floor plan image
                      Container(
                        height: 300,
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            _getMapImagePath(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Color(0xFF2a2a3e),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.map_outlined,
                                        size: 48,
                                        color: kPinkColor,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Room Map',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // "You are here" indicator (if needed)
                      /*                   Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: kPinkColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "you_are_here".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
*/
                      kSpaceBetweenSections,

                      // Audio guide button
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement audio guide functionality
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: kPinkColor, width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  color: kPinkColor,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "listen_audioguide".tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      kSpaceBetweenSections,

                      // Welcome message and description
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _getWelcomeMessage(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(
                                  0x88000000,
                                ), // Semi-transparent black
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                _getDetailedDescription(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
      );
    } catch (e) {
      AppLogger.error(_logger, 'Error building room details page', e);
      // Return a safe fallback UI
      return Scaffold(
        backgroundColor: Color(0xFF1a1a2e),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kWhiteColor,
              size: 24,
            ),
          ),
          title: Text(
            "room_details".tr(),
            style: TextStyle(
              color: kPinkColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: kPinkColor),
              SizedBox(height: 16),
              Text(
                'Unable to load room details',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Please try again later',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
      );
    }
  }
}
