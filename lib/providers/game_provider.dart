import 'package:card_game/services/deck_service.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../models/deck_model.dart';
import '../models/player_model.dart';
import '../models/turn_model.dart';

class GameProvider with ChangeNotifier {
  GameProvider() {
    _service = DeckService();
  }

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

  final Map<String, dynamic> _gameState = {};

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck();
    _currentDeck = deck;
    _players = players;
    _discards = [];
    _turn = Turn(players: players, currentPlayer: players.first);
    setupBoard();

    notifyListeners();
  }

  Future<void> drawCards(PlayerModel player, {int count = 1}) async {
    if (_currentDeck == null) {
      return;
    }

    final draw = await _service.draw(_currentDeck!.deck_id, count: count);

    player.addCards(draw.cards);

    _turn.drawCount += count;
    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  Future<void> playCard(
      {required PlayerModel player, required CardModel card}) async {
    if (!canPlayCard(card)) return;

    player.removeCard(card);
    _discards.add(card);

    await applyCardSideEffects(card);
    _turn.actionCount++;
    notifyListeners();
  }

  Future<void> revertDiscardedCard({required PlayerModel player, required CardModel card}) async {

        if (!canPlayCard(card)) return;

    _discards.remove(card);
    player.addCards([card]);
    _turn.actionCount--;
    notifyListeners();
  }

  bool canPlayCard(CardModel card) {
    return true;
  }

  Future<void> applyCardSideEffects(CardModel card) async {
    if (card.value == "JACK") {
      await drawCards(_turn.currentPlayer, count: 2);
    }
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

  void botTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(_turn.currentPlayer);
    await Future.delayed(const Duration(milliseconds: 500));
    if (canEndTurn) {
      endTurn();
    }
  }

  Future<void> setupBoard() async {}
}
