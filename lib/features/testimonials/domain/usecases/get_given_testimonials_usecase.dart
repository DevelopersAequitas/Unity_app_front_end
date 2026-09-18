import '../entities/paginated_testimonials_entity.dart';
import '../repositories/testimonials_repository.dart';

class GetGivenTestimonialsUseCase {
  final TestimonialsRepository repository;

  const GetGivenTestimonialsUseCase(this.repository);

  Future<PaginatedTestimonialsEntity> call({
    int page = 1,
    int perPage = 10,
  }) {
    return repository.getGivenTestimonials(
      page: page,
      perPage: perPage,
    );
  }
}
