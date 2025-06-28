import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/colors/skeleton.dart';
import 'package:app/presentation/styles/spacing.dart';
import 'package:app/presentation/styles/animation_durations.dart';
import 'package:app/presentation/widgets/others/community_chat_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:app/presentation/widgets/bars/app_bar_widget.dart';
import 'package:app/presentation/widgets/bars/home_page_bottom_nav_bar.dart';

import 'package:app/presentation/widgets/scrollViews/custom_list_widget.dart';
import 'package:app/presentation/widgets/others/visitors_guide_widget.dart';

final homepageGreeting = 'HELLO THERE'; // Replace with actual greeting logic
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

  String get homePageMessage => '$homepageGreeting, $_username!';

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
        backgroundColor:
            kBlackColor, // Set scaffold background to match app bar
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
                  textColor: kPinkColor,
                  backgroundColor: kBlackColor, // Use solid black background
                  logger: _logger,
                ),
                SliverPadding(
                  padding: kBodyPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Removed homePageMessage text since it's now in the app bar
                      CustomListWidget(
                        title: "Upcoming Events",
                        textColor: kPinkColor,
                        activities: [
                          DetailsModel(
                            name: 'Sailor Moon\'s Anniversary',
                            description:
                                'Un evento speciale per celebrare i 30 anni di Sailor Moon.',
                            notes:
                                '01-28 nov•MUFANT Museum\nFree entry',
                            imageUrlOrPath:
                                'assets/images/locandine/sailor-moon.jpg',
                          ),
                          DetailsModel(
                            name: 'Ufo Pop',
                            description:
                                'Un evento dedicato alla cultura pop degli UFO e degli alieni.',
                            notes: '01-28 nov•MUFANT Museum\nStarting from 5€',
                            imageUrlOrPath:
                                'assets/images/locandine/ufo-pop.png',
                          ),
                          DetailsModel(
                            name: 'Artificial Prophecies',
                            description:
                                'Un evento che esplora le profezie legate all\'intelligenza artificiale.',
                           notes: '01-28 nov•MUFANT Museum\nComing soon',
                            imageUrlOrPath:
                                'assets/images/locandine/profezie-artificiali.jpg',
                          ),
                        ],
                      ),
                      kBlankSpaceWidget,
                      CustomListWidget(
                        title: "Discover Our Rooms",
                        textColor: kPinkColor,
                        activities: [
                          DetailsModel(
                            name: 'Star Wars',
                            description: 'Enter the Star Wars universe',
                            imageUrlOrPath: 'assets/images/starwars.jpg',
                          ),
                          DetailsModel(
                            name: 'Riccardo Valla\'s Library',
                            description: 'Quiet reading space',
                            imageUrlOrPath: 'assets/images/library.jpg',
                          ),
                          DetailsModel(
                            name: 'Superheroes',
                            description: 'Superhero themed room',
                            imageUrlOrPath: 'assets/images/superhero.jpg',
                          ),
                        ],
                      ), // Replace with actual data
                      kBlankSpaceWidget,
                      // Community Chat Section
                      CommunityChatSectionWidget(),
                      kBlankSpaceWidget,
                      const VisitorsGuideWidget(textColor: kPinkColor),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: HomePageBottomNavBar(backgroundColor: kBlackColor),
      ),
    );
  }
}
