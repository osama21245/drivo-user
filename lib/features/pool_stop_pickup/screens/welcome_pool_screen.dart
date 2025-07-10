import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/controller/pool_stop_pickup_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/screens/search_trip_drivers_screen.dart';
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
    // Initialize the controller - it will be automatically injected from DI
    Get.find<PoolStopPickupController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Find Your Ride',
          style: textBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<PoolStopPickupController>(
        builder: (poolController) {
          return GetBuilder<LocationController>(
            builder: (locationController) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(
                  children: [
                    // Welcome Header Card
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.groups,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Share Your Journey',
                                  style: textBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Find drivers going your way',
                                  style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Location Selection Card
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
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
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Text(
                                  'where_do_you_want_to_go'.tr,
                                  style: textBold.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

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

                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),

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

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          // Search Parameters
                          if (poolController.pickupAddress != null &&
                              poolController.destinationAddress != null) ...[
                            // Date Selection
                            _buildParameterField(
                              context,
                              icon: Icons.calendar_today,
                              label: 'select_date'.tr,
                              value: poolController.selectedDate.isEmpty
                                  ? 'tap_to_select_date'.tr
                                  : poolController.selectedDate,
                              onTap: () => _selectDate(context, poolController),
                            ),

                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),

                            // Gender and Seats Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownField(
                                    context,
                                    icon: Icons.person,
                                    label: 'gender_preference'.tr,
                                    value: poolController.selectedGender,
                                    items: ['both', 'male', 'female'],
                                    onChanged: (value) => poolController
                                        .setSearchParameters(gender: value),
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Expanded(
                                  child: _buildDropdownField(
                                    context,
                                    icon: Icons.people,
                                    label: 'seats_needed'.tr,
                                    value:
                                        poolController.selectedSeats.toString(),
                                    items: ['1', '2', '3'],
                                    onChanged: (value) =>
                                        poolController.setSearchParameters(
                                            seats: int.parse(value!)),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),

                            // Ride Type
                            _buildDropdownField(
                              context,
                              icon: Icons.work,
                              label: 'ride_type'.tr,
                              value: poolController.selectedRideType,
                              items: ['work', 'leisure', 'shopping', 'other'],
                              onChanged: (value) => poolController
                                  .setSearchParameters(rideType: value),
                            ),

                            // Search Button
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.paddingSizeDefault),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: poolController.isSearchingTrips
                                    ? null
                                    : () => _searchForRides(poolController),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeSmall),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                  ),
                                  elevation: 4,
                                  shadowColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
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
                                                      Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Searching for rides...',
                                            style: textMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Search for Rides',
                                            style: textBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // How it works section
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.05),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'how_it_works'.tr,
                            style: textBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Get.isDarkMode
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          _buildHowItWorksStep(
                            context,
                            icon: Images.currentLocation,
                            title: 'set_your_route'.tr,
                            description: 'choose_pickup_destination'.tr,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          _buildHowItWorksStep(
                            context,
                            icon: Images.searchImageIcon,
                            title: 'find_matching_rides'.tr,
                            description: 'discover_available_trips'.tr,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          _buildHowItWorksStep(
                            context,
                            icon: Images.carTripeIcon,
                            title: 'join_and_save_money'.tr,
                            description: 'share_cost_with_others'.tr,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    // Benefits section
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.05),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'why_choose_pool_ride'.tr,
                            style: textBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Get.isDarkMode
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
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

                    const SizedBox(height: Dimensions.paddingSizeDefault),
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
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.location_on_outlined,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: isSelected ? Colors.black87 : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey[400],
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
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 16,
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
                  fontSize: Dimensions.fontSizeSmall,
                  color: Get.isDarkMode
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              Text(
                description,
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
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
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            title,
            style: textMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
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

  Widget _buildParameterField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                label,
                style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            icon:
                Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey[600]),
            style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Colors.black87,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item.capitalizeFirst!,
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _selectDate(
      BuildContext context, PoolStopPickupController poolController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      String formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      poolController.setSearchParameters(date: formattedDate);
    }
  }

  void _searchForRides(PoolStopPickupController poolController) async {
    // Search for available rides using the controller
    await poolController.searchAvailableTrips();

    // Check results after the search is complete
    if (poolController.availableTrips.isNotEmpty) {
      // Navigate to search trip drivers screen
      Get.to(() => const SearchTripDriversScreen());
    } else {
      Get.snackbar(
        'no_rides_found'.tr,
        'try_different_route'.tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
