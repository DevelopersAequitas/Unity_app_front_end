import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_item_entity.dart';

enum PeersFeedStatus { initial, loading, success, error }

class PeersFeedState extends Equatable {
  final PeersFeedStatus status;
  final List<AskItemEntity> items;
  final String selectedScope; // 'for_you', 'circle', 'city', 'all'
  final Set<String> congratulatedIds;
  final Set<String> savedIds;
  final String? errorMessage;

  const PeersFeedState({
    this.status = PeersFeedStatus.initial,
    this.items = const [],
    this.selectedScope = 'for_you',
    this.congratulatedIds = const {},
    this.savedIds = const {},
    this.errorMessage,
  });

  PeersFeedState copyWith({
    PeersFeedStatus? status,
    List<AskItemEntity>? items,
    String? selectedScope,
    Set<String>? congratulatedIds,
    Set<String>? savedIds,
    String? errorMessage,
  }) {
    return PeersFeedState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedScope: selectedScope ?? this.selectedScope,
      congratulatedIds: congratulatedIds ?? this.congratulatedIds,
      savedIds: savedIds ?? this.savedIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        selectedScope,
        congratulatedIds,
        savedIds,
        errorMessage,
      ];
}
