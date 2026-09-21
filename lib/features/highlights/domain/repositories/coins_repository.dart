import 'dart:io';
import '../entities/claim_activity_entity.dart';
import '../entities/claim_coin_entity.dart';
import '../entities/coin_wallet_entity.dart';

abstract class CoinsRepository {
  Future<CoinWalletEntity> getCoinWalletData();
  Future<List<ClaimActivityEntity>> getCoinClaimActivities();
  Future<Map<String, dynamic>> submitCoinClaim({
    required String activityCode,
    required Map<String, dynamic> fields,
    File? proofFile,
  });
  Future<List<ClaimCoinEntity>> getMyCoinClaims({String? status});
  Future<String> uploadProofFile(File file);
}
