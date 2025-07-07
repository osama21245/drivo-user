import 'pool_ride_model.dart';

class FindMatchResponse {
  final String responseCode;
  final String message;
  final int? totalSize;
  final int? limit;
  final int? offset;
  final List<PoolRide> data;
  final List<dynamic> errors;

  FindMatchResponse({
    required this.responseCode,
    required this.message,
    this.totalSize,
    this.limit,
    this.offset,
    required this.data,
    required this.errors,
  });

  factory FindMatchResponse.fromJson(Map<String, dynamic> json) {
    return FindMatchResponse(
      responseCode: json['response_code'] ?? '',
      message: json['message'] ?? '',
      totalSize: json['total_size'],
      limit: json['limit'],
      offset: json['offset'],
      data: (json['data'] as List? ?? [])
          .map((e) => PoolRide.fromJson(e))
          .toList(),
      errors: json['errors'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'message': message,
      'total_size': totalSize,
      'limit': limit,
      'offset': offset,
      'data': data.map((e) => e.toJson()).toList(),
      'errors': errors,
    };
  }
}
