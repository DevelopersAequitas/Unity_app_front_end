import 'package:equatable/equatable.dart';

class AskFlowEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String description;
  final String? icon;
  final int sortOrder;
  final bool isActive;
  final List<dynamic> metadata;

  const AskFlowEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.icon,
    this.sortOrder = 0,
    this.isActive = true,
    this.metadata = const [],
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        icon,
        sortOrder,
        isActive,
        metadata,
      ];
}
