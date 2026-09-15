import 'package:equatable/equatable.dart';

class CircleOpenCategoryEntity extends Equatable {
  final String id;
  final String name;
  final int level;
  final bool isClosed;
  final List<CircleOpenCategoryEntity> children;

  const CircleOpenCategoryEntity({
    required this.id,
    required this.name,
    this.level = 2,
    this.isClosed = false,
    this.children = const [],
  });

  /// Recursively counts all Level 4 (leaf) open categories under this category.
  int get openLeafCount {
    if (children.isEmpty) {
      return isClosed ? 0 : 1;
    }
    return children.fold(0, (sum, child) => sum + child.openLeafCount);
  }

  @override
  List<Object?> get props => [id, name, level, isClosed, children];
}
