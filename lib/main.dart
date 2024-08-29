import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm_example/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int roundUp = 1;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Nap Alarm',
      home: HomeScreen(),
    );
  }
}
