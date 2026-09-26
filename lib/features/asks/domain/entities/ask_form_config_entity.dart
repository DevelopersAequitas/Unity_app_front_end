import 'package:equatable/equatable.dart';
import 'ask_flow_entity.dart';
import 'ask_type_entity.dart';

class AskOptionEntity extends Equatable {
  final String id;
  final String? optionGroupId;
  final String code;
  final String label;
  final String? description;
  final int sortOrder;
  final bool isActive;

  const AskOptionEntity({
    required this.id,
    this.optionGroupId,
    required this.code,
    required this.label,
    this.description,
    this.sortOrder = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, optionGroupId, code, label, description, sortOrder, isActive];
}

class AskOptionGroupEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String description;
  final String inputType; // 'single_select', 'multi_select', 'text'
  final bool isMultiSelect;
  final bool isRequired;
  final int sortOrder;
  final bool isActive;
  final List<AskOptionEntity> options;

  const AskOptionGroupEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.inputType,
    this.isMultiSelect = false,
    this.isRequired = false,
    this.sortOrder = 0,
    this.isActive = true,
    this.options = const [],
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        inputType,
        isMultiSelect,
        isRequired,
        sortOrder,
        isActive,
        options,
      ];
}

class AskFormConfigEntity extends Equatable {
  final AskFlowEntity? flow;
  final AskTypeEntity? type;
  final List<String> detailSectionKeys;
  final List<String> filterSectionKeys;
  final List<AskOptionGroupEntity> groups;

  const AskFormConfigEntity({
    this.flow,
    this.type,
    this.detailSectionKeys = const [],
    this.filterSectionKeys = const [],
    this.groups = const [],
  });

  AskOptionGroupEntity? getGroupByCode(String code) {
    try {
      return groups.firstWhere((g) => g.code.toLowerCase() == code.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [flow, type, detailSectionKeys, filterSectionKeys, groups];
}
