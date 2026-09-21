import 'package:equatable/equatable.dart';
import 'life_impact_entity.dart';

class LifeImpactHistoryEntity extends Equatable {
  final int totalLifeImpacted;
  final List<LifeImpactEntity> items;

  const LifeImpactHistoryEntity({
    this.totalLifeImpacted = 0,
    this.items = const [],
  });

  @override
  List<Object?> get props => [totalLifeImpacted, items];
}
