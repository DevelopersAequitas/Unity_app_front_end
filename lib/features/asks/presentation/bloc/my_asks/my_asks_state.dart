import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_item_entity.dart';

enum MyAsksStatus { initial, loading, success, error }

class MyAsksState extends Equatable {
  final MyAsksStatus status;
  final List<AskItemEntity> asks;
  final String selectedFlow;
  final String selectedStatus;
  final String? errorMessage;

  const MyAsksState({
    this.status = MyAsksStatus.initial,
    this.asks = const [],
    this.selectedFlow = 'all',
    this.selectedStatus = 'all',
    this.errorMessage,
  });

  MyAsksState copyWith({
    MyAsksStatus? status,
    List<AskItemEntity>? asks,
    String? selectedFlow,
    String? selectedStatus,
    String? errorMessage,
  }) {
    return MyAsksState(
      status: status ?? this.status,
      asks: asks ?? this.asks,
      selectedFlow: selectedFlow ?? this.selectedFlow,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<AskItemEntity> get filteredAsks {
    if (selectedStatus == 'all') return asks;
    return asks.where((a) {
      final s = a.status.toLowerCase().trim();
      if (selectedStatus == 'open') {
        return s == 'open' || s == 'active' || s == 'published' || s == 'draft';
      } else if (selectedStatus == 'in_progress') {
        return s == 'in_progress' || s == 'in-progress' || s == 'review' || s == 'pending';
      } else if (selectedStatus == 'fulfilled') {
        return s == 'fulfilled' || s == 'completed' || s == 'done';
      } else if (selectedStatus == 'expired') {
        return s == 'expired' || s == 'closed' || s == 'archived';
      }
      return s == selectedStatus;
    }).toList();
  }

  @override
  List<Object?> get props => [
        status,
        asks,
        selectedFlow,
        selectedStatus,
        errorMessage,
      ];
}
