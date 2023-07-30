import 'package:card_game/providers/carzy_eights_game_provider.dart';
import 'package:card_game/services/deck_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player_model.dart';
import 'game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //Only access onPress new game; no subscription
  late final CrazyEightsGameProvider _gameProvider =
      Provider.of<CrazyEightsGameProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    //final service = DeckService();
    //tempFunc();
  }

  void tempFunc() async {
    final service = DeckService();
    final data = await service.newDeck();

    final draw = await service.draw(data.deck_id, count: 1);
    print(draw.cards.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Crazy 8s Game"), actions: [
          TextButton(
              onPressed: () async {
                final players = [
                  PlayerModel(name: "Player Human", isHuman: true),
                  PlayerModel(name: "Player Bot", isHuman: false)
                ];

                await _gameProvider.newGame(players);
              },
              child:
                  const Text("New Game", style: TextStyle(color: Colors.white)))
        ]),
        body: GameBoard());
  }
}
