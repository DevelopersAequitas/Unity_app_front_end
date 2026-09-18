import 'package:equatable/equatable.dart';

abstract class LifeImpactEvent extends Equatable {
  const LifeImpactEvent();

  @override
  List<Object?> get props => [];
}

class FetchLifeImpactHistoryEvent extends LifeImpactEvent {
  final bool isRefresh;
  const FetchLifeImpactHistoryEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class SubmitLifeImpactEvent extends LifeImpactEvent {
  final String title;
  final String description;
  final String category;
  final int impactPoints;

  const SubmitLifeImpactEvent({
    required this.title,
    required this.description,
    required this.category,
    required this.impactPoints,
  });

  @override
  List<Object?> get props => [title, description, category, impactPoints];
}
