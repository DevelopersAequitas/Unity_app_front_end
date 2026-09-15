import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';

abstract class CircleJoinEvent extends Equatable {
  const CircleJoinEvent();

  @override
  List<Object?> get props => [];
}

class CircleJoinSubcategoryUpdated extends CircleJoinEvent {
  final CircleCategoryEntity? subcategory;
  final bool isOther;

  const CircleJoinSubcategoryUpdated({
    this.subcategory,
    this.isOther = false,
  });

  @override
  List<Object?> get props => [subcategory, isOther];
}

class CircleJoinSubmitted extends CircleJoinEvent {
  final String circleId;
  final String reason;
  final String? defaultSectorId;
  final String? customCategoryName;

  const CircleJoinSubmitted({
    required this.circleId,
    required this.reason,
    this.defaultSectorId,
    this.customCategoryName,
  });

  @override
  List<Object?> get props => [
        circleId,
        reason,
        defaultSectorId,
        customCategoryName,
      ];
}
