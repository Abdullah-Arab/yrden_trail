import 'package:flutter/material.dart';
import 'package:yrden_trail/src/features/map/ui/main_map.dart';
import 'package:yrden_trail/src/utilites/consts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YrdenTrail',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Consts.primaryColor),
        useMaterial3: true,
      ),
      home: const MainMap(),
    );
  }
}
