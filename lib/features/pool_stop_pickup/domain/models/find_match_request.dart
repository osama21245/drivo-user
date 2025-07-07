class FindMatchRequest {
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String day;
  final String gender;
  final int seatsRequired;
  final String rideType;

  FindMatchRequest({
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.day,
    required this.gender,
    required this.seatsRequired,
    required this.rideType,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
      'day': day,
      'gender': gender,
      'seats_required': seatsRequired,
      'ride_type': rideType,
    };
  }
}
