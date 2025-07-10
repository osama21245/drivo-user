class MatchPoint {
  final double lat;
  final double lng;

  MatchPoint({
    required this.lat,
    required this.lng,
  });

  factory MatchPoint.fromJson(Map<String, dynamic> json) {
    try {
      return MatchPoint(
        lat: (json['lat'] ?? 0.0).toDouble(),
        lng: (json['lng'] ?? 0.0).toDouble(),
      );
    } catch (e) {
      print('Error parsing MatchPoint: $e');
      print('JSON data: $json');
      return MatchPoint(lat: 0.0, lng: 0.0);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
