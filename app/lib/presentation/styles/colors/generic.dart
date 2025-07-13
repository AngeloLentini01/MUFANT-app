import 'package:flutter/material.dart';

const kPinkColor = Color(0xFFFF84B2); // Updated pink color
const kBlackColor = Color(0xFF313036); // Updated base color
const kBlackColorEnd = Color(0xFF4A465C); // End color for gradient
const kWhiteColor = Color.fromARGB(255, 246, 242, 245);

// Linear gradient from base color to end color
const kBackgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kBlackColor, kBlackColorEnd],
);
