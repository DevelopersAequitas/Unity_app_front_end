import '../entities/testimonial_leaderboard_entity.dart';
import '../repositories/testimonials_repository.dart';

class GetTestimonialsLeaderboardUseCase {
  final TestimonialsRepository repository;
  const GetTestimonialsLeaderboardUseCase(this.repository);

  Future<List<TestimonialLeaderboardEntity>> call({int limit = 50}) =>
      repository.getTestimonialsLeaderboard(limit: limit);
}
