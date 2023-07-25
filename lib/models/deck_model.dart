class DeckModel {
  // ignore: non_constant_identifier_names
  final String deck_id;
  bool shuffled;
  int remaining;

  DeckModel(this.deck_id, this.shuffled, this.remaining);

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      json['deck_id'],
      json['shuffled'],
      json['remaining'],
    );
  }

  @override
  String toString() {
    super.toString();
    return 'DeckModel{deck_id: $deck_id, shuffled: $shuffled, remaining: $remaining}';
  }
}
