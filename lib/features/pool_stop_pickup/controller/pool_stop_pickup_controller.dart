import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/services/pool_service.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/find_match_request.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/find_match_response.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/pool_ride_model.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/join_request.dart';

class PoolStopPickupController extends GetxController implements GetxService {
  final PoolService poolService;

  PoolStopPickupController({required this.poolService});
  // Map controller
  GoogleMapController? mapController;

  // Selected addresses
  Address? pickupAddress;
  Address? destinationAddress;

  // Loading states
  bool _isLoading = false;
  bool _isSearchingTrips = false;
  Set<int> _joiningRouteIds = {};

  // Text controllers
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // Available trips for this route
  List<PoolRide> availableTrips = [];

  // Search parameters
  String selectedGender = 'both';
  int selectedSeats = 1;
  String selectedRideType = 'work';
  String selectedDate = '';

  bool get isLoading => _isLoading;
  bool get isSearchingTrips => _isSearchingTrips;
  bool isJoining(int routeId) => _joiningRouteIds.contains(routeId);

  void setPickupAddress(Address address) {
    pickupAddress = address;
    pickupController.text = address.address ?? '';
    update();
  }

  void setDestinationAddress(Address address) {
    destinationAddress = address;
    destinationController.text = address.address ?? '';
    update();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> searchAvailableTrips() async {
    if (pickupAddress == null || destinationAddress == null) {
      Get.snackbar(
          'Error', 'Please select both pickup and destination locations');
      return;
    }

    if (selectedDate.isEmpty) {
      Get.snackbar('Error', 'Please select a date');
      return;
    }

    _isSearchingTrips = true;
    update();

    try {
      // Create the request object
      FindMatchRequest request = FindMatchRequest(
        pickupLat: pickupAddress!.latitude!,
        pickupLng: pickupAddress!.longitude!,
        dropoffLat: destinationAddress!.latitude!,
        dropoffLng: destinationAddress!.longitude!,
        day: selectedDate,
        gender: selectedGender,
        seatsRequired: selectedSeats,
        rideType: selectedRideType,
      );

      // Make the API call
      FindMatchResponse? response =
          await poolService.findMatchingRides(request);

      if (response != null && response.responseCode == 'default_200') {
        availableTrips = response.data;
        if (availableTrips.isEmpty) {
          Get.snackbar('No Rides Found', 'Try different route or date');
        }
      } else {
        Get.snackbar(
            'Error', response?.message ?? 'Failed to search for trips');
        availableTrips = [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search for trips: ${e.toString()}');
      availableTrips = [];
    } finally {
      _isSearchingTrips = false;
      update();
    }
  }

  Future<void> joinRide(PoolRide poolRide) async {
    if (pickupAddress == null || destinationAddress == null) {
      Get.snackbar('Error', 'Pickup and destination addresses are required');
      return;
    }

    _joiningRouteIds.add(poolRide.routeId);
    update();

    try {
      // Create the join request
      JoinRequest request = JoinRequest(
        routeId: poolRide.routeId,
        seatsCount: selectedSeats,
        pickupLat: pickupAddress!.latitude!,
        pickupLng: pickupAddress!.longitude!,
        dropoffLat: destinationAddress!.latitude!,
        dropoffLng: destinationAddress!.longitude!,
        fare: poolRide.price,
      );

      // Make the API call
      bool success = await poolService.joinRide(request);

      if (success) {
        Get.snackbar(
          'Success',
          'Join request sent successfully! The driver will be notified.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Optionally navigate to a different screen or refresh data
      } else {
        Get.snackbar(
          'Error',
          'Failed to send join request. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to join ride: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _joiningRouteIds.remove(poolRide.routeId);
      update();
    }
  }

  void setSearchParameters({
    String? gender,
    int? seats,
    String? rideType,
    String? date,
  }) {
    if (gender != null) selectedGender = gender;
    if (seats != null) selectedSeats = seats;
    if (rideType != null) selectedRideType = rideType;
    if (date != null) selectedDate = date;
    update();
  }

  void clearAddresses() {
    pickupAddress = null;
    destinationAddress = null;
    pickupController.clear();
    destinationController.clear();
    availableTrips.clear();
    update();
  }

  @override
  void onClose() {
    pickupController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}
