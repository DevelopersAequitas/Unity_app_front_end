import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/coin_guidelines_model.dart';
import '../models/impact_guidelines_model.dart';
import '../models/leaderboard_model.dart';

abstract class LeaderboardRemoteDataSource {
  Future<LeaderboardModel> getCoinsLeaderboard();
  Future<LeaderboardModel> getImpactsLeaderboard();
  Future<CoinGuidelinesModel> getCoinGuidelines();
  Future<ImpactGuidelinesModel> getImpactGuidelines();
  dynamic get lastRawLeaderboardData;
  dynamic get lastRawImpactsLeaderboardData;
  dynamic get lastRawCoinGuidelinesData;
  dynamic get lastRawImpactGuidelinesData;
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final DioClient dioClient;
  dynamic _lastRawLeaderboardData;
  dynamic _lastRawImpactsLeaderboardData;
  dynamic _lastRawCoinGuidelinesData;
  dynamic _lastRawImpactGuidelinesData;

  LeaderboardRemoteDataSourceImpl({required this.dioClient});

  @override
  dynamic get lastRawLeaderboardData => _lastRawLeaderboardData;

  @override
  dynamic get lastRawImpactsLeaderboardData => _lastRawImpactsLeaderboardData;

  @override
  dynamic get lastRawCoinGuidelinesData => _lastRawCoinGuidelinesData;

  @override
  dynamic get lastRawImpactGuidelinesData => _lastRawImpactGuidelinesData;

  @override
  Future<LeaderboardModel> getCoinsLeaderboard() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.leaderboardCoins);
      _lastRawLeaderboardData = response.data;
      return LeaderboardModel.fromJson(response.data);
    } catch (_) {
      try {
        final response = await dioClient.dio.get('/leaderboard/coins');
        _lastRawLeaderboardData = response.data;
        return LeaderboardModel.fromJson(response.data);
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<LeaderboardModel> getImpactsLeaderboard() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.leaderboardImpacts);
      _lastRawImpactsLeaderboardData = response.data;
      return LeaderboardModel.fromJson(response.data);
    } catch (_) {
      try {
        final response = await dioClient.dio.get('/leaderboard/impacts');
        _lastRawImpactsLeaderboardData = response.data;
        return LeaderboardModel.fromJson(response.data);
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<CoinGuidelinesModel> getCoinGuidelines() async {
    final response = await dioClient.dio.get(ApiEndpoints.coinGuidelines);
    _lastRawCoinGuidelinesData = response.data;
    return CoinGuidelinesModel.fromJson(response.data);
  }

  @override
  Future<ImpactGuidelinesModel> getImpactGuidelines() async {
    final response = await dioClient.dio.get(ApiEndpoints.impactGuidelines);
    _lastRawImpactGuidelinesData = response.data;
    return ImpactGuidelinesModel.fromJson(response.data);
  }
}

