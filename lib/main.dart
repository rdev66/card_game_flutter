import 'package:card_game/components/game_screen.dart';
import 'package:card_game/providers/carzy_eights_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final navigatoryKey = GlobalKey<NavigatorState>();
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CrazyEightsGameProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      navigatorKey: navigatoryKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(
        title: 'Card Game',
      ),
    );
  }
}
 