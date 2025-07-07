class MatchPoint {
  final double lat;
  final double lng;

  MatchPoint({
    required this.lat,
    required this.lng,
  });

  factory MatchPoint.fromJson(Map<String, dynamic> json) {
    return MatchPoint(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
