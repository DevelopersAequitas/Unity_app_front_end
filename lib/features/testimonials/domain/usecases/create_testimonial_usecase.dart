import '../entities/create_testimonial_params.dart';
import '../entities/testimonial_entity.dart';
import '../repositories/testimonials_repository.dart';

class CreateTestimonialUseCase {
  final TestimonialsRepository repository;

  const CreateTestimonialUseCase(this.repository);

  Future<TestimonialEntity> call(CreateTestimonialParams params) {
    return repository.createTestimonial(params);
  }
}
