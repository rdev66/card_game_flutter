import 'package:card_game/constants.dart';
import 'package:card_game/main.dart';
import 'package:card_game/services/deck_service.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../models/deck_model.dart';
import '../models/player_model.dart';
import '../models/turn_model.dart';

class ActionButton {
  final String label;
  final Function() onPressed;
  bool enabled = true;

  ActionButton(
      {required this.label, required this.onPressed, required this.enabled});
}

abstract class GameProvider with ChangeNotifier {
  GameProvider() {
    _service = DeckService();
  }

  final Map<String, dynamic> gameState = {};
  Widget? bottomWidget;

  List<ActionButton> additionalButtons = [
    ActionButton(
        label: "Test",
        enabled: true,
        onPressed: () {
          print("Hi");
        })
  ];

  late DeckService _service;

  late Turn _turn;
  Turn get turn => _turn;

  DeckModel? _currentDeck;

  DeckModel? get currentDeck => _currentDeck;

  List<PlayerModel> _players = [];
  List<PlayerModel> get players => _players;

  List<CardModel> _discards = [];
  List<CardModel> get discards => _discards;

  CardModel? get discardTop => _discards.isNotEmpty ? _discards.last : null;

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    setupBoard();
    _turn = Turn(players: players, currentPlayer: players.first);

    notifyListeners();
  }

  void setBottomWidget(Widget? widget) {
    bottomWidget = widget;
    notifyListeners();
  }

  void setTrump(Suit suit) {
    setBottomWidget(Card(
        child: Text(CardModel.suitToUnicode(suit),
            style:
                TextStyle(fontSize: 24, color: CardModel.suitToColor(suit)))));
  }

  bool get showBottomWidget {
    return true;
  }

  void setLastPlayed(CardModel card) {
    gameState[GS_LAST_SUIT] = card.suit;
    gameState[GS_LAST_VALUE] = card.value;
    setTrump(card.suit);
  }

  Future<void> drawCards(PlayerModel player,
      {int count = 1, allowAnyTime = false}) async {
    if (_currentDeck == null) {
      return;
    }
    if (!allowAnyTime && !canDrawCard) return;

    final draw = await _service.draw(_currentDeck!.deck_id, count: count);

    player.addCards(draw.cards);

    _currentDeck!.remaining = draw.remaining;
    _turn.drawCount += count;

    notifyListeners();
  }

  Future<void> drawCardToDiscardPile({int count = 1}) async {
    final draw = await _service.draw(_currentDeck!.deck_id, count: count);

    _discards = [..._discards, ...draw.cards];

    _currentDeck!.remaining = draw.remaining;
    notifyListeners();
  }

  Future<void> playCard(
      {required PlayerModel player, required CardModel card}) async {
    if (!canPlayCard(card)) {
      showToast(message: "You can't play ${card.value} of ${card.suit}.");
    }

    player.removeCard(card);
    _discards.add(card);

    _turn.actionCount++;

    setLastPlayed(card);

    await applyCardSideEffects(card);

    if (gameIsOver) {
      finishGame();
    }

    notifyListeners();
  }

  Future<void> revertDiscardedCard(
      {required PlayerModel player, required CardModel card}) async {
    if (!canPlayCard(card)) return;

    _discards.remove(card);
    player.addCards([card]);
    _turn.actionCount--;
    notifyListeners();
  }

  bool canPlayCard(CardModel card) {
    if (gameIsOver) return false;

    return true;
  }

  bool canDrawCardsFromDiscardPile({int count = 1}) {
    if (!canDrawCard) return false;

    return discards.length >= count;
  }

  void drawCardsFromDiscard(PlayerModel player, [int count = 1]) {
    if (!canDrawCardsFromDiscardPile(count: count)) return;

    //get the first x cards
    final start = discards.length - count;
    final end = discards.length;

    final cards =
        discards.getRange(discards.length - count, discards.length).toList();

    discards.removeRange(start, end);

    //give them to player
    player.addCards(cards);

    //increment draw count
    turn.drawCount += count;

    notifyListeners();
  }

  Future<void> applyCardSideEffects(CardModel card) async {}

  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  bool get canEndTurn {
    return turn.drawCount > 0;
  }

  void endTurn() {
    _turn.nextTurn();
    if (_turn.currentPlayer.isBot) {
      botTurn();
    }
    notifyListeners();
  }

  void skipTurn() {
    _turn.nextTurn();
    _turn.nextTurn();
    notifyListeners();
  }

  bool get gameIsOver {
    return currentDeck!.remaining < 1;
  }

  void finishGame() {
    showToast(message: "Game Over");
    notifyListeners();
  }

  void botTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(_turn.currentPlayer);
    await Future.delayed(const Duration(milliseconds: 500));

    if (_turn.currentPlayer.cards.isEmpty) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    playCard(
        player: _turn.currentPlayer, card: _turn.currentPlayer.cards.first);

    if (canEndTurn) {
      endTurn();
    }
  }

  Future<void> setupBoard() async {}

  void showToast(
      {required String message, int seconds = 3, SnackBarAction? action}) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
      action: action,
    ));
  }
}
