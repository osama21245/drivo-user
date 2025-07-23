import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widget/accepting_ongoing_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/initial_widget.dart';
import 'package:ride_sharing_user_app/features/map/widget/otp_sent_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/map/widget/risefare_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/finding_rider_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/confirmation_trip_dialog.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/services/pool_service.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/find_match_request.dart';
import 'package:ride_sharing_user_app/features/pool_stop_pickup/domain/models/find_match_response.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';

class RideExpendableBottomSheet extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  final bool isCarpool;
  const RideExpendableBottomSheet(
      {super.key, required this.expandableKey, required this.isCarpool});

  @override
  State<RideExpendableBottomSheet> createState() =>
      _RideExpendableBottomSheetState();
}

class _RideExpendableBottomSheetState extends State<RideExpendableBottomSheet> {
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (carRideController) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.paddingSizeDefault),
            topRight: Radius.circular(Dimensions.paddingSizeDefault),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).hintColor,
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  height: 7,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  )),
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeSmall,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ),
              GetBuilder<RideController>(builder: (rideController) {
                return GetBuilder<LocationController>(
                    builder: (locationController) {
                  String firstRoute = '';
                  String secondRoute = '';
                  List<dynamic> extraRoute = [];
                  if (rideController.tripDetails?.intermediateAddresses !=
                          null &&
                      rideController.tripDetails?.intermediateAddresses !=
                          '["",""]') {
                    extraRoute = jsonDecode(
                        rideController.tripDetails!.intermediateAddresses!);
                    if (extraRoute.isNotEmpty) {
                      firstRoute = extraRoute[0].toString();
                    }
                    if (extraRoute.isNotEmpty && extraRoute.length > 1) {
                      secondRoute = extraRoute[1].toString();
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      (rideController.currentRideState == RideState.initial)
                          ? (widget.isCarpool
                              ? _buildCarpoolInitialWidget(locationController)
                              : Column(
                                  children: [
                                    // Vehicle selection row
                                    if (rideController.fareList.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          'Estimated Fare:  ' +
                                              PriceConverter.convertPrice(
                                                  rideController.estimatedFare),
                                          style: textBold.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    // The rest of the initial widget
                                    InitialWidget(
                                        expandableKey: widget.expandableKey),
                                  ],
                                ))
                          : (rideController.currentRideState ==
                                  RideState.riseFare)
                              ? RaiseFareBottomSheet(
                                  expandableKey: widget.expandableKey)
                              : (rideController.currentRideState ==
                                      RideState.findingRider)
                                  ? FindingRiderWidget(
                                      expandableKey: widget.expandableKey,
                                      fromPage: FindingRide.ride)
                                  : (rideController.currentRideState ==
                                              RideState.acceptingRider ||
                                          rideController.currentRideState ==
                                              RideState.ongoingRide)
                                      ? AcceptingAndOngoingBottomSheet(
                                          firstRoute: firstRoute,
                                          secondRoute: secondRoute,
                                          expandableKey: widget.expandableKey,
                                        )
                                      : (rideController.currentRideState ==
                                              RideState.otpSent)
                                          ? OtpSentBottomSheet(
                                              firstRoute: firstRoute,
                                              secondRoute: secondRoute,
                                              expandableKey:
                                                  widget.expandableKey,
                                            )
                                          : (rideController.currentRideState ==
                                                  RideState.ongoingRide)
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return ConfirmationDialogWidget(
                                                            icon:
                                                                Images.endTrip,
                                                            description:
                                                                'end_this_trip_at_your_destination'
                                                                    .tr,
                                                            onYesPressed:
                                                                () async {
                                                              Get.back();
                                                              Get.dialog(
                                                                  const ConfirmationTripDialog(
                                                                      isStartedTrip:
                                                                          false),
                                                                  barrierDismissible:
                                                                      false);
                                                              await Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          5));
                                                              Get.find<
                                                                      RideController>()
                                                                  .stopLocationRecord();
                                                              rideController
                                                                  .updateRideCurrentState(
                                                                      RideState
                                                                          .completeRide);
                                                              Get.find<
                                                                      MapController>()
                                                                  .notifyMapController();
                                                              Get.off(() =>
                                                                  const PaymentScreen());
                                                            },
                                                          );
                                                        });
                                                  },
                                                  child: Column(children: [
                                                    TollTipWidget(
                                                        title: 'trip_is_ongoing'
                                                            .tr),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeDefault),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: Dimensions
                                                              .paddingSizeDefault),
                                                      child: Text.rich(TextSpan(
                                                        style: textRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color!
                                                                .withOpacity(
                                                                    0.8)),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "the_car_just_arrived_at"
                                                                    .tr,
                                                            style: textRegular
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeDefault),
                                                          ),
                                                          TextSpan(
                                                              text: " ".tr),
                                                          TextSpan(
                                                            text:
                                                                "your_destination"
                                                                    .tr,
                                                            style: textMedium
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeDefault,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                    const ActivityScreenRiderDetails(),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeDefault),
                                                  ]),
                                                )
                                              : const SizedBox(),
                    ]),
                  );
                });
              }),
            ])),
      );
    });
  }

  // Carpool UI Methods
  Widget _buildCarpoolInitialWidget(LocationController locationController) {
    return GetBuilder<RideController>(
      builder: (rideController) {
        // Initialize carpool addresses only once when widget builds
        if (!rideController.isCarpoolInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            rideController.initializeCarpoolFromLocationController();
          });
        }

        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.groups,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Text(
                      'Carpool Ride Setup',
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Location Summary
              _buildLocationSummary(locationController),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Search Parameters
              _buildSearchParameters(rideController),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Available Trips
              if (rideController.availableTrips.isNotEmpty) ...[
                rideController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildAvailableTrips(rideController),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],

              // Search Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: rideController.isSearchingTrips
                      ? null
                      : () => _searchForCarpoolRides(rideController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    elevation: 4,
                    shadowColor:
                        Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                  child: rideController.isSearchingTrips
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Searching for rides...',
                              style: textMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Search for Carpool Rides',
                              style: textBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationSummary(LocationController locationController) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.route,
                  size: 16, color: Theme.of(context).primaryColor),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                'Route Summary',
                style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          // Pickup location
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.green),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup',
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      locationController.fromAddress?.address ??
                          'Loading pickup location...',
                      style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Destination location
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.red),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destination',
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      locationController.toAddress?.address ??
                          'Loading destination...',
                      style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchParameters(RideController rideController) {
    return Column(
      children: [
        // Date Selection
        _buildParameterField(
          icon: Icons.calendar_today,
          label: 'select_date'.tr,
          value: rideController.selectedDate.isEmpty
              ? 'tap_to_select_date'.tr
              : rideController.selectedDate,
          onTap: () => _selectDate(rideController),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        // Gender and Seats Row
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                icon: Icons.person,
                label: 'gender_preference'.tr,
                value: rideController.selectedGender,
                items: ['both', 'male', 'female'],
                onChanged: (value) {
                  rideController.setCarpoolSearchParameters(gender: value);
                },
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Expanded(
              child: _buildDropdownField(
                icon: Icons.people,
                label: 'seats_needed'.tr,
                value: rideController.selectedSeats.toString(),
                items: ['1', '2', '3'],
                onChanged: (value) {
                  rideController.setCarpoolSearchParameters(
                      seats: int.parse(value!));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        // Ride Type
        _buildDropdownField(
          icon: Icons.work,
          label: 'ride_type'.tr,
          value: rideController.selectedRideType,
          items: ['work', 'leisure', 'shopping', 'other'],
          onChanged: (value) {
            rideController.setCarpoolSearchParameters(rideType: value);
          },
        ),
      ],
    );
  }

  Widget _buildAvailableTrips(RideController rideController) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Rides (${rideController.availableTrips.length})',
            style: textBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          ...rideController.availableTrips
              .map((trip) => _buildTripCard(trip, rideController))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTripCard(dynamic trip, RideController rideController) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver: ${trip.driver.fullName ?? 'Unknown'}',
                  style:
                      textMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(height: 2),
                Text(
                  'Price: \$${trip.price.toString()}',
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _selectTrip(trip, rideController),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
            child: Text(
              'Join',
              style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterField({
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
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: Colors.white),
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
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
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
        border: Border.all(color: Colors.grey[300]!, width: 1),
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
                child: Icon(icon, size: 12, color: Colors.white),
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

  void _selectDate(RideController rideController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      String formattedDate =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      rideController.setCarpoolSearchParameters(date: formattedDate);
    }
  }

  Future<void> _searchForCarpoolRides(RideController rideController) async {
    if (rideController.pickupAddress == null ||
        rideController.destinationAddress == null) {
      Get.snackbar(
          'Error', 'Please select both pickup and destination locations');
      return;
    }

    if (rideController.selectedDate.isEmpty) {
      Get.snackbar('Error', 'Please select a date');
      return;
    }

    // Set searching state
    rideController.setSearchingTrips(true);

    try {
      // Create the request object
      FindMatchRequest request = FindMatchRequest(
        pickupLat: rideController.pickupAddress!.latitude!,
        pickupLng: rideController.pickupAddress!.longitude!,
        dropoffLat: rideController.destinationAddress!.latitude!,
        dropoffLng: rideController.destinationAddress!.longitude!,
        day: rideController.selectedDate,
        gender: rideController.selectedGender,
        seatsRequired: rideController.selectedSeats,
        rideType: rideController.selectedRideType,
      );

      // Make the API call using RideController's poolService
      FindMatchResponse? response =
          await rideController.poolService.findMatchingRides(request);

      // Process the response
      if (response != null && response.responseCode == 'default_200') {
        // Clear previous results
        rideController.availableTrips.clear();
        rideController.availableTrips.addAll(response.data);
        rideController.update();

        if (rideController.availableTrips.isEmpty) {
          Get.snackbar('No Rides Found', 'Try different route or date');
        } else {
          print(
              'Found ${rideController.availableTrips.length} rides successfully');
        }
      } else {
        rideController.availableTrips.clear();
        rideController.update();
        Get.snackbar(
            'Error', response?.message ?? 'Failed to search for trips');
      }
    } catch (e) {
      rideController.availableTrips.clear();
      rideController.update();
      Get.snackbar('Error', 'Failed to search for trips: ${e.toString()}');
    } finally {
      rideController.setSearchingTrips(false);
    }
  }

  void _selectTrip(dynamic trip, RideController rideController) {
    rideController.selectCarpoolTrip(trip);

    Get.snackbar(
      'Trip Selected',
      'You have selected a carpool trip. Proceeding with ride request...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Here you can add logic to submit the ride request with the selected trip
    // For example, call a method to submit the carpool ride request
  }
}
