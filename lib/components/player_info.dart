import 'package:flutter/material.dart';

import '../models/turn_model.dart';

class PlayerInfo extends StatelessWidget {
  final Turn turn;
  const PlayerInfo({required this.turn, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: turn.players.map((player) {
            final isCurrent = turn.currentPlayer == player;
            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isCurrent ? Colors.white : Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text("${player.name} (${player.cards.length})",
                      style: TextStyle(
                          color: isCurrent ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600)),
                ));
          }).toList(),
        ),
      ),
    );
  }
}
