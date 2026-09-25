import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/entities/brand_partner_entity.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_brand_partners_usecase.dart';
import '../../domain/usecases/get_cached_brand_partners_usecase.dart';
import '../../domain/usecases/get_cached_timeline_feed_usecase.dart';
import '../../domain/usecases/get_timeline_feed_usecase.dart';
import '../../domain/usecases/report_post_usecase.dart';
import '../../domain/usecases/toggle_post_like_usecase.dart';
import '../../domain/usecases/toggle_post_save_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTimelineFeedUseCase getTimelineFeedUseCase;
  final GetBrandPartnersUseCase getBrandPartnersUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;
  final DeletePostUseCase? deletePostUseCase;
  final UpdatePostUseCase? updatePostUseCase;
  final ReportPostUseCase? reportPostUseCase;
  final GetCachedTimelineFeedUseCase? getCachedTimelineFeedUseCase;
  final GetCachedBrandPartnersUseCase? getCachedBrandPartnersUseCase;

  HomeBloc({
    required this.getTimelineFeedUseCase,
    required this.getBrandPartnersUseCase,
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
    this.deletePostUseCase,
    this.updatePostUseCase,
    this.reportPostUseCase,
    this.getCachedTimelineFeedUseCase,
    this.getCachedBrandPartnersUseCase,
  }) : super(const HomeState()) {
    on<HomeFeedFetchRequested>(_onFeedFetchRequested);
    on<HomeFeedRefreshRequested>(_onFeedRefreshRequested);
    on<HomeFeedLoadMoreRequested>(_onFeedLoadMoreRequested);
    on<HomeBrandPartnersFetchRequested>(_onBrandPartnersFetchRequested);
    on<HomePostLikeToggled>(_onPostLikeToggled);
    on<HomePostSaveToggled>(_onPostSaveToggled);
    on<HomePostCommentCountIncremented>(_onPostCommentCountIncremented);
    on<HomePostDeleted>(_onPostDeleted);
    on<HomePostReported>(_onPostReported);
    on<HomePostHidden>(_onPostHidden);
    on<HomePostEdited>(_onPostEdited);
    on<HomePostLikeSyncRequested>(_onPostLikeSyncRequested);
    on<HomePostSaveSyncRequested>(_onPostSaveSyncRequested);
    on<HomeFilterChanged>(_onFilterChanged);
    on<HomeSearchChanged>(_onSearchChanged);
  }

  void _onPostCommentCountIncremented(HomePostCommentCountIncremented event, Emitter<HomeState> emit) {
    final updated = state.allItems.map((item) {
      if (item.id != event.postId) return item;
      return item.copyWith(
        commentsCount: item.commentsCount + 1,
      );
    }).toList();
    emit(state.copyWith(allItems: updated));
  }

  Future<void> _onFeedFetchRequested(HomeFeedFetchRequested event, Emitter<HomeState> emit) async {
    final filter = event.filter ?? state.activeFilter;
    final isDefaultFilter = filter.isEmpty || filter == 'All';

    // 1. Fast cache-first load: If local cache exists and feed is not loaded, show cached immediately
    if (state.items.isEmpty && isDefaultFilter && getCachedTimelineFeedUseCase != null) {
      final cachedRes = await getCachedTimelineFeedUseCase!();
      final cachedPartners = getCachedBrandPartnersUseCase != null
          ? await getCachedBrandPartnersUseCase!()
          : <BrandPartnerEntity>[];

      if (cachedRes != null && cachedRes.items.isNotEmpty) {
        emit(state.copyWith(
          status: HomeFeedStatus.success,
          allItems: cachedRes.items,
          brandPartners: cachedPartners.isNotEmpty ? cachedPartners : state.brandPartners,
          pagination: cachedRes.pagination,
          clearError: true,
        ));
      } else {
        emit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));
      }
    } else if (state.allItems.isEmpty) {
      emit(state.copyWith(status: HomeFeedStatus.loading, clearError: true));
    }

    // 2. Background revalidation from remote
    try {
      final res = await getTimelineFeedUseCase(page: 1, perPage: 20, filter: filter);
      final partners = await getBrandPartnersUseCase();
      emit(state.copyWith(
        status: HomeFeedStatus.success,
        allItems: res.items,
        brandPartners: partners,
        pagination: res.pagination,
        activeFilter: filter,
        clearError: true,
      ));
    } catch (e, stack) {
      if (state.allItems.isEmpty) {
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
        allItems: res.items,
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
        allItems: List<TimelineItemEntity>.from(state.allItems)..addAll(res.items),
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
    final updated = state.allItems.map((item) {
      if (item.id != event.postId) return item;
      final isLiked = !event.isCurrentlyLiked;
      return item.copyWith(
        isLikedByMe: isLiked,
        likesCount: (item.likesCount + (isLiked ? 1 : -1)).clamp(0, 9999999),
      );
    }).toList();
    emit(state.copyWith(allItems: updated));
    try {
      await togglePostLikeUseCase(event.postId, isCurrentlyLiked: event.isCurrentlyLiked);
    } catch (_) {}
  }

  Future<void> _onPostSaveToggled(HomePostSaveToggled event, Emitter<HomeState> emit) async {
    final updated = state.allItems.map((item) {
      if (item.id != event.postId) return item;
      final isSaved = !event.isCurrentlySaved;
      return item.copyWith(
        isSaved: isSaved,
        savesCount: (item.savesCount + (isSaved ? 1 : -1)).clamp(0, 9999999),
      );
    }).toList();
    emit(state.copyWith(allItems: updated));
    try {
      await togglePostSaveUseCase(event.postId, isCurrentlySaved: event.isCurrentlySaved);
    } catch (_) {}
  }

  Future<void> _onPostDeleted(HomePostDeleted event, Emitter<HomeState> emit) async {
    final updated = state.allItems.where((item) => item.id != event.postId).toList();
    emit(state.copyWith(allItems: updated));
    try {
      if (deletePostUseCase != null) {
        await deletePostUseCase!(event.postId);
      }
    } catch (_) {}
  }

  Future<void> _onPostReported(HomePostReported event, Emitter<HomeState> emit) async {
    // Hide reported post immediately from the feed
    final updated = state.allItems.where((item) => item.id != event.postId).toList();
    emit(state.copyWith(allItems: updated));
    try {
      if (reportPostUseCase != null) {
        await reportPostUseCase!(event.postId, event.reasonId);
      }
    } catch (_) {}
  }

  void _onPostHidden(HomePostHidden event, Emitter<HomeState> emit) {
    final updated = state.allItems.where((item) => item.id != event.postId).toList();
    emit(state.copyWith(allItems: updated));
  }

  Future<void> _onPostEdited(HomePostEdited event, Emitter<HomeState> emit) async {
    final updated = state.allItems.map((item) {
      if (item.id != event.postId) return item;
      return item.copyWith(contentText: event.contentText);
    }).toList();
    emit(state.copyWith(allItems: updated));
    try {
      if (updatePostUseCase != null) {
        await updatePostUseCase!(event.postId, contentText: event.contentText);
      }
    } catch (_) {}
  }

  void _onPostLikeSyncRequested(HomePostLikeSyncRequested event, Emitter<HomeState> emit) {
    final updated = state.allItems.map((item) {
      if (item.id != event.postId) return item;
      return item.copyWith(
        isLikedByMe: event.isLiked,
        likesCount: event.likesCount,
      );
    }).toList();
    emit(state.copyWith(allItems: updated));
  }

  void _onPostSaveSyncRequested(HomePostSaveSyncRequested event, Emitter<HomeState> emit) {
    final updated = state.allItems.map((item) {
      if (item.id != event.postId) return item;
      final isSaved = event.isSaved;
      return item.copyWith(
        isSaved: isSaved,
        savesCount: (item.savesCount + (isSaved ? 1 : -1)).clamp(0, 9999999),
      );
    }).toList();
    emit(state.copyWith(allItems: updated));
  }

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onFilterChanged(HomeFilterChanged event, Emitter<HomeState> emit) {
    if (event.filter != state.activeFilter) {
      add(HomeFeedFetchRequested(filter: event.filter));
    }
  }
}
