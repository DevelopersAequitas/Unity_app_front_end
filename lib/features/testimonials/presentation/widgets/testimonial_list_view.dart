import 'package:flutter/material.dart';
import '../../domain/entities/testimonial_entity.dart';
import 'testimonial_card.dart';

class TestimonialListView extends StatelessWidget {
  final List<TestimonialEntity> testimonials;
  final RefreshCallback onRefresh;
  final String tabType;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const TestimonialListView({
    super.key,
    required this.testimonials,
    required this.onRefresh,
    this.tabType = 'received',
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final extraItem = isLoadingMore ? 1 : 0;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
        itemCount: testimonials.length + extraItem,
        itemBuilder: (context, index) {
          if (index < testimonials.length) {
            return TestimonialCard(
              testimonial: testimonials[index],
              tabType: tabType,
            );
          }
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
