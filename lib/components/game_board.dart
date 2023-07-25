import 'package:card_game/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_model.dart';

class GameBoard extends StatelessWidget {
  GameBoard({Key? key}) : super(key: key);

  final players = [
    PlayerModel(name: "Player Human", isHuman: true),
    PlayerModel(name: "Player Bot", isHuman: false)
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, model, child) {
      return model.currentDeck != null
          ? Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Test ${model.currentDeck?.deck_id}"))
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    model.newGame(players);
                  },
                  child: const Text("New Game?")));
    });
  }
}
