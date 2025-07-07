import 'driver_model.dart';
import 'vehicle_model.dart';
import 'match_point_model.dart';

class PoolRide {
  final int routeId;
  final Driver driver;
  final Vehicle vehicle;
  final String category;
  final String startTime;
  final int seatsAvailable;
  final bool isAc;
  final bool isSmokingAllowed;
  final MatchPoint pickupMatchPoint;
  final MatchPoint dropoffMatchPoint;
  final String pickupAddress;
  final String dropoffAddress;
  final int price;
  final bool hasMusic;
  final bool hasScreenEntertainment;
  final bool allowLuggage;
  final String allowedGender;
  final int allowedAgeMin;
  final int allowedAgeMax;

  PoolRide({
    required this.routeId,
    required this.driver,
    required this.vehicle,
    required this.category,
    required this.startTime,
    required this.seatsAvailable,
    required this.isAc,
    required this.isSmokingAllowed,
    required this.pickupMatchPoint,
    required this.dropoffMatchPoint,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.price,
    required this.hasMusic,
    required this.hasScreenEntertainment,
    required this.allowLuggage,
    required this.allowedGender,
    required this.allowedAgeMin,
    required this.allowedAgeMax,
  });

  factory PoolRide.fromJson(Map<String, dynamic> json) {
    return PoolRide(
      routeId: json['route_id'] ?? 0,
      driver: Driver.fromJson(json['driver'] ?? {}),
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      category: json['category'] ?? '',
      startTime: json['start_time'] ?? '',
      seatsAvailable: json['seats_available'] ?? 0,
      isAc: json['is_ac'] ?? false,
      isSmokingAllowed: json['is_smoking_allowed'] ?? false,
      pickupMatchPoint: MatchPoint.fromJson(json['pickup_match_point'] ?? {}),
      dropoffMatchPoint: MatchPoint.fromJson(json['dropoff_match_point'] ?? {}),
      pickupAddress: json['pickup_address'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
      price: json['price'] ?? 0,
      hasMusic: json['has_music'] ?? false,
      hasScreenEntertainment: json['has_screen_entertainment'] ?? false,
      allowLuggage: json['allow_luggage'] ?? false,
      allowedGender: json['allowed_gender'] ?? '',
      allowedAgeMin: json['allowed_age_min'] ?? 0,
      allowedAgeMax: json['allowed_age_max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route_id': routeId,
      'driver': driver.toJson(),
      'vehicle': vehicle.toJson(),
      'category': category,
      'start_time': startTime,
      'seats_available': seatsAvailable,
      'is_ac': isAc,
      'is_smoking_allowed': isSmokingAllowed,
      'pickup_match_point': pickupMatchPoint.toJson(),
      'dropoff_match_point': dropoffMatchPoint.toJson(),
      'pickup_address': pickupAddress,
      'dropoff_address': dropoffAddress,
      'price': price,
      'has_music': hasMusic,
      'has_screen_entertainment': hasScreenEntertainment,
      'allow_luggage': allowLuggage,
      'allowed_gender': allowedGender,
      'allowed_age_min': allowedAgeMin,
      'allowed_age_max': allowedAgeMax,
    };
  }
}
