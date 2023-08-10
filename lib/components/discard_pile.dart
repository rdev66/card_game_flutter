import 'package:card_game/components/playing_card.dart';
import 'package:card_game/constants.dart';
import 'package:card_game/models/card_model.dart';
import 'package:flutter/material.dart';

class DiscardPile extends StatelessWidget {
  final List<CardModel> cards;
  final double size;
  final Function(CardModel)? onPlayCard;
  final Function(CardModel)? onPressed;

  const DiscardPile(
      {Key? key,
      required this.cards,
      this.size = 1.0,
      this.onPlayCard,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed?.call(cards.last);
        }
      },
      child: Container(
        width: CARD_WIDTH * size,
        height: CARD_HEIGHT * size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 2.0),
        ),
        child: IgnorePointer(
          ignoring: true,
          child: Stack(
              children: cards
                  .map((card) => PlayingCard(
                        card: card,
                        visible: true,
                        onPlayCard: (card) => onPlayCard?.call(card),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
