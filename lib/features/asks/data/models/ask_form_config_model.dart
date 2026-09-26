import '../../domain/entities/ask_form_config_entity.dart';
import 'ask_flow_model.dart';
import 'ask_type_model.dart';

class AskOptionModel extends AskOptionEntity {
  const AskOptionModel({
    required super.id,
    super.optionGroupId,
    required super.code,
    required super.label,
    super.description,
    super.sortOrder,
    super.isActive,
  });

  factory AskOptionModel.fromJson(Map<String, dynamic> json) {
    return AskOptionModel(
      id: json['id']?.toString() ?? '',
      optionGroupId: json['option_group_id']?.toString(),
      code: json['code']?.toString() ?? '',
      label: json['label']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'option_group_id': optionGroupId,
      'code': code,
      'label': label,
      'description': description,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}

class AskOptionGroupModel extends AskOptionGroupEntity {
  const AskOptionGroupModel({
    required super.id,
    required super.code,
    required super.name,
    required super.description,
    required super.inputType,
    super.isMultiSelect,
    super.isRequired,
    super.sortOrder,
    super.isActive,
    super.options,
  });

  factory AskOptionGroupModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final optionsList = <AskOptionModel>[];
    if (rawOptions is List) {
      for (final opt in rawOptions) {
        if (opt is Map<String, dynamic>) {
          optionsList.add(AskOptionModel.fromJson(opt));
        }
      }
    }
    optionsList.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return AskOptionGroupModel(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      inputType: json['input_type']?.toString() ?? 'single_select',
      isMultiSelect: json['is_multi_select'] == true || json['is_multi_select'] == 1,
      isRequired: json['is_required'] == true || json['is_required'] == 1,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      options: optionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'input_type': inputType,
      'is_multi_select': isMultiSelect,
      'is_required': isRequired,
      'sort_order': sortOrder,
      'is_active': isActive,
      'options': options.map((e) => (e as AskOptionModel).toJson()).toList(),
    };
  }
}

class AskFormConfigModel extends AskFormConfigEntity {
  const AskFormConfigModel({
    super.flow,
    super.type,
    super.detailSectionKeys,
    super.filterSectionKeys,
    super.groups,
  });

  factory AskFormConfigModel.fromJson(Map<String, dynamic> json) {
    AskFlowModel? flowModel;
    if (json['flow'] is Map<String, dynamic>) {
      flowModel = AskFlowModel.fromJson(json['flow'] as Map<String, dynamic>);
    }

    AskTypeModel? typeModel;
    if (json['type'] is Map<String, dynamic>) {
      typeModel = AskTypeModel.fromJson(json['type'] as Map<String, dynamic>);
    }

    final sections = json['sections'] is Map<String, dynamic>
        ? json['sections'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final detailsList = (sections['details'] is List)
        ? (sections['details'] as List).map((e) => e.toString()).toList()
        : const <String>[];

    final filtersList = (sections['filters'] is List)
        ? (sections['filters'] as List).map((e) => e.toString()).toList()
        : const <String>[];

    final rawGroups = json['groups'];
    final groupsList = <AskOptionGroupModel>[];
    if (rawGroups is List) {
      for (final grp in rawGroups) {
        if (grp is Map<String, dynamic>) {
          groupsList.add(AskOptionGroupModel.fromJson(grp));
        }
      }
    }
    groupsList.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return AskFormConfigModel(
      flow: flowModel,
      type: typeModel,
      detailSectionKeys: detailsList,
      filterSectionKeys: filtersList,
      groups: groupsList,
    );
  }

  AskFormConfigEntity toEntity() => this;
}
