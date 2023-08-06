import 'package:flutter/material.dart';

import '../models/card_model.dart';

class _SuitOption {
  final Suit value;
  //
  late Color color;
  late String label;

  _SuitOption({required this.value}) {
    color = CardModel.suitToColor(value);
    label = CardModel.suitToUnicode(value);
  }
}

class SuitChooserModal extends StatelessWidget {
  const SuitChooserModal({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SuitOption> suits = [
      _SuitOption(value: Suit.SPADES),
      _SuitOption(value: Suit.HEARTS),
      _SuitOption(value: Suit.DIAMONDS),
      _SuitOption(value: Suit.CLUBS),
    ];

    return AlertDialog(
      title: const Text("Choose a suit"),
      content: Row(
          children: suits
              .map((suit) => TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(suit.value);
                    },
                    child: Text(suit.label,
                        style: TextStyle(color: suit.color, fontSize: 30)),
                  ))
              .toList()),
    );
  }
}
