import 'package:card_game/components/card_back.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class DeckPile extends StatelessWidget {
  final int remaining;
  final double size;
  final bool canDraw;

  const DeckPile(
      {super.key,
      required this.remaining,
      this.size = 1.0,
      this.canDraw = false});

  @override
  Widget build(BuildContext context) {
    return CardBack(
      size: size,
      child: Text(
        '$remaining',
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
