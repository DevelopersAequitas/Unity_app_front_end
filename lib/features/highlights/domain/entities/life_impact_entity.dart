import 'package:equatable/equatable.dart';

class LifeImpactEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final int impactPoints;
  final String date;

  const LifeImpactEntity({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    this.impactPoints = 1,
    this.date = '',
  });

  @override
  List<Object?> get props => [id, title, description, category, impactPoints, date];
}
