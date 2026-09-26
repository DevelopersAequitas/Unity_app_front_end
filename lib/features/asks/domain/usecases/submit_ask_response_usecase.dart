import '../repositories/asks_repository.dart';

class SubmitAskResponseUseCase {
  final AsksRepository repository;

  SubmitAskResponseUseCase({required this.repository});

  Future<bool> execute({
    required String askId,
    required String responseType,
    required String message,
    required String timeline,
    Map<String, dynamic>? extraData,
  }) {
    return repository.submitAskResponse(
      askId: askId,
      responseType: responseType,
      message: message,
      timeline: timeline,
      extraData: extraData,
    );
  }
}
