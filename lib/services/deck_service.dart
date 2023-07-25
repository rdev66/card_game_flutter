import 'package:card_game/models/deck_model.dart';
import 'package:card_game/models/draw_model.dart';
import 'package:card_game/services/api_service.dart';

class DeckService extends ApiService {
  Future<DeckModel> newDeck([int deckCount = 1]) async {
    //await viene del Get, no de la conversión.
    return DeckModel.fromJson(
        await get("deck/new/shuffle", {"deck_count": deckCount}));
  }

  Future<Map<String, dynamic>> shuffle(String deckId) async {
    return await get("deck/$deckId/shuffle");
  }

  Future<DrawModel> draw(String deckId, {int count = 1}) async {
    return DrawModel.fromJson(await get("deck/$deckId/draw", {"count": count}));
  }
}
