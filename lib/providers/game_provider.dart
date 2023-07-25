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

  Future<void> setupBoard() async {}
}
