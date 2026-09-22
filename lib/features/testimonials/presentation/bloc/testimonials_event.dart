import 'package:equatable/equatable.dart';
import '../../domain/entities/testimonial_entity.dart';

enum TestimonialTab { leaderboard, received, given }

abstract class TestimonialsEvent extends Equatable {
  const TestimonialsEvent();

  @override
  List<Object?> get props => [];
}

class TestimonialsTabChanged extends TestimonialsEvent {
  final TestimonialTab tab;

  const TestimonialsTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class TestimonialsFetchLeaderboardRequested extends TestimonialsEvent {
  final bool forceRefresh;

  const TestimonialsFetchLeaderboardRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class TestimonialsFetchReceivedRequested extends TestimonialsEvent {
  final bool forceRefresh;

  const TestimonialsFetchReceivedRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class TestimonialsFetchGivenRequested extends TestimonialsEvent {
  final bool forceRefresh;

  const TestimonialsFetchGivenRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class TestimonialsFetchUserRequested extends TestimonialsEvent {
  final String userId;

  const TestimonialsFetchUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TestimonialCreatedLocally extends TestimonialsEvent {
  final TestimonialEntity testimonial;

  const TestimonialCreatedLocally(this.testimonial);

  @override
  List<Object?> get props => [testimonial];
}

class TestimonialsLoadMoreReceivedRequested extends TestimonialsEvent {
  const TestimonialsLoadMoreReceivedRequested();
}

class TestimonialsLoadMoreGivenRequested extends TestimonialsEvent {
  const TestimonialsLoadMoreGivenRequested();
}

class TestimonialsLoadMoreUserRequested extends TestimonialsEvent {
  final String userId;

  const TestimonialsLoadMoreUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TestimonialsSearchChanged extends TestimonialsEvent {
  final String query;

  const TestimonialsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
