import 'package:app/presentation/views/home_page.dart';
import 'package:app/presentation/widgets/bars/home_page_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class DetailRoom extends StatelessWidget {
  static const blueColor = Color.fromARGB(255, 28, 28, 50);
  static const backText = Color(0x9A545165);
  static const lightBlack = Color(0x56000000);
  static const textStarWars =
      "Welcome to a galaxy far, far away!\nThis room is a tribute to the legendary Star Wars universe, the saga created by George Lucas in 1977 that revolutionized science fiction and captured the hearts of generations. Here you'll find a treasure trove of pure passion: vintage collectible action figures, original movie posters, artist illustrations, iconic models, costumes created by Basic Net, and a true gem for fans — the 1:1 scale prop of Han Solo frozen in carbonite, a rare piece by Sideshow.\nA journey through myth, collecting, and nostalgic wonder.";
  final String title;
  const DetailRoom({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO sliverAppBar
        title: Text(
          title,
          style: TextStyle(
            color: pinkColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/starwarsbackground.png",
                fit: BoxFit.cover,
              ),
            ), //background image
            Positioned.fill(child: Container(color: lightBlack)),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/starwarsmap.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  kWhiteSpace,
                  Center(
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: pinkColor, // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  color: pinkColor,
                                  size: 30,
                                ),
                                SizedBox(width: 8),
                                const Text(
                                  "listen to the text-to-spech",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kWhiteSpace,
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backText,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10),
                        child: Text(
                          textStarWars,
                          style: TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomePageBottomNavBar(backgroundColor: blackColor),
    );
  }
}
