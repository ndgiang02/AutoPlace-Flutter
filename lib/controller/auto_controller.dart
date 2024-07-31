import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../service/api.dart';

class AutoController extends GetxController {
  TextEditingController addressSearch = TextEditingController();

  final ApiService _apiService = ApiService();
  var placeList = <dynamic>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var pickupLocation = ''.obs;

  void getPlaceSuggestions(String input) async {
    placeList.value = await _apiService.getPlaceSuggestions(input);
  }

  @override
  void onClose() {
    addressSearch.dispose();
    super.onClose();
  }

}

