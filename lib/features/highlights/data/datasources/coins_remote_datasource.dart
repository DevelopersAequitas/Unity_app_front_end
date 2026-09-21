import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/claim_activity_model.dart';
import '../models/claim_coin_model.dart';
import '../models/coin_wallet_model.dart';

abstract class CoinsRemoteDataSource {
  Future<CoinWalletModel> getCoinWalletData();
  Future<List<ClaimActivityModel>> getCoinClaimActivities();
  Future<Map<String, dynamic>> submitCoinClaim({
    required String activityCode,
    required Map<String, dynamic> fields,
    File? proofFile,
  });
  Future<List<ClaimCoinModel>> getMyCoinClaims({String? status});
  Future<String> uploadProofFile(File file);
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

  @override
  Future<List<ClaimActivityModel>> getCoinClaimActivities() async {
    final response = await dioClient.dio.get(ApiEndpoints.coinClaimActivities);
    final data = response.data['data'];

    if (data is Map<String, dynamic> && data['items'] is List) {
      return (data['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ClaimActivityModel.fromJson(e))
          .toList();
    } else if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => ClaimActivityModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<Map<String, dynamic>> submitCoinClaim({
    required String activityCode,
    required Map<String, dynamic> fields,
    File? proofFile,
  }) async {
    if (proofFile != null && await proofFile.exists()) {
      final fileName = proofFile.path.split(RegExp(r'[/\\]')).last;
      final map = <String, dynamic>{
        'activity_code': activityCode,
      };

      fields.forEach((k, v) {
        if (v != null) {
          map['fields[$k]'] = v.toString();
        }
      });

      final multipart = await MultipartFile.fromFile(
        proofFile.path,
        filename: fileName,
      );

      map['payment_proof_file'] = multipart;
      map['files[payment_proof_file]'] = multipart;

      final formData = FormData.fromMap(map);

      final response = await dioClient.dio.post(
        ApiEndpoints.coinClaims,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 3),
        ),
      );
      return response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : {};
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.coinClaims,
      data: {
        'activity_code': activityCode,
        'fields': fields,
      },
    );
    return response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : {};
  }

  @override
  Future<List<ClaimCoinModel>> getMyCoinClaims({String? status}) async {
    final url = status != null && status.isNotEmpty
        ? '${ApiEndpoints.myCoinClaims}?status=$status'
        : ApiEndpoints.myCoinClaims;

    final response = await dioClient.dio.get(url);
    final data = response.data['data'];

    if (data is Map<String, dynamic> && data['items'] is List) {
      return (data['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ClaimCoinModel.fromJson(e))
          .toList();
    } else if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => ClaimCoinModel.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<String> uploadProofFile(File file) async {
    final fileName = file.path.split(RegExp(r'[/\\]')).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dioClient.dio.post(
      ApiEndpoints.fileUpload,
      data: formData,
      options: Options(
        sendTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 3),
      ),
    );

    final resData = response.data;
    if (resData is Map<String, dynamic>) {
      final inner = resData['data'] is Map<String, dynamic> ? resData['data'] as Map<String, dynamic> : resData;
      final fileUrl = inner['url'] ?? inner['file_url'] ?? inner['path'] ?? inner['id']?.toString();
      if (fileUrl != null) return fileUrl.toString();
    }
    return '';
  }
}
