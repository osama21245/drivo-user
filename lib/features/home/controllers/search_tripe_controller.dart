import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ride_sharing_user_app/features/home/domain/models/search_tripe_request_model.dart';
import 'package:ride_sharing_user_app/features/home/domain/models/search_tripe_response_model.dart';
import 'package:ride_sharing_user_app/features/home/services/search_tripe_services_interface%20copy.dart';
import 'package:ride_sharing_user_app/features/search_trips/screens/search_trips_screen.dart';

class SearchTripeController extends GetxController implements GetxService {
  final SearchTripeServiceInterface searchTripeServiceInterface;

  SearchTripeController({required this.searchTripeServiceInterface});

  List<SearchTripeAll> searchTripeList = [];
  ValueNotifier<bool> isLoadingSearchTripe = ValueNotifier(false);
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;
  int? availableSeats;
  String? startTime;

  void getAllSearchTripe() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoadingSearchTripe.value = true;
    });

    Response response = await searchTripeServiceInterface.searchTripe(
      // SearchTripeRequestModel(
      //   pickupLat: startLat!,
      //   pickupLng: endLng!,
      //   dropOffLat: endLat!,
      //   dropOffLng: endLng!,
      //   seatsRequired: availableSeats!,
      //   day: startTime!,
      // ),
      SearchTripeRequestModel(
        pickupLat: 30.0444183,
        pickupLng: 31.23571,
        dropOffLat: 30.0444183,
        dropOffLng: 31.23571,
        seatsRequired: 1,
        day: "2025-06-16",
      ),
    );

    if (response.statusCode == 200) {
      var data = SearchTripeResponseModel.fromJson(response.body);
      searchTripeList = data.data!.all!;

      Get.to(() => SearchTripsScreen());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoadingSearchTripe.value = false;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoadingSearchTripe.value = false;
      });
    }

    print('responseresponseresponseresponse${searchTripeList}');
  }
}
