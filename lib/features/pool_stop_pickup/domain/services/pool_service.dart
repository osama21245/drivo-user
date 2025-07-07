import 'package:get/get.dart';
import '../interfaces/pool_interface.dart';
import '../models/find_match_request.dart';
import '../models/find_match_response.dart';
import '../models/join_request.dart';

class PoolService {
  final PoolInterface poolRepository;

  PoolService({required this.poolRepository});

  Future<FindMatchResponse?> findMatchingRides(FindMatchRequest request) async {
    try {
      Response response = await poolRepository.findMatchingRides(request);

      if (response.statusCode == 200) {
        return FindMatchResponse.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error in PoolService.findMatchingRides: $e');
      return null;
    }
  }

  Future<bool> joinRide(JoinRequest request) async {
    try {
      Response response = await poolRepository.joinRide(request);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error in PoolService.joinRide: $e');
      return false;
    }
  }
}
