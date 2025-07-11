import 'package:app/presentation/styles/all.dart';
import 'package:app/presentation/views/tabBarPages/shop_page.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:flutter/material.dart';

class CartConfirmationPage extends StatefulWidget {
  const CartConfirmationPage({super.key});

  @override
  State<CartConfirmationPage> createState() => _CartConfirmationPageState();
}

class _CartConfirmationPageState extends State<CartConfirmationPage> {
  final cardGroup = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO: appbar
      ),
      body: cardGroup.isEmpty
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120, left: 32, right: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Oops! Your cart’s still in hypersleep. Wake it up with a purchase!",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),

                      kSpaceBetweenSections,
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: kPinkColor,
                            width: 2,
                          ), // Colored border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18,
                            ), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShopPage()),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Browse Tickets",
                            style: TextStyle(fontSize: 16, color: kPinkColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/images/shop_bot/sad_bot_cut.png', // Use your asset path here
                    height: 300, // Adjust size as needed
                  ),
                ),
              ],
            )
          : SingleChildScrollView(),
      bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
    );
  }
}
