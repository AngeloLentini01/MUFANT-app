import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/splashPage/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppPreConfigurator extends StatelessWidget {
  const AppPreConfigurator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mufant',
      debugShowCheckedModeBanner: false,
      // Enable proper navigation history
      navigatorKey: GlobalKey<NavigatorState>(),

      // Easy Localization configuration
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      theme: ThemeData(
        textTheme: GoogleFonts.exoTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: kBlackColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBlackColor,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kBlackColor,
          secondary: kPinkColor,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
