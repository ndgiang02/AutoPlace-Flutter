import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../service/api.dart';

class HomeController extends GetxController {
    TextEditingController pickupController = TextEditingController();
    TextEditingController destinationController = TextEditingController();

    var isLoading = false.obs;
    var pickupLocation = ''.obs;
    var destinationLocation = ''.obs;
    var distance = 0.0.obs;

    final ApiService _apiService = ApiService();
    var pickupPlaceList = <dynamic>[].obs;
    var destinationPlaceList = <dynamic>[].obs;

    void getPickupPlace(String input) async {
      pickupPlaceList.value = await _apiService.getPlaceSuggestions(input);
    }

    void getDestinationPlace(String input) async {
      destinationPlaceList.value = await _apiService.getPlaceSuggestions(input);
    }

    Future<void> calculateDistance(double pickupLat, double pickupLng, double destinationLat, double destinationLng) async {
        final String url = 'https://distance-matrix-routing.p.rapidapi.com/distance';

        final Uri uri = Uri.parse('$url?origin=$pickupLat,$pickupLng&destination=$destinationLat,$destinationLng&order=lat_lon&priority=fast&vehicle=auto&units=km');

        final headers = {
            'X-RapidAPI-Key': API_KEY,
            'X-RapidAPI-Host': 'distance-matrix-routing.p.rapidapi.com',
        };

        try {
            final response = await http.get(uri, headers: headers);

            if (response.statusCode == 200) {
                final data = json.decode(response.body);
                print('Response data: $data'); 

                if (data != null && data['rows'] != null && data['rows'].isNotEmpty) {
                    final elements = data['rows'][0]['elements'];
                    if (elements != null && elements['distance'] != null) {
                        distance.value = elements['distance']['value'];
                        print('Distance: ${distance.value} meters');
                    } else {
                        print('Distance data not found in elements');
                    }
                } else {
                    print('No rows found in response');
                }
            } else {
                print('Failed to load distance: ${response.statusCode}');
            }
        } catch (e) {
            print("Error calculating distance: $e");
        }
    }

    Future<Map<String, double>?> getLatLngFromAddress(String address) async {
        final String apiKey = API_KEY;
        final String url = 'https://geocoding-forward-and-reverse.p.rapidapi.com/geocode';

        try {
            final response = await http.get(
                Uri.parse('$url?address=${Uri.encodeComponent(address)}'),
                headers: {
                    'X-RapidAPI-Key': apiKey,
                    'X-RapidAPI-Host': 'geocoding-forward-and-reverse.p.rapidapi.com',
                },
            );

            print('Response status: ${response.statusCode}');
            print('Response body: ${response.body}');

            if (response.statusCode == 200) {
                final data = json.decode(response.body);
                if (data['results'] != null && data['results'].isNotEmpty) {
                    final lat = data['results'][0]['geometry']['location']['lat'];
                    final lng = data['results'][0]['geometry']['location']['lng'];
                    return {'lat': lat, 'lng': lng};
                } else {
                    print('No results found');
                }
            } else {
                print('Error: ${response.reasonPhrase}');
            }
        } catch (e) {
            print('Exception: $e');
        }

        return null;
    }


    void fetchLatLngFromView(String address) async {
        final latLng = await getLatLngFromAddress(address);

        if (latLng != null) {
            print('Latitude: ${latLng['lat']}, Longitude: ${latLng['lng']}');
        } else {
            print('Could not fetch location.');
        }
    }

    Future<void> getDistanceBetweenLocations() async {
        final pickupLatLng = await getLatLngFromAddress(pickupController.text);
        final destinationLatLng = await getLatLngFromAddress(destinationController.text);

        if (pickupLatLng != null && destinationLatLng != null) {
            await calculateDistance(
                pickupLatLng['lat']!,
                pickupLatLng['lng']!,
                destinationLatLng['lat']!,
                destinationLatLng['lng']!,
            );
        } else {
            print('Could not fetch coordinates for pickup or destination.');
        }
    }


}
