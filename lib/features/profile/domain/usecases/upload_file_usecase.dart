import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfileMediaUseCase {
  final ProfileRepository repository;

  UploadProfileMediaUseCase(this.repository);

  Future<String> call(File file) {
    return repository.uploadFile(file);
  }
}
