import '../entities/create_testimonial_params.dart';
import '../entities/paginated_testimonials_entity.dart';
import '../entities/testimonial_entity.dart';
import '../entities/testimonial_leaderboard_entity.dart';

abstract class TestimonialsRepository {
  Future<PaginatedTestimonialsEntity> getUserTestimonials(
    String userId, {
    int page = 1,
    int perPage = 10,
  });
  Future<PaginatedTestimonialsEntity> getReceivedTestimonials({
    int page = 1,
    int perPage = 10,
  });
  Future<PaginatedTestimonialsEntity> getGivenTestimonials({
    int page = 1,
    int perPage = 10,
  });
  Future<TestimonialEntity> createTestimonial(CreateTestimonialParams params);
  Future<List<TestimonialLeaderboardEntity>> getTestimonialsLeaderboard({int limit = 50});
}

