import 'package:flutter/material.dart';

enum Suit { CLUBS, DIAMONDS, HEARTS, SPADES, OTHER }

class CardModel {
  final String image;
  final Suit suit;
  final String value;

  CardModel({required this.image, required this.suit, required this.value});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      image: json['image'],
      suit: stringToSuit(json['suit']),
      value: json['value'],
    );
  }

  @override
  String toString() {
    super.toString();
    return 'CardModel{image: $image, suit: $suit, value: $value}';
  }

  static Suit stringToSuit(String suit) {
    switch (suit.toUpperCase()) {
      case 'CLUBS':
        return Suit.CLUBS;
      case 'DIAMONDS':
        return Suit.DIAMONDS;
      case 'HEARTS':
        return Suit.HEARTS;
      case 'SPADES':
        return Suit.SPADES;
      default:
        return Suit.OTHER;
    }
  }

  static String suitToString(Suit suit) {
    switch (suit) {
      case Suit.CLUBS:
        return 'CLUBS';
      case Suit.DIAMONDS:
        return 'DIAMONDS';
      case Suit.HEARTS:
        return 'HEARTS';
      case Suit.SPADES:
        return 'SPADES';
      default:
        return 'OTHER';
    }
  }

  static String suitToUnicode(Suit suit) {
    switch (suit) {
      case Suit.CLUBS:
        return '♣';
      case Suit.DIAMONDS:
        return '♦';
      case Suit.HEARTS:
        return '♥';
      case Suit.SPADES:
        return '♠';
      default:
        return 'OTHER';
    }
  }

  static Color suitToColor(Suit suit) {
    switch (suit) {
      case Suit.CLUBS:
      case Suit.SPADES:
        return Colors.black;
      case Suit.DIAMONDS:
      case Suit.HEARTS:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
