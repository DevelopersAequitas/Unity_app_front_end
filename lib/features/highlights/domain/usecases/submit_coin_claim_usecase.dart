import 'dart:io';
import '../repositories/coins_repository.dart';

class SubmitCoinClaimParams {
  final String activityCode;
  final Map<String, dynamic> fields;
  final File? proofFile;

  const SubmitCoinClaimParams({
    required this.activityCode,
    required this.fields,
    this.proofFile,
  });
}

class SubmitCoinClaimUseCase {
  final CoinsRepository repository;
  const SubmitCoinClaimUseCase(this.repository);

  Future<Map<String, dynamic>> call(SubmitCoinClaimParams params) {
    return repository.submitCoinClaim(
      activityCode: params.activityCode,
      fields: params.fields,
      proofFile: params.proofFile,
    );
  }
}
