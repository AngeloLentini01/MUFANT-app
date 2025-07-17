import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async'; // Added for Timer

class EventPage extends StatefulWidget {
  final String? eventTitle;
  final String? highlightText;
  const EventPage({super.key, this.eventTitle, this.highlightText});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with TickerProviderStateMixin {
  Map<String, dynamic>? eventData;
  bool isLoading = true;
  final Logger _logger = AppLogger.getLogger('EventPage');
  AnimationController? _highlightController;
  Animation<double>? _highlightAnimation;

  @override
  void initState() {
    super.initState();
    _loadEventData();
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

  Future<void> _loadEventData() async {
    try {
      AppLogger.info(
        _logger,
        'EventPage: Loading data for event title: "${widget.eventTitle}"',
      );

      Map<String, dynamic>? data;
      if (widget.eventTitle != null) {
        AppLogger.info(
          _logger,
          'EventPage: Searching for specific event: "${widget.eventTitle}"',
        );
        data = await DBMuseumActivityManager.getActivityByTitle(
          widget.eventTitle!,
        );
      } else {
        AppLogger.info(_logger, 'EventPage: Loading default Sailor Moon event');
        // Load default Sailor Moon event
        data = await DBMuseumActivityManager.getActivityByTitle(
          '30 ANNI DI SAILOR',
        );
      }

      if (data != null) {
        AppLogger.info(
          _logger,
          'EventPage: Successfully loaded event data: "${data['name']}"',
        );
      } else {
        AppLogger.warning(
          _logger,
          'EventPage: No event data found for title: "${widget.eventTitle}"',
        );
      }

      setState(() {
        eventData = data;
        isLoading = false;
      });
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error loading event data',
        e,
        StackTrace.current,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildHighlightedText(String text) {
    if (widget.highlightText == null || widget.highlightText!.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFF7CA3),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.5,
        ),
      );
    }

    final highlightText = widget.highlightText!.toLowerCase();
    final textLower = text.toLowerCase();
    final index = textLower.indexOf(highlightText);

    if (index == -1) {
      return Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFF7CA3),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.5,
        ),
      );
    }

    // If no animation controller, return normal text
    if (_highlightAnimation == null) {
      return Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFF7CA3),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.5,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _highlightAnimation!,
      builder: (context, child) {
        final animationValue = _highlightAnimation!.value;

        // Create more prominent color transitions
        final highlightColor = Color.lerp(
          const Color(0xFFFF7CA3), // Normal color
          Colors.white, // Highlighted color
          animationValue,
        )!;

        // Make background more prominent
        final backgroundColor = animationValue > 0.1
            ? const Color(0xFFFF7CA3).withValues(alpha: animationValue * 0.9)
            : null;

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: text.substring(0, index),
                style: const TextStyle(
                  color: Color(0xFFFF7CA3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: text.substring(index, index + highlightText.length),
                style: TextStyle(
                  color: highlightColor,
                  backgroundColor: backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
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
                text: text.substring(index + highlightText.length),
                style: const TextStyle(
                  color: Color(0xFFFF7CA3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF2B2A33),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2B2A33).withValues(alpha: 0.95),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kWhiteColor,
              size: 24,
            ),
          ),
          centerTitle: true,
          title: Text(
            'loading'.tr(),
            style: TextStyle(
              color: Color(0xFFFF7CA3),
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF7CA3)),
        ),
      );
    }

    if (eventData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF2B2A33),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2B2A33).withValues(alpha: 0.95),
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kWhiteColor,
              size: 24,
            ),
          ),
          centerTitle: true,
          title: Text(
            'event_not_found'.tr(),
            style: TextStyle(
              color: Color(0xFFFF7CA3),
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'event_not_found_message'.tr(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2A33).withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor, size: 24),
        ),
        centerTitle: true,
        title: _buildHighlightedText(eventData!['name'] ?? 'Event'),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2B2A33), Color(0xFF3B3A47)],
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Event image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    eventData!['image_path'] ??
                        'assets/images/locandine/sailor-moon.jpg',
                    width: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                // const Text(
                //   '30 ANNI DI SAILOR',
                //   style: TextStyle(
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFFFF7CA3),
                //     letterSpacing: 1.5,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 18),
                // Location & time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        eventData!['location'] ?? 'Location TBD',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${eventData!['start_date'] ?? ''} – ${eventData!['end_date'] ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  eventData!['description'] ?? 'No description available',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                // Schedule box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFFF7CA3), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'schedule'.tr(),
                        style: TextStyle(
                          color: Color(0xFFFF7CA3),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        eventData!['notes'] ?? 'schedule_tbd'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Extra info
                Text(
                  eventData!['notes'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Tickets & Info
                Text(
                  'tickets_info'.tr(),
                  style: TextStyle(
                    color: Color(0xFFFF7CA3),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  eventData!['price'] != null
                      ? 'mufant_ticket_info'.tr(
                          namedArgs: {'price': eventData!['price'].toString()},
                        )
                      : '',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'contact_info'.tr(),
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
