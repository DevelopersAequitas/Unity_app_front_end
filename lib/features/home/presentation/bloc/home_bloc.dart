import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/usecases/get_brand_partners_usecase.dart';
import '../../domain/usecases/get_timeline_feed_usecase.dart';
import '../../domain/usecases/toggle_post_like_usecase.dart';
import '../../domain/usecases/toggle_post_save_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTimelineFeedUseCase getTimelineFeedUseCase;
  final GetBrandPartnersUseCase getBrandPartnersUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;

  HomeBloc({
    required this.getTimelineFeedUseCase,
    required this.getBrandPartnersUseCase,
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
  }) : super(const HomeState()) {
    on<HomeFeedFetchRequested>(_onFeedFetchRequested);
    on<HomeFeedRefreshRequested>(_onFeedRefreshRequested);
    on<HomeFeedLoadMoreRequested>(_onFeedLoadMoreRequested);
    on<HomeBrandPartnersFetchRequested>(_onBrandPartnersFetchRequested);
    on<HomePostLikeToggled>(_onPostLikeToggled);
    on<HomePostSaveToggled>(_onPostSaveToggled);
    on<HomeFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFeedFetchRequested(HomeFeedFetchRequested event, Emitter<HomeState> emit) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(status: HomeFeedStatus.loading, errorMessage: null));
    }
    try {
      final filter = event.filter ?? state.activeFilter;
      final res = await getTimelineFeedUseCase(page: 1, perPage: 20, filter: filter);
      final partners = await getBrandPartnersUseCase();
      emit(state.copyWith(
        status: HomeFeedStatus.success,
        items: res.items,
        brandPartners: partners,
        pagination: res.pagination,
        activeFilter: filter,
      ));
    } catch (e, stack) {
      if (state.items.isEmpty) {
        emit(state.copyWith(
          status: HomeFeedStatus.error,
          errorMessage: AppErrorHandler.toUserFriendlyMessage(e, stack),
        ));
      }
    }
  }

  Future<void> _onFeedRefreshRequested(HomeFeedRefreshRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isRefreshing: true));
    try {
      final res = await getTimelineFeedUseCase(page: 1, perPage: 20, filter: state.activeFilter);
      final partners = await getBrandPartnersUseCase();
      emit(state.copyWith(
        status: HomeFeedStatus.success,
        items: res.items,
        brandPartners: partners,
        pagination: res.pagination,
        isRefreshing: false,
      ));
    } catch (_) {
      emit(state.copyWith(isRefreshing: false));
    }
  }

  Future<void> _onFeedLoadMoreRequested(HomeFeedLoadMoreRequested event, Emitter<HomeState> emit) async {
    if (state.isLoadingMore || !state.pagination.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final res = await getTimelineFeedUseCase(
        page: state.pagination.currentPage + 1,
        perPage: state.pagination.perPage,
        filter: state.activeFilter,
      );
      emit(state.copyWith(
        items: List<TimelineItemEntity>.from(state.items)..addAll(res.items),
        pagination: res.pagination,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onBrandPartnersFetchRequested(HomeBrandPartnersFetchRequested event, Emitter<HomeState> emit) async {
    try {
      final partners = await getBrandPartnersUseCase();
      emit(state.copyWith(brandPartners: partners));
    } catch (_) {}
  }

  Future<void> _onPostLikeToggled(HomePostLikeToggled event, Emitter<HomeState> emit) async {
    final updated = state.items.map((item) {
      if (item.id != event.postId) return item;
      final isLiked = !event.isCurrentlyLiked;
      return item.copyWith(
        isLikedByMe: isLiked,
        likesCount: (item.likesCount + (isLiked ? 1 : -1)).clamp(0, 9999999),
      );
    }).toList();
    emit(state.copyWith(items: updated));
    try {
      await togglePostLikeUseCase(event.postId, isCurrentlyLiked: event.isCurrentlyLiked);
    } catch (_) {}
  }

  Future<void> _onPostSaveToggled(HomePostSaveToggled event, Emitter<HomeState> emit) async {
    final updated = state.items.map((item) {
      if (item.id != event.postId) return item;
      final isSaved = !event.isCurrentlySaved;
      return item.copyWith(
        isSaved: isSaved,
        savesCount: (item.savesCount + (isSaved ? 1 : -1)).clamp(0, 9999999),
      );
    }).toList();
    emit(state.copyWith(items: updated));
    try {
      await togglePostSaveUseCase(event.postId, isCurrentlySaved: event.isCurrentlySaved);
    } catch (_) {}
  }

  void _onFilterChanged(HomeFilterChanged event, Emitter<HomeState> emit) {
    if (event.filter != state.activeFilter) {
      add(HomeFeedFetchRequested(filter: event.filter));
    }
  }
}
