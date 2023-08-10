import 'dart:math';

import 'package:card_game/models/card_model.dart';
import 'package:card_game/providers/game_provider.dart';

const PLAYER_HAS_KNOCKED = 'GS_PLAYER_HAS_KNOCKED';

class ThirtyOneGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (var player in players) {
      await drawCards(player, count: 3, allowAnyTime: true);
    }

    await drawCardToDiscardPile();

    turn.drawCount = 0;
  }

  @override
  bool get canEndTurn {
    return turn.drawCount == 1 && turn.actionCount == 1;
  }

  @override
  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  @override
  bool canPlayCard(CardModel card) {
    return turn.drawCount == 1 && turn.actionCount < 1;
  }

  @override
  bool get gameIsOver {
    if (gameState[PLAYER_HAS_KNOCKED] != null &&
        gameState[PLAYER_HAS_KNOCKED] == turn.currentPlayer) {
      print("End Game");
      return true;
    }
    return false;
  }

  @override
  void finishGame() {
    for (final p in turn.players) {
      int diamondsPoints = 0;
      int spadesPoints = 0;
      int clubsPoints = 0;
      int heartsPoints = 0;

      int points = 0;
      for (final c in p.cards) {
        switch (c.value) {
          case "JACK":
          case "QUEEN":
          case "KING":
            points += 10;
            break;
          case "ACE":
            points += 11;
            break;
          default:
            points += int.parse(c.value);
        }

        switch (c.suit) {
          case Suit.DIAMONDS:
            diamondsPoints += points;
            break;
          case Suit.SPADES:
            spadesPoints += points;
            break;
          case Suit.CLUBS:
            clubsPoints += points;
          case Suit.HEARTS:
            heartsPoints += points;
            break;
          case Suit.OTHER:
            break;
        }
      }
      p.score = points;

      print("{p.name} - {p.score}");

      print("spades: $spadesPoints");
      print("hearts: $heartsPoints");
      print("clubs: $clubsPoints");
      print("diamonds: $diamondsPoints");

      final totalPoints = [
        spadesPoints,
        heartsPoints,
        diamondsPoints,
        clubsPoints
      ].fold(spadesPoints, max);
      print(totalPoints);
      p.score = totalPoints;
    }
    notifyListeners();
  }

  @override
  bool get showBottomWidget {
    return true;
  }

  @override
  void botTurn() async {
    print("Bot Turn"); //TODO: Implement bot turn
    super.botTurn();
  }

  @override
  get additionalButtons {
    return [
      ActionButton(
          label: "Knock",
          onPressed: () => () {
                gameState[PLAYER_HAS_KNOCKED] = turn.currentPlayer;
                endTurn();
              },
          enabled: true),
    ];
  }
}
