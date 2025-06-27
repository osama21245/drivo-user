import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/choose_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/from_to_text_arrow_icon_widget.dart';
import 'package:ride_sharing_user_app/features/details_tripe/screens/details_trips_screen.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_details_text_widgets.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_list_view_widget.dart';
import 'package:ride_sharing_user_app/features/search_trips/widgets/search_tripe_search_date_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SearchTripsScreen extends StatefulWidget {
  const SearchTripsScreen({super.key});

  @override
  State<SearchTripsScreen> createState() => _SearchTripsScreenState();
}

// Simulated data for available trips
List<Map<String, dynamic>> availableTrips = [
  {
    'driverName': 'أحمد محمد',
    'driverImage': Images.userIcon,
    'rating': 4.8,
    'price': 45.0,
    'currency': 'جنيه',
    'carModel': 'تويوتا كامري 2022',
    'carColor': 'أبيض',
    'departureTime': '08:30 ص',
    'arrivalTime': '09:15 ص',
    'availableSeats': 3,
    'totalSeats': 4,
    'pickupLocation': 'مدينة نصر',
    'dropoffLocation': 'وسط البلد',
    'distance': '15 كم',
    'duration': '45 دقيقة',
    'isVerified': true,
  },
  {
    'driverName': 'سارة أحمد',
    'driverImage': Images.userIcon,
    'rating': 4.9,
    'price': 50.0,
    'currency': 'جنيه',
    'carModel': 'هوندا سيفيك 2021',
    'carColor': 'أزرق',
    'departureTime': '09:00 ص',
    'arrivalTime': '09:45 ص',
    'availableSeats': 2,
    'totalSeats': 4,
    'pickupLocation': 'مدينة نصر',
    'dropoffLocation': 'وسط البلد',
    'distance': '15 كم',
    'duration': '45 دقيقة',
    'isVerified': true,
  },
  {
    'driverName': 'محمد علي',
    'driverImage': Images.userIcon,
    'rating': 4.7,
    'price': 40.0,
    'currency': 'جنيه',
    'carModel': 'نيسان صني 2020',
    'carColor': 'أحمر',
    'departureTime': '10:00 ص',
    'arrivalTime': '10:45 ص',
    'availableSeats': 4,
    'totalSeats': 4,
    'pickupLocation': 'مدينة نصر',
    'dropoffLocation': 'وسط البلد',
    'distance': '15 كم',
    'duration': '45 دقيقة',
    'isVerified': false,
  },
];

List<String> sortOptions = ['الأرخص', 'الأسرع', 'الأقرب', 'الأعلى تقييماً'];

class _SearchTripsScreenState extends State<SearchTripsScreen> {
  String selectedSort = 'الأرخص';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            // Route summary card
            Container(
              width: double.infinity,
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
                children: [
                  // From-To locations
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          Images.currentLocation,
                          height: 16,
                          width: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Text(
                          'مدينة نصر',
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Get.isDarkMode
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).hintColor,
                        size: 20,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          Images.activityDirection,
                          height: 16,
                          width: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Text(
                          'وسط البلد',
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Get.isDarkMode
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  // Date and time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).hintColor,
                        size: 16,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        'اليوم، 15 يناير 2025',
                        style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        color: Theme.of(context).hintColor,
                        size: 16,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        '08:00 ص',
                        style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Sort options
            Row(
              children: [
                Text(
                  'ترتيب حسب:',
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Get.isDarkMode
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(
                        color: Theme.of(context).hintColor.withOpacity(0.3),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSort,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).hintColor,
                        ),
                        items: sortOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSort = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Results count
            Row(
              children: [
                Text(
                  'تم العثور على ${availableTrips.length} رحلة',
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Get.isDarkMode
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.filter_list,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  'فلترة',
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Trips list
            Expanded(
              child: ListView.builder(
                itemCount: availableTrips.length,
                itemBuilder: (context, index) {
                  final trip = availableTrips[index];
                  return _buildTripCard(context, trip);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip) {
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
        children: [
          // Driver info and price
          Row(
            children: [
              // Driver avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(trip['driverImage']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              // Driver name and rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          trip['driverName'],
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Get.isDarkMode
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        if (trip['isVerified']) ...[
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trip['rating'].toString(),
                          style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${trip['price']} ${trip['currency']}',
                    style: textBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'للشخص',
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Trip details
          Row(
            children: [
              // Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['departureTime'],
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Get.isDarkMode
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    Text(
                      trip['pickupLocation'],
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow and duration
              Column(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).hintColor,
                    size: 20,
                  ),
                  Text(
                    trip['duration'],
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              // Arrival
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      trip['arrivalTime'],
                      style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Get.isDarkMode
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    Text(
                      trip['dropoffLocation'],
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Car info and available seats
          Row(
            children: [
              Icon(
                Icons.directions_car,
                color: Theme.of(context).hintColor,
                size: 20,
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                '${trip['carModel']} - ${trip['carColor']}',
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.people,
                color: Theme.of(context).hintColor,
                size: 20,
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                '${trip['availableSeats']}/${trip['totalSeats']} مقاعد متاحة',
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Book button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to trip details
                Get.to(() => DetailsTripScreen(
                      isMyTrip: false,
                      tripData: trip,
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              child: Text(
                'احجز الآن',
                style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
