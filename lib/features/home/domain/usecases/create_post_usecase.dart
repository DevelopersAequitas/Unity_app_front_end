import 'dart:io';
import '../repositories/home_repository.dart';

class CreatePostUseCase {
  final HomeRepository repository;

  const CreatePostUseCase(this.repository);

  Future<String> uploadFile(File file, {void Function(double progress)? onProgress}) {
    return repository.uploadFile(file, onProgress: onProgress);
  }

  Future<void> call({
    required String contentText,
    String visibility = 'public',
    List<Map<String, String>> media = const [],
    List<Map<String, dynamic>> mentions = const [],
  }) {
    return repository.createPost(
      contentText: contentText,
      visibility: visibility,
      media: media,
      mentions: mentions,
    );
  }
}
