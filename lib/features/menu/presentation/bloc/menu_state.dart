import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_summary_entity.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  final MenuStatus status;
  final MenuSummaryEntity summary;
  final String? errorMessage;

  const MenuState({
    this.status = MenuStatus.initial,
    this.summary = const MenuSummaryEntity(),
    this.errorMessage,
  });

  MenuState copyWith({
    MenuStatus? status,
    MenuSummaryEntity? summary,
    String? errorMessage,
  }) {
    return MenuState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}
