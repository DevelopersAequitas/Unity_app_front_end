import '../../domain/entities/create_testimonial_params.dart';
import '../../domain/entities/paginated_testimonials_entity.dart';
import '../../domain/entities/testimonial_entity.dart';
import '../../domain/entities/testimonial_leaderboard_entity.dart';
import '../../domain/repositories/testimonials_repository.dart';
import '../datasources/testimonials_remote_datasource.dart';

class TestimonialsRepositoryImpl implements TestimonialsRepository {
  final TestimonialsRemoteDataSource remoteDataSource;

  TestimonialsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedTestimonialsEntity> getUserTestimonials(
    String userId, {
    int page = 1,
    int perPage = 10,
  }) {
    return remoteDataSource.getUserTestimonials(
      userId,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<PaginatedTestimonialsEntity> getReceivedTestimonials({
    int page = 1,
    int perPage = 10,
  }) {
    return remoteDataSource.getReceivedTestimonials(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<PaginatedTestimonialsEntity> getGivenTestimonials({
    int page = 1,
    int perPage = 10,
  }) {
    return remoteDataSource.getGivenTestimonials(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<TestimonialEntity> createTestimonial(CreateTestimonialParams params) {
    return remoteDataSource.createTestimonial(params);
  }

  @override
  Future<List<TestimonialLeaderboardEntity>> getTestimonialsLeaderboard({int limit = 50}) async {
    final models = await remoteDataSource.getTestimonialsLeaderboard(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
}

