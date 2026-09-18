import '../entities/paginated_testimonials_entity.dart';
import '../repositories/testimonials_repository.dart';

class GetUserTestimonialsUseCase {
  final TestimonialsRepository repository;

  const GetUserTestimonialsUseCase(this.repository);

  Future<PaginatedTestimonialsEntity> call(
    String userId, {
    int page = 1,
    int perPage = 10,
  }) {
    return repository.getUserTestimonials(
      userId,
      page: page,
      perPage: perPage,
    );
  }
}
