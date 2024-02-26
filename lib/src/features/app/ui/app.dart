import 'package:flutter/material.dart';
import 'package:yrden_trail/src/features/map/ui/main_map.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YrdenTrail',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x006a6f4c)),
        useMaterial3: true,
      ),
      home: const MainMap(),
    );
  }
}
