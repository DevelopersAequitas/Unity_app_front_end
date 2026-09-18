import '../entities/paginated_testimonials_entity.dart';
import '../repositories/testimonials_repository.dart';

class GetReceivedTestimonialsUseCase {
  final TestimonialsRepository repository;

  const GetReceivedTestimonialsUseCase(this.repository);

  Future<PaginatedTestimonialsEntity> call({
    int page = 1,
    int perPage = 10,
  }) {
    return repository.getReceivedTestimonials(
      page: page,
      perPage: perPage,
    );
  }
}
