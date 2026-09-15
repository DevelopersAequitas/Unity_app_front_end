import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_category_entity.dart';

abstract class CircleSubcategoriesEvent extends Equatable {
  const CircleSubcategoriesEvent();

  @override
  List<Object?> get props => [];
}

class CircleSubcategoriesFetchRequested extends CircleSubcategoriesEvent {
  final String circleId;
  const CircleSubcategoriesFetchRequested(this.circleId);

  @override
  List<Object?> get props => [circleId];
}

class CircleSubcategoriesSearchChanged extends CircleSubcategoriesEvent {
  final String query;
  const CircleSubcategoriesSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CircleSubcategorySelected extends CircleSubcategoriesEvent {
  final CircleCategoryEntity? subcategory;
  final bool isOther;

  const CircleSubcategorySelected({
    this.subcategory,
    this.isOther = false,
  });

  @override
  List<Object?> get props => [subcategory, isOther];
}
