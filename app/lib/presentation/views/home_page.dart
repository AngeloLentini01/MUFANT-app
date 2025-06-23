import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:app/presentation/widgets/bars/app_bar_widget.dart';
import 'package:app/presentation/widgets/bars/home_page_bottom_nav_bar.dart';
import 'package:app/presentation/widgets/scrollViews/rooms_widget.dart';
import 'package:app/presentation/widgets/scrollViews/upcoming_events_widget.dart';
import 'package:app/presentation/widgets/others/visitors_guide_widget.dart';

final _logger = Logger('MufantApp'); // Define a logger
const pinkColor = Color(0xFFFF8EB4);
const blackColor = Color(0xFF2D2D35);
const kWhiteSpace = SizedBox(height: 24);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Set isLoading to false after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const kBodyPadding = EdgeInsets.all(16.0);
    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        duration: Duration(seconds: 2),
      ), // Wrap the home page with Skeletonizer
      child: Scaffold(
        appBar: AppBarWidget(
          textColor: pinkColor,
          backgroundColor: blackColor,
          logger: _logger,
        ),
        body: SingleChildScrollView(
          padding: kBodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    'HELLO THERE,\nUSER!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: pinkColor,
                    ),
                  ),
                ],
              ), // Wrap to ensure both texts are on the same line
              // Add some space between the greeting and the next section
              kWhiteSpace,
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
              kWhiteSpace,
              const UpcomingEventsWidget(textColor: pinkColor),
              kWhiteSpace,
              const VisitorsGuideWidget(textColor: pinkColor),
            ],
          ),
        ),
        bottomNavigationBar: HomePageBottomNavBar(backgroundColor: blackColor),
      ),
    );
  }
}
