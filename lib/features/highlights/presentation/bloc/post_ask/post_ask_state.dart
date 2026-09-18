import 'package:equatable/equatable.dart';
import '../../../domain/entities/post_ask_entity.dart';

enum PostAskStatus { initial, loading, submitting, success, error }

class PostAskState extends Equatable {
  final PostAskStatus status;
  final List<PostAskEntity> asks;
  final String activeFilter;
  final String? successMessage;
  final String? errorMessage;
  final bool isUploadingAttachment;

  const PostAskState({
    this.status = PostAskStatus.initial,
    this.asks = const [],
    this.activeFilter = 'all',
    this.successMessage,
    this.errorMessage,
    this.isUploadingAttachment = false,
  });

  List<PostAskEntity> get filteredAsks {
    if (activeFilter == 'open') {
      return asks.where((a) => a.isOpen).toList();
    } else if (activeFilter == 'completed') {
      return asks.where((a) => a.isCompleted).toList();
    }
    return asks;
  }

  int get openCount => asks.where((a) => a.isOpen).length;
  int get completedCount => asks.where((a) => a.isCompleted).length;

  PostAskState copyWith({
    PostAskStatus? status,
    List<PostAskEntity>? asks,
    String? activeFilter,
    String? successMessage,
    String? errorMessage,
    bool? isUploadingAttachment,
  }) {
    return PostAskState(
      status: status ?? this.status,
      asks: asks ?? this.asks,
      activeFilter: activeFilter ?? this.activeFilter,
      successMessage: successMessage,
      errorMessage: errorMessage,
      isUploadingAttachment: isUploadingAttachment ?? this.isUploadingAttachment,
    );
  }

  @override
  List<Object?> get props => [
        status,
        asks,
        activeFilter,
        successMessage,
        errorMessage,
        isUploadingAttachment,
      ];
}
