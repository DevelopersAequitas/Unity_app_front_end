import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/coin_wallet_model.dart';

abstract class CoinsRemoteDataSource {
  Future<CoinWalletModel> getCoinWalletData();
}

class CoinsRemoteDataSourceImpl implements CoinsRemoteDataSource {
  final DioClient dioClient;
  const CoinsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CoinWalletModel> getCoinWalletData() async {
    final historyResponse = await dioClient.dio.get(ApiEndpoints.coinsHistory);
    final data = historyResponse.data['data'];

    List<CoinTransactionModel> txList = [];
    int balance = 0;

    if (data is Map<String, dynamic>) {
      balance = (data['balance'] ?? data['coins_balance'] ?? data['total_coins'] ?? 0) as int;
      if (data['items'] is List) {
        txList = (data['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => CoinTransactionModel.fromJson(e))
            .toList();
      }
    } else if (data is List) {
      txList = data
          .whereType<Map<String, dynamic>>()
          .map((e) => CoinTransactionModel.fromJson(e))
          .toList();
    }

    if (balance == 0 && txList.isNotEmpty) {
      balance = txList.fold<int>(0, (sum, item) => sum + item.amount);
    }

    List<BadgeMilestoneModel> badges = [];
    try {
      final milestoneResponse = await dioClient.dio.get(ApiEndpoints.milestones);
      final mData = milestoneResponse.data['data'];
      if (mData is List) {
        badges = mData
            .whereType<Map<String, dynamic>>()
            .map((e) => BadgeMilestoneModel.fromJson(e))
            .toList();
      }
    } catch (_) {}

    return CoinWalletModel(
      balance: balance,
      transactions: txList,
      badges: badges,
    );
  }
}
