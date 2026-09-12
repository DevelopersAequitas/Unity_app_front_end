import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfileMediaUseCase {
  final ProfileRepository repository;

  UploadProfileMediaUseCase(this.repository);

  Future<String> call(File file, {void Function(double progress)? onProgress}) {
    return repository.uploadFile(file, onProgress: onProgress);
  }
}
