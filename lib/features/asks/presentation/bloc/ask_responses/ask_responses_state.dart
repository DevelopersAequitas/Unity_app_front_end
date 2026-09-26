import 'package:equatable/equatable.dart';
import '../../../domain/entities/ask_response_item_entity.dart';

enum AskResponsesStatus { initial, loading, success, error }

class AskResponsesState extends Equatable {
  final AskResponsesStatus status;
  final List<AskResponseItemEntity> responses;
  final String activeFilter; // 'all', 'direct_help', 'referral', 'intro'
  final String? errorMessage;

  const AskResponsesState({
    this.status = AskResponsesStatus.initial,
    this.responses = const [],
    this.activeFilter = 'all',
    this.errorMessage,
  });

  List<AskResponseItemEntity> get filteredResponses {
    if (activeFilter == 'direct_help') {
      return responses.where((r) => r.isDirectHelp).toList();
    } else if (activeFilter == 'referral') {
      return responses.where((r) => r.isContactReferral).toList();
    } else if (activeFilter == 'intro') {
      return responses.where((r) => r.isPeerIntro).toList();
    }
    return responses;
  }

  int get directHelpCount => responses.where((r) => r.isDirectHelp).length;
  int get referralCount => responses.where((r) => r.isContactReferral).length;
  int get introCount => responses.where((r) => r.isPeerIntro).length;

  AskResponsesState copyWith({
    AskResponsesStatus? status,
    List<AskResponseItemEntity>? responses,
    String? activeFilter,
    String? errorMessage,
  }) {
    return AskResponsesState(
      status: status ?? this.status,
      responses: responses ?? this.responses,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, responses, activeFilter, errorMessage];
}
