import 'package:card_game/components/game_screen.dart';
import 'package:card_game/providers/crazy_eights_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/thirty_one_game_provider.dart';

final navigatoryKey = GlobalKey<NavigatorState>();
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CrazyEightsGameProvider()),
    ChangeNotifierProvider(create: (_) => ThirtyOneGameProvider())
  ], child: const GameApp()));
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

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
