import '../../domain/entities/testimonial_pagination_entity.dart';

class TestimonialPaginationModel extends TestimonialPaginationEntity {
  const TestimonialPaginationModel({
    super.currentPage = 1,
    super.lastPage = 1,
    super.perPage = 10,
    super.total = 0,
  });

  factory TestimonialPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TestimonialPaginationModel();
    return TestimonialPaginationModel(
      currentPage: int.tryParse(json['current_page']?.toString() ?? '') ?? 1,
      lastPage: int.tryParse(json['last_page']?.toString() ?? '') ?? 1,
      perPage: int.tryParse(json['per_page']?.toString() ?? '') ?? 10,
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
    );
  }
}
