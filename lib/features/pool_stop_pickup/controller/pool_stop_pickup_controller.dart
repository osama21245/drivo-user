import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';

class PoolStopPickupController extends GetxController implements GetxService {
  // Map controller
  GoogleMapController? mapController;

  // Selected addresses
  Address? pickupAddress;
  Address? destinationAddress;

  // Loading states
  bool _isLoading = false;
  bool _isSearchingTrips = false;

  // Text controllers
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // Available trips for this route
  List<Map<String, dynamic>> availableTrips = [];

  bool get isLoading => _isLoading;
  bool get isSearchingTrips => _isSearchingTrips;

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

    _isSearchingTrips = true;
    update();

    try {
      // TODO: Implement API call to search for available trips
      // This would search for drivers going from a location that passes through
      // the user's pickup and destination points

      // Mock data for now
      await Future.delayed(Duration(seconds: 2));

      availableTrips = [
        {
          'driverName': 'Ahmed Mohamed',
          'carModel': 'Toyota Camry',
          'departureTime': '2:30 PM',
          'estimatedPrice': '25 EGP',
          'rating': 4.8,
          'availableSeats': 2,
        },
        {
          'driverName': 'Sara Ali',
          'carModel': 'Honda Civic',
          'departureTime': '3:00 PM',
          'estimatedPrice': '20 EGP',
          'rating': 4.9,
          'availableSeats': 1,
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to search for trips');
    } finally {
      _isSearchingTrips = false;
      update();
    }
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






