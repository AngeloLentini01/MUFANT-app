
import 'package:app/view/homepage/home_page.dart';
import 'package:app/my_app.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
 // Add this import



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Set system UI overlay style to ensure status bar matches app theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: blackColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}


