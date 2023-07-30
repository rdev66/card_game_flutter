import 'card_model.dart';

class PlayerModel {
  final String name;
  final bool isHuman;
  List<CardModel> cards;

  PlayerModel(
      {required this.name, this.isHuman = false, this.cards = const []});

  addCards(List<CardModel> newCards) {
    cards = [...cards, ...newCards];
  }

  removeCard(CardModel card) {
    cards.removeWhere((c) => c.value == card.value && c.suit == card.suit);
  }

  bool get isBot {
    return !isHuman;
  }
  
}
