import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/texts/text_detail_room.dart';
import 'package:app/presentation/widgets/bars/home_page_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class DetailRoom extends StatelessWidget {
  static const blueColor = Color.fromARGB(255, 28, 28, 50);
  static const backText = Color(0x9A545165);
  static const lightBlack = Color(0x56000000);
  static const kBlankSpaceWidget = SizedBox(height: 24);

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
            color: kPinkColor,
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
              child: Image.asset(assetStarWarsBG, fit: BoxFit.cover),
            ), //background image
            Positioned.fill(child: Container(color: lightBlack)),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(assetStarWarsMap, fit: BoxFit.cover),
                  ),
                  kBlankSpaceWidget,
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
                                color: kPinkColor, // Border color
                                width: 1, // Border width
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.volume_up_outlined,
                                  color: kPinkColor,
                                  size: 30,
                                ),
                                SizedBox(width: 8),
                                const Text(
                                  buttonText,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kBlankSpaceWidget,
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
      bottomNavigationBar: HomePageBottomNavBar(backgroundColor: kBlackColor),
    );
  }
}
