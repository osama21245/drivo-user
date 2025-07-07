import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/controller/pool_stop_pickup_controller.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/pool_ride_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SearchTripDriversScreen extends StatelessWidget {
  const SearchTripDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'available_rides'.tr),
      body: GetBuilder<PoolStopPickupController>(
        builder: (poolController) {
          if (poolController.isSearchingTrips) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (poolController.availableTrips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.noDataFound,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    'no_rides_found'.tr,
                    style: textBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    'try_different_route_or_date'.tr,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(
                  children: [
                    Text(
                      'found_rides'.tr,
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${poolController.availableTrips.length} ${'rides'.tr}',
                        style: textMedium.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rides List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  itemCount: poolController.availableTrips.length,
                  itemBuilder: (context, index) {
                    PoolRide ride = poolController.availableTrips[index];
                    return _buildRideCard(context, ride, index, poolController);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRideCard(BuildContext context, PoolRide ride, int index,
      PoolStopPickupController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
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
          // Driver Info
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                backgroundImage: ride.driver.profileImage != null
                    ? NetworkImage(ride.driver.profileImage!)
                    : null,
                child: ride.driver.profileImage == null
                    ? Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.driver.fullName,
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    Text(
                      ride.driver.gender.capitalizeFirst!,
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${ride.price} ${'egp'.tr}',
                  style: textBold.copyWith(
                    color: Colors.green,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Vehicle Info
          Row(
            children: [
              Image.asset(
                Images.car,
                height: 20,
                width: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                '${ride.vehicle.brand} ${ride.vehicle.model}',
                style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ride.category,
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          // Trip Details
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: Theme.of(context).hintColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                _formatTime(ride.startTime),
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.people,
                size: 16,
                color: Theme.of(context).hintColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                '${ride.seatsAvailable} ${'seats'.tr}',
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          // Amenities
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (ride.isAc) _buildAmenityChip(context, Icons.ac_unit, 'ac'.tr),
              if (ride.hasMusic)
                _buildAmenityChip(context, Icons.music_note, 'music'.tr),
              if (ride.allowLuggage)
                _buildAmenityChip(context, Icons.luggage, 'luggage'.tr),
              if (!ride.isSmokingAllowed)
                _buildAmenityChip(context, Icons.smoke_free, 'no_smoking'.tr),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Join Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isJoining(ride.routeId)
                  ? null
                  : () => _joinRide(context, ride, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              child: controller.isJoining(ride.routeId)
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Join Ride - ${ride.price} EGP',
                      style: textBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String dateTime) {
    try {
      DateTime dt = DateTime.parse(dateTime);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }

  void _joinRide(BuildContext context, PoolRide ride,
      PoolStopPickupController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Join Ride'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Do you want to join this ride?'),
            const SizedBox(height: 8),
            Text('Driver: ${ride.driver.fullName}'),
            Text('Price: ${ride.price} EGP'),
            Text('Seats: ${controller.selectedSeats}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.joinRide(ride);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
