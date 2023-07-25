import 'card_model.dart';

class DrawModel {
  final int remaining;
  final List<CardModel> cards;

  DrawModel({this.remaining=-1, this.cards = const []});

   factory DrawModel.fromJson(Map<String, dynamic> json) {
    return DrawModel(
      remaining: json['remaining'],
      cards: (json['cards'] as List)
          .map((cardJson) => CardModel.fromJson(cardJson))
          .toList(),
    );
  }

  @override
  String toString() {
    super.toString();
    return 'DrawModel{remaining: $remaining, cards: $cards}';
  }
}
