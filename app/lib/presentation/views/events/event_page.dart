import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';

class EventPage extends StatefulWidget {
  final String? eventTitle;
  const EventPage({super.key, this.eventTitle});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Map<String, dynamic>? eventData;
  bool isLoading = true;
  final Logger _logger = AppLogger.getLogger('EventPage');

  @override
  void initState() {
    super.initState();
    _loadEventData();
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
          title: const Text(
            'Loading...',
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
          title: const Text(
            'Event Not Found',
            style: TextStyle(
              color: Color(0xFFFF7CA3),
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: const Center(
          child: Text('Event not found', style: TextStyle(color: Colors.white)),
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
        title: Text(
          eventData!['name'] ?? 'Event',
          style: const TextStyle(
            color: Color(0xFFFF7CA3),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
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
                      const Text(
                        'SCHEDULE',
                        style: TextStyle(
                          color: Color(0xFFFF7CA3),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        eventData!['notes'] ?? 'Schedule TBD',
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
                const Text(
                  'TICKETS & INFO',
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
                      ? 'MUFANT ticket\nStudents: €${eventData!['price']} (with ID)\nMuseum Pass not valid'
                      : '',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Info: +39 347 5405096\n+39 349 8171960\ninfo@mufant.it',
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
