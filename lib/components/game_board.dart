import 'package:card_game/components/card_list.dart';
import 'package:card_game/components/deck_pile.dart';
import 'package:card_game/components/discard_pile.dart';
import 'package:card_game/models/card_model.dart';
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              await model.drawCards(model.turn.currentPlayer);
                            },
                            child: DeckPile(
                                remaining: model.currentDeck!.remaining)),
                        const SizedBox(width: 8),
                        DiscardPile(cards: model.discards,
                          onPlayCard: (CardModel card) {
                          model.revertDiscardedCard(player: model.players[0], card: card);
                        }, )
                      ],
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: CardList(
                    player: model.players[1],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (model.turn.currentPlayer == model.players[0])
                              ElevatedButton(
                                  onPressed: model.canEndTurn
                                      ? () {
                                          model.endTurn();
                                        }
                                      : null,
                                  child: const Text("End Turn"))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CardList(
                        player: model.players[0],
                        onPlayCard: (CardModel card) {
                          //print(card.value);
                          model.playCard(player: model.players[0], card: card);
                        },
                      ),
                    ],
                  ),
                )
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