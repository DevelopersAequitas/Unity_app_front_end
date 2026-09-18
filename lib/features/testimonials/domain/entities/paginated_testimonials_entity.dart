import 'package:equatable/equatable.dart';
import 'testimonial_entity.dart';
import 'testimonial_pagination_entity.dart';

class PaginatedTestimonialsEntity extends Equatable {
  final List<TestimonialEntity> items;
  final TestimonialPaginationEntity pagination;

  const PaginatedTestimonialsEntity({
    this.items = const [],
    this.pagination = const TestimonialPaginationEntity(),
  });

  @override
  List<Object?> get props => [items, pagination];
}
