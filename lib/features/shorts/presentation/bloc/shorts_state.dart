import 'package:equatable/equatable.dart';
import '../../domain/entities/intro_video_entity.dart';

enum ShortsStatus { initial, loading, loaded, error }

class ShortsState extends Equatable {
  final ShortsStatus status;
  final List<IntroVideoEntity> videos;
  final int currentIndex;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;

  const ShortsState({
    this.status = ShortsStatus.initial,
    this.videos = const [],
    this.currentIndex = 0,
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  ShortsState copyWith({
    ShortsStatus? status,
    List<IntroVideoEntity>? videos,
    int? currentIndex,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ShortsState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        videos,
        currentIndex,
        errorMessage,
        hasReachedMax,
        currentPage,
      ];
}
