import 'package:card_game/constants.dart';
import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final double size;

  const CardBack({super.key, this.size = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: CARD_WIDTH * size,
        height: CARD_HEIGHT * size,
        color: Colors.blueGrey);
  }
}
