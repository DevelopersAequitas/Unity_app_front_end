import 'dart:io';
import '../repositories/coins_repository.dart';

class UploadClaimProofUseCase {
  final CoinsRepository repository;
  const UploadClaimProofUseCase(this.repository);

  Future<String> call(File file) {
    return repository.uploadProofFile(file);
  }
}
