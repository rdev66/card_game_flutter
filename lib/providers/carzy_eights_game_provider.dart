import 'package:card_game/components/suit_chooser_modal.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/main.dart';
import 'package:card_game/models/card_model.dart';
import 'package:card_game/providers/game_provider.dart';
import 'package:flutter/material.dart';

class CrazyEightsGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (var player in players) {
      await drawCards(player, count: 8, allowAnyTime: true);
    }
    await drawCardToDiscardPile();

    setLastPlayed(discardTop!);
  }

  @override
  Future<void> applyCardSideEffects(CardModel card) async {
    if (card.value == "8" ||
        card.value == "7" ||
        card.value == "6" ||
        card.value == "5") {
      Suit suit;

      if (turn.currentPlayer.isHuman) {
        //show picker
        suit = await showDialog(
            context: navigatoryKey.currentContext!,
            builder: (_) => const SuitChooserModal(),
            barrierDismissible: false);
      } else {
        suit = turn.currentPlayer.cards.first.suit;
      }
      gameState[GS_LAST_SUIT] = suit;
      setTrump(suit);
      showToast(
          message:
              "${turn.currentPlayer.name} has switched to ${CardModel.suitToString(suit)}");
    } else if (card.value == "2") {
      await drawCards(turn.otherPlayer, count: 2, allowAnyTime: true);
      showToast(message: "${turn.otherPlayer.name} draws 2 cards");
    } else if (card.value == "4") {
      await drawCards(turn.otherPlayer, count: 4, allowAnyTime: true);
      showToast(message: "${turn.otherPlayer.name} draws 4 cards");
    } else if (card.suit == Suit.SPADES && card.value == "QUEEN") {
      await drawCards(turn.otherPlayer, count: 5, allowAnyTime: true);
      showToast(message: "${turn.otherPlayer.name} draws 5 cards");
    } else if (card.value == "JACK") {
      showToast(message: "${turn.otherPlayer.name} misses a turn");
      skipTurn();
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
