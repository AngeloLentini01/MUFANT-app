import 'package:app/presentation/styles/all.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class PaymentType extends StatelessWidget {
  const PaymentType({
    super.key,
    required this.asset,
    required this.name,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String name;
  final String asset;
  final String groupValue;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const colorRadiosSelector = Color.fromARGB(204, 154, 147, 186);

    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPinkColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: paddingCardOption,
          child: Row(
            children: [
              SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  8,
                ), // Adjust for more/less rounding
                child: Image.asset(
                  asset,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              startTextDistance,
              SizedBox(width: 100, child: Text(name)),
              textRadioDistance,
              Radio<String>(
                //TODO: change color of unselected widget to change radio unselected button color on the theme
                focusColor: colorRadiosSelector,
                activeColor: colorRadiosSelector,
                hoverColor: colorRadiosSelector,
                value: value,
                groupValue: groupValue,
                onChanged: (String? newValue) {
                  onChanged(newValue!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  String isChecked = " ";
  int test = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Shop", style: TextStyle(color: kWhiteColor)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose your payment method",
                  style: TextStyle(
                    color: kPinkColor,
                    fontSize: 28,
                    height: 1.2,
                  ),
                ),
                kSpaceBetweenSections,
                PaymentType(
                  asset: "assets/images/payment_icon/paypal_logo.png",
                  name: "Paypal",
                  groupValue: isChecked,
                  value: "Paypal",
                  onChanged: (String newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  },
                ),
                kSpaceBetweenSections,
                PaymentType(
                  asset: "assets/images/payment_icon/mastercard_logo.png",
                  name: "Master Card",
                  groupValue: isChecked,
                  value: "Master Card",
                  onChanged: (String newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  },
                ),
                if (isChecked == "Master Card")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kPinkColor),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Card Number",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          cardOtherDistance,
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "Due date",
                                    hintText: "MM/YY",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                              dateCvvDistance,
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "CVV",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                kSpaceBetweenSections,
                PaymentType(
                  asset: "assets/images/payment_icon/apple_pay_logo.png",
                  name: "Apple Pay",
                  groupValue: isChecked,
                  value: "apple Pay",
                  onChanged: (String newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  },
                ),
                kSpaceBetweenSections,
                PaymentType(
                  asset: "assets/images/payment_icon/google_pay_logo.jpg",
                  name: "Google Pay",
                  groupValue: isChecked,
                  value: "Google Play",
                  onChanged: (String newValue) {
                    setState(() {
                      isChecked = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
      ),
    );
  }
}
