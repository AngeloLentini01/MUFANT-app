
import 'package:app/presentation/my_app.dart';
import 'package:app/presentation/styles/colors/generic.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';



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
      statusBarColor: kBlackColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}


