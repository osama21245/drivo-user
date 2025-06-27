import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/controller/pool_stop_pickup_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/search_trips/screens/search_trips_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:geolocator/geolocator.dart';

class WelcomePoolScreen extends StatefulWidget {
  const WelcomePoolScreen({super.key});

  @override
  State<WelcomePoolScreen> createState() => _WelcomePoolScreenState();
}

class _WelcomePoolScreenState extends State<WelcomePoolScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the controller
    if (!Get.isRegistered<PoolStopPickupController>()) {
      Get.put(PoolStopPickupController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<PoolStopPickupController>(
        builder: (poolController) {
          return GetBuilder<LocationController>(
            builder: (locationController) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // Location Selection Card
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  Images.routeSquare,
                                  height: 24,
                                  width: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Text(
                                  'where_do_you_want_to_go'.tr,
                                  style: textBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          // From Location
                          _buildLocationField(
                            context,
                            icon: Images.currentLocation,
                            label: 'pickup_location'.tr,
                            value: poolController.pickupAddress?.address ??
                                'tap_to_select_pickup'.tr,
                            onTap: () => _selectPickupLocation(poolController),
                            isSelected: poolController.pickupAddress != null,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          // To Location
                          _buildLocationField(
                            context,
                            icon: Images.activityDirection,
                            label: 'destination'.tr,
                            value: poolController.destinationAddress?.address ??
                                'tap_to_select_destination'.tr,
                            onTap: () =>
                                _selectDestinationLocation(poolController),
                            isSelected:
                                poolController.destinationAddress != null,
                          ),

                          // Search Button
                          if (poolController.pickupAddress != null &&
                              poolController.destinationAddress != null)
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeDefault),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: poolController.isSearchingTrips
                                    ? null
                                    : () => _searchForRides(poolController),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                ),
                                child: poolController.isSearchingTrips
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'searching'.tr,
                                            style: textMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        'search_for_rides'.tr,
                                        style: textBold.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // How it works section
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'how_it_works'.tr,
                            style: textBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Get.isDarkMode
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          _buildHowItWorksStep(
                            context,
                            icon: Images.currentLocation,
                            title: 'set_your_route'.tr,
                            description: 'choose_pickup_destination'.tr,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          _buildHowItWorksStep(
                            context,
                            icon: Images.searchImageIcon,
                            title: 'find_matching_rides'.tr,
                            description: 'discover_available_trips'.tr,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          _buildHowItWorksStep(
                            context,
                            icon: Images.carTripeIcon,
                            title: 'join_and_save_money'.tr,
                            description: 'share_cost_with_others'.tr,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Benefits section
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'why_choose_pool_ride'.tr,
                            style: textBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Get.isDarkMode
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildBenefit(context,
                                  icon: Images.coinIcon,
                                  title: 'save_money'.tr),
                              _buildBenefit(context,
                                  icon: Images.peopleIcon,
                                  title: 'meet_people'.tr),
                              _buildBenefit(context,
                                  icon: Images.car, title: 'eco_friendly'.tr),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLocationField(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 20,
              width: 20,
              color: Colors.white,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    value,
                    style: textMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksStep(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            icon,
            height: 20,
            width: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Get.isDarkMode
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              Text(
                description,
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefit(
    BuildContext context, {
    required String icon,
    required String title,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(
            title,
            style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Get.isDarkMode
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.inverseSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _selectPickupLocation(PoolStopPickupController poolController) {
    // Use direct map picking like other app functions
    Get.to(() => PickMapScreen(
          type: LocationType.from,
          onLocationPicked: (Position position, String address) {
            // Create address object and save to controller
            Address pickupAddress = Address(
              id: 0,
              addressLabel: 'pickup',
              contactPersonName: '',
              contactPersonPhone: '',
              address: address,
              latitude: position.latitude,
              longitude: position.longitude,
            );
            poolController.setPickupAddress(pickupAddress);
          },
        ));
  }

  void _selectDestinationLocation(PoolStopPickupController poolController) {
    // Use direct map picking like other app functions
    Get.to(() => PickMapScreen(
          type: LocationType.to,
          onLocationPicked: (Position position, String address) {
            // Create address object and save to controller
            Address destinationAddress = Address(
              id: 0,
              addressLabel: 'destination',
              contactPersonName: '',
              contactPersonPhone: '',
              address: address,
              latitude: position.latitude,
              longitude: position.longitude,
            );
            poolController.setDestinationAddress(destinationAddress);
          },
        ));
  }

  void _searchForRides(PoolStopPickupController poolController) {
    // Search for available rides using the controller
    poolController.searchAvailableTrips().then((_) {
      if (poolController.availableTrips.isNotEmpty) {
        // Navigate to search trips screen
        Get.to(() => const SearchTripsScreen());
      } else {
        Get.snackbar(
          'no_rides_found'.tr,
          'try_different_route'.tr,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    });
  }
}
