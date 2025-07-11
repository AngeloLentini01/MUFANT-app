import 'package:app/presentation/styles/spacing/generic.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/all.dart';

import 'package:app/presentation/widgets/all.dart';
import 'package:app/presentation/views/tabBarPages/map_page.dart';

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
                        activities: [
                          DetailsModel(
                            name: 'Sailor Moon\'s Anniversary',
                            description:
                                'Un evento speciale per celebrare i 30 anni di Sailor Moon.',
                            notes: '01-28 nov•MUFANT Museum\nFree entry',
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
                      kSpaceBetweenSections,
                      CustomListWidget(
                        title: "Discover the Rooms",
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
