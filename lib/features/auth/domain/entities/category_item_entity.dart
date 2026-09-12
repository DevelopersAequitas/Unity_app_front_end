import 'package:equatable/equatable.dart';

class CategoryItemEntity extends Equatable {
  final dynamic id;
  final String name;
  final int level;
  final dynamic parentId;
  final bool isOther;
  final String? slug;

  const CategoryItemEntity({
    required this.id,
    required this.name,
    this.level = 1,
    this.parentId,
    this.isOther = false,
    this.slug,
  });

  @override
  List<Object?> get props => [id, name, level, parentId, isOther, slug];
}
