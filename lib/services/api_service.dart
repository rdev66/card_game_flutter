import 'dart:convert';

import 'package:validators/sanitizers.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://www.deckofcardsapi.com/api";

  Uri _url(String path, [Map<String, dynamic> params = const {}]) {
    String queryString = "";

    if (params.isNotEmpty) {
      queryString = "?";
      params.forEach((key, value) {
        queryString += "$key=$value&";
      });
    }

    path = rtrim(path, '/');
    path = ltrim(path, '/');

    queryString = rtrim(queryString, '&');

    return Uri.parse("$baseUrl/$path/$queryString");
  }

  Future<Map<String, dynamic>> get(String path,
      [Map<String, dynamic> params = const {}]) async {

        final url = _url(path, params);

    final response = await http.get(url); 

    if (response.bodyBytes.isEmpty) { 
      return {};
    }        
        
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
