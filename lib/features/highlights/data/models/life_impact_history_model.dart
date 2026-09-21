import '../../domain/entities/life_impact_history_entity.dart';
import 'life_impact_model.dart';

class LifeImpactHistoryModel {
  final int totalLifeImpacted;
  final List<LifeImpactModel> items;

  const LifeImpactHistoryModel({
    this.totalLifeImpacted = 0,
    this.items = const [],
  });

  factory LifeImpactHistoryModel.fromJson(Map<String, dynamic> json) {
    int total = (json['total_life_impacted'] as num?)?.toInt() ?? 0;
    List<LifeImpactModel> items = [];

    if (json['items'] is List) {
      items = (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => LifeImpactModel.fromJson(e))
          .toList();
    }

    return LifeImpactHistoryModel(
      totalLifeImpacted: total,
      items: items,
    );
  }

  LifeImpactHistoryEntity toEntity() {
    return LifeImpactHistoryEntity(
      totalLifeImpacted: totalLifeImpacted,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }
}
