import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button_widget/slider_button_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

enum FindingRide { ride, parcel }

class FindingRiderWidget extends StatefulWidget {
  final FindingRide fromPage;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const FindingRiderWidget({
    super.key,
    required this.fromPage,
    required this.expandableKey,
  });

  @override
  State<FindingRiderWidget> createState() => _FindingRiderWidgetState();
}

class _FindingRiderWidgetState extends State<FindingRiderWidget> {
  bool isSearching = true;

  @override
  void initState() {
    Get.find<RideController>().countingTimeStates();
    super.initState();
  }

  Future<void> _openGoogleMapsWithDirections() async {
    try {
      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Service Disabled',
          'Please enable location services to get directions',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Permission Denied',
            'Please grant location permission to get directions',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Permission Denied',
          'Location permissions are permanently denied, we cannot request permissions.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get destination from trip details
      final tripDetails = Get.find<RideController>().tripDetails;
      String googleMapsUrl;

      if (tripDetails?.destinationCoordinates != null &&
          tripDetails!.destinationCoordinates!.coordinates != null &&
          tripDetails.destinationCoordinates!.coordinates!.length >= 2) {
        // Use coordinates if available
        // PickupCoordinates stores coordinates as [longitude, latitude] in GeoJSON format
        final double destinationLat = 30.040507715914405; // latitude
        final double destinationLng = 31.365755001495806; // longitude

        googleMapsUrl =
            'https://www.google.com/maps/dir/?api=1&origin=${currentPosition.latitude},${currentPosition.longitude}&destination=$destinationLat,$destinationLng&travelmode=driving';
      } else if (tripDetails?.destinationAddress != null &&
          tripDetails!.destinationAddress!.isNotEmpty) {
        // Use address if coordinates are not available
        final String encodedAddress = Uri.encodeComponent(
          tripDetails.destinationAddress!,
        );
        googleMapsUrl =
            'https://www.google.com/maps/dir/?api=1&origin=${currentPosition.latitude},${currentPosition.longitude}&destination=$encodedAddress&travelmode=driving';
      } else {
        Get.snackbar(
          'No Destination',
          'Destination location not available',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Launch Google Maps
      final Uri uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open Google Maps',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error opening Google Maps: $e');
      Get.snackbar(
        'Error',
        'Failed to open Google Maps: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController) {
        return GetBuilder<ParcelController>(
          builder: (parcelController) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              child:
                  isSearching
                      ? Column(
                        children: [
                          TollTipWidget(
                            title:
                                rideController.selectedCategory ==
                                        RideType.parcel
                                    ? 'deliveryman'
                                    : 'rider_finding',
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.27,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey.withOpacity(.50),
                                  color: Theme.of(context).primaryColor,
                                  value: rideController.firstCount,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.27,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey.withOpacity(.50),
                                  color: Theme.of(context).primaryColor,
                                  value: rideController.secondCount,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.27,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey.withOpacity(.50),
                                  color: Theme.of(context).primaryColor,
                                  value: rideController.thirdCount,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeDefault,
                            ),
                            child: Image.asset(
                              Images.newBidFareIcon,
                              width: 70,
                              color: Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.scrim.withOpacity(0.2),
                              colorBlendMode: BlendMode.modulate,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _openGoogleMapsWithDirections,
                            child: Text('Open in Google Maps'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                            ),
                          ),
                          Text(
                            widget.fromPage == FindingRide.parcel
                                ? 'finding_deliveryman'.tr
                                : rideController.stateCount == 0
                                ? 'searching_for_rider'.tr
                                : rideController.stateCount == 1
                                ? 'please_wait_just_for_a_moment'.tr
                                : rideController.stateCount == 2
                                ? 'looks_like_riders_around_you_are_busy_now'.tr
                                : 'looks_like_riders_around_you_are_not_interested'
                                    .tr,
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          (rideController.stateCount == 2 ||
                                  widget.fromPage == FindingRide.parcel)
                              ? Text(
                                'please_hold_on_a_little_more'.tr,
                                style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              )
                              : const SizedBox(),
                          if (rideController.stateCount != 3 &&
                              widget.fromPage == FindingRide.ride)
                            const SizedBox(
                              height: Dimensions.paddingSizeLarge * 2,
                            ),
                          if (rideController.stateCount == 3 &&
                              widget.fromPage == FindingRide.ride) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeDefault,
                                horizontal:
                                    Dimensions.paddingSizeExtraOverLarge,
                              ),
                              child: ButtonWidget(
                                buttonText: 'keep_searching'.tr,
                                onPressed: () {
                                  widget.expandableKey.currentState?.contract();
                                  rideController.initCountingTimeStates(
                                    isRestart: true,
                                  );
                                },
                                backgroundColor: Colors.grey.withOpacity(0.25),
                                radius: 10,
                                textColor:
                                    Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     left: Dimensions.paddingSizeExtraOverLarge ,
                            //     right: Dimensions.paddingSizeExtraOverLarge ,
                            //     bottom: Dimensions.paddingSizeDefault,
                            //   ),
                            //   child: ButtonWidget(
                            //     buttonText: 'rise_fare'.tr,
                            //     onPressed: (){
                            //      // widget.expandableKey.currentState?.contract();
                            //       rideController.updateRideCurrentState(RideState.riseFare);
                            //     },
                            //     radius: 10,
                            //   ),
                            // ),
                          ],
                          if (widget.fromPage == FindingRide.parcel)
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                          !(rideController.stateCount == 3 &&
                                  widget.fromPage == FindingRide.ride)
                              ? Center(
                                child: SliderButton(
                                  action: () {
                                    isSearching = false;
                                    widget.expandableKey.currentState?.expand();
                                    setState(() {});
                                  },
                                  label: Text(
                                    'cancel_searching'.tr,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  dismissThresholds: 0.5,
                                  dismissible: false,
                                  shimmer: false,
                                  width: 1170,
                                  height: 40,
                                  buttonSize: 40,
                                  radius: 20,
                                  icon: Center(
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Get.find<LocalizationController>()
                                                  .isLtr
                                              ? Icons.arrow_forward_ios_rounded
                                              : Icons.keyboard_arrow_left,
                                          color: Colors.grey,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  isLtr:
                                      Get.find<LocalizationController>().isLtr,
                                  boxShadow: const BoxShadow(blurRadius: 0),
                                  buttonColor: Colors.transparent,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.15),
                                  baseColor: Theme.of(context).primaryColor,
                                ),
                              )
                              : const SizedBox(),
                        ],
                      )
                      : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeDefault,
                            ),
                            child: Image.asset(
                              Images.cancelRideIcon,
                              width: 70,
                              color:
                                  Theme.of(
                                    context,
                                  ).buttonTheme.colorScheme!.scrim,
                            ),
                          ),
                          Text(
                            'are_you_sure'.tr,
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge,
                            ),
                          ),
                          Text(
                            'you_want_to_cancel_searching'.tr,
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          rideController.isLoading
                              ? const Padding(
                                padding: EdgeInsets.all(
                                  Dimensions.paddingSizeDefault,
                                ),
                                child: CircularProgressIndicator(),
                              )
                              : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: Dimensions.paddingSizeDefault,
                                      horizontal:
                                          Dimensions.paddingSizeExtraOverLarge,
                                    ),
                                    child: ButtonWidget(
                                      buttonText: 'keep_searching'.tr,
                                      onPressed: () {
                                        widget.expandableKey.currentState
                                            ?.contract();
                                        isSearching = true;
                                        setState(() {});
                                        rideController.initCountingTimeStates(
                                          isRestart: true,
                                        );
                                      },
                                      backgroundColor: Colors.grey.withOpacity(
                                        0.25,
                                      ),
                                      radius: 10,
                                      textColor:
                                          Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left:
                                          Dimensions.paddingSizeExtraOverLarge,
                                      right:
                                          Dimensions.paddingSizeExtraOverLarge,
                                      bottom: Dimensions.paddingSizeDefault,
                                    ),
                                    child: ButtonWidget(
                                      buttonText: 'cancel_searching'.tr,
                                      onPressed: () {
                                        //  widget.expandableKey.currentState?.contract();
                                        print(
                                          "======== ${rideController.tripDetails?.id}",
                                        );

                                        // Get the trip ID safely
                                        String? tripId =
                                            rideController.tripDetails?.id;

                                        if (tripId == null) {
                                          Get.snackbar(
                                            'Error',
                                            'No trip ID found',
                                          );
                                          return;
                                        }

                                        rideController
                                            .tripStatusUpdate(
                                              tripId,
                                              'cancelled',
                                              'ride_request_cancelled_successfully',
                                              '',
                                            )
                                            .then((value) {
                                              if (value.statusCode == 200) {
                                                rideController
                                                    .updateRideCurrentState(
                                                      RideState.initial,
                                                    );
                                                Get.find<MapController>()
                                                    .notifyMapController();
                                                Get.find<RideController>()
                                                    .clearRideDetails();
                                                Get.find<BottomMenuController>()
                                                    .navigateToDashboard();
                                              }
                                            });
                                      },
                                      radius: 10,
                                    ),
                                  ),
                                ],
                              ),
                          if (rideController.isLoading)
                            const SizedBox(
                              height: Dimensions.paddingSizeSignUp,
                            ),
                        ],
                      ),
            );
          },
        );
      },
    );
  }
}
