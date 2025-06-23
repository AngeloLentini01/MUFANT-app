import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/colors/skeleton.dart';
import 'package:app/presentation/styles/spacing.dart';
import 'package:app/presentation/styles/animation_durations.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:app/presentation/widgets/bars/app_bar_widget.dart';
import 'package:app/presentation/widgets/bars/home_page_bottom_nav_bar.dart';
import 'package:app/presentation/widgets/scrollViews/rooms_widget.dart';
import 'package:app/presentation/widgets/scrollViews/upcoming_events_widget.dart';
import 'package:app/presentation/widgets/others/visitors_guide_widget.dart';

final homepageGreeting = 'HELLO THERE';
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
  final _username = 'USER'; // Replace with actual username logic

  String get homePageMessage => '$homepageGreeting,\n$_username!';

  @override
  void initState() {
    super.initState();

    // Set isLoading to false after 6 seconds
    _mockDataLoadingUISkeletonEffect();
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

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isSkeletonLoading,
      effect: ShimmerEffect(
        baseColor: kSkeletonBaseColor,
        highlightColor: kSkeletonHighlightColor,
        duration: Duration(seconds: kSkeletonLoadingWaveSeconds),
      ), // Wrap the home page with Skeletonizer
      child: Scaffold(
        appBar: AppBarWidget(
          textColor: kPinkColor,
          backgroundColor: kBlackColor,
          logger: _logger,
        ),
        body: SingleChildScrollView(
          padding: kBodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homePageMessage,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPinkColor,
                ),
              ),
              // Add some space between the greeting and the next section
              kBlankSpaceWidget,
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
                  maxWidth: kFullWidth, // Allow full width
                ),
                child: const RoomsWidget(),
              ),
              kBlankSpaceWidget,
              const UpcomingEventsWidget(textColor: kPinkColor),
              kBlankSpaceWidget,
              const VisitorsGuideWidget(textColor: kPinkColor),
            ],
          ),
        ),
        bottomNavigationBar: HomePageBottomNavBar(backgroundColor: kBlackColor),
      ),
    );
  }
}
