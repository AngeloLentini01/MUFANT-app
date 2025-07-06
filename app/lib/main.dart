
import 'package:app/presentation/app_pre_configurator.dart';
import 'package:app/presentation/styles/colors/generic.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

typedef MySystem = SystemChrome;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Set system UI overlay style to ensure status bar matches app theme
  MySystem.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kBlackColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AppPreConfigurator());
}