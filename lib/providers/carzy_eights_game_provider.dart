import 'package:card_game/constants.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/providers/game_provider.dart';

class CrazyEightsGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (var player in players) {
      await drawCards(player, count: 8, allowAnyTime: true);
    }
    await drawCardToDiscardPile();

    setLastPlayed(discardTop!);
  }

  // TODO Here //
  @override
  Future<void> applyCardSideEffects(CardModel card) async {
    if (card.value == "8") {
      if (turn.currentPlayer.isHuman) {
        //show picker
      }
    }
  }

  @override
  bool get canEndTurn {
    return turn.drawCount > 0 || turn.actionCount > 0;
  }

  @override
  bool canPlayCard(CardModel card) {
    bool canPlay = false;

    if (gameState[GS_LAST_SUIT] == null || gameState[GS_LAST_VALUE] == null) {
      return false;
    }

    if (gameState[GS_LAST_SUIT] == card.suit ||
        gameState[GS_LAST_VALUE] == card.value) {
      canPlay = true;
    }

    if (card.value == '8') {
      canPlay = true;
    }

    return canPlay;
  }

  @override
  void botTurn() async {
    final p = turn.currentPlayer;
    final cards = p.cards;

    await Future.delayed(const Duration(milliseconds: 250));

    for (final card in cards) {
      if (canPlayCard(card)) {
        await playCard(player: p, card: card);
        endTurn();
        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 250));
    await drawCards(p);
    await Future.delayed(const Duration(milliseconds: 250));

    //Try to play the new card
    if (canPlayCard(p.cards.last)) {
      await playCard(player: p, card: p.cards.last);
    }

    endTurn();
  }
}
