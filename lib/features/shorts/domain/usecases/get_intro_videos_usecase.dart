import '../entities/intro_video_entity.dart';
import '../repositories/shorts_repository.dart';

class GetIntroVideosUseCase {
  final ShortsRepository repository;

  GetIntroVideosUseCase(this.repository);

  Future<List<IntroVideoEntity>> call({
    int page = 1,
    int perPage = 10,
  }) async {
    return await repository.getIntroVideos(
      page: page,
      perPage: perPage,
    );
  }
}
