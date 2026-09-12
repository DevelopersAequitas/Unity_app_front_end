import 'package:equatable/equatable.dart';

class BusinessCategoryEntity extends Equatable {
  final int id;
  final String name;
  final List<BusinessCategoryEntity> subCategories;

  const BusinessCategoryEntity({
    required this.id,
    required this.name,
    this.subCategories = const [],
  });

  @override
  List<Object?> get props => [id, name, subCategories];
}
