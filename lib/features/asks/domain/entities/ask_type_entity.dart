import 'package:equatable/equatable.dart';

class AskTypeEntity extends Equatable {
  final String id;
  final String flowId;
  final String? parentId;
  final String code;
  final String name;
  final String? description;
  final int level;
  final int sortOrder;
  final bool isActive;
  final List<dynamic> children;
  final List<dynamic> metadata;

  const AskTypeEntity({
    required this.id,
    required this.flowId,
    this.parentId,
    required this.code,
    required this.name,
    this.description,
    this.level = 1,
    this.sortOrder = 0,
    this.isActive = true,
    this.children = const [],
    this.metadata = const [],
  });

  @override
  List<Object?> get props => [
        id,
        flowId,
        parentId,
        code,
        name,
        description,
        level,
        sortOrder,
        isActive,
        children,
        metadata,
      ];
}
