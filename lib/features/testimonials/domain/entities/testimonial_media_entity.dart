import 'package:equatable/equatable.dart';

class TestimonialMediaEntity extends Equatable {
  final String id;
  final String type;
  final String? url;

  const TestimonialMediaEntity({
    required this.id,
    required this.type,
    this.url,
  });

  @override
  List<Object?> get props => [id, type, url];
}
