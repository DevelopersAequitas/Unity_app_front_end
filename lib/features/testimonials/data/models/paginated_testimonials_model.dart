import '../../domain/entities/paginated_testimonials_entity.dart';
import 'testimonial_model.dart';
import 'testimonial_pagination_model.dart';

class PaginatedTestimonialsModel extends PaginatedTestimonialsEntity {
  const PaginatedTestimonialsModel({
    super.items = const [],
    super.pagination = const TestimonialPaginationModel(),
  });

  factory PaginatedTestimonialsModel.fromJson(dynamic data) {
    List<TestimonialModel> items = [];
    TestimonialPaginationModel pagination = const TestimonialPaginationModel();

    if (data is Map<String, dynamic>) {
      final innerData = data['data'];
      if (innerData is Map<String, dynamic>) {
        if (innerData['testimonials'] is List) {
          items = (innerData['testimonials'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => TestimonialModel.fromJson(m))
              .toList();
        } else if (innerData['items'] is List) {
          items = (innerData['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => TestimonialModel.fromJson(m))
              .toList();
        }

        if (innerData['pagination'] is Map<String, dynamic>) {
          pagination = TestimonialPaginationModel.fromJson(
              innerData['pagination'] as Map<String, dynamic>);
        }
      } else if (innerData is List) {
        items = innerData
            .whereType<Map<String, dynamic>>()
            .map((m) => TestimonialModel.fromJson(m))
            .toList();
      }

      if (data['pagination'] is Map<String, dynamic>) {
        pagination = TestimonialPaginationModel.fromJson(
            data['pagination'] as Map<String, dynamic>);
      }
    } else if (data is List) {
      items = data
          .whereType<Map<String, dynamic>>()
          .map((m) => TestimonialModel.fromJson(m))
          .toList();
    }

    if (pagination.total == 0 && items.isNotEmpty) {
      pagination = TestimonialPaginationModel(
        currentPage: 1,
        lastPage: 1,
        perPage: items.length,
        total: items.length,
      );
    }

    return PaginatedTestimonialsModel(
      items: items,
      pagination: pagination,
    );
  }
}
