// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constant/constant.dart';

class ApiService {
  Future<List<dynamic>> getPlaceSuggestions(String input) async {
    String apiKey1 = API_KEY;
    String apiHost1 = API_HOST;
    String url = 'https://$apiHost1/autocomplete/json?input=$input&language=vi';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'x-rapidapi-key': apiKey1,
        'x-rapidapi-host': apiHost1,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['predictions'] != null) {
        return json['predictions'];
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

}
