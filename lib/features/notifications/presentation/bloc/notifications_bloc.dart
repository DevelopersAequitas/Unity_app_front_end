import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_cached_notifications_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;
  final GetCachedNotificationsUseCase getCachedNotificationsUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
    required this.getCachedNotificationsUseCase,
  }) : super(const NotificationsState()) {
    on<NotificationsFetchRequested>(_onFetchRequested);
    on<NotificationsRefreshRequested>(_onRefreshRequested);
    on<NotificationsLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
    on<NotificationsMarkAllReadRequested>(_onMarkAllReadRequested);
    on<NotificationsFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetchRequested(
    NotificationsFetchRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state.notifications.isEmpty) {
      final cached = await getCachedNotificationsUseCase();
      if (cached != null && cached.notifications.isNotEmpty) {
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: cached.notifications,
          pagination: cached.pagination,
          unreadCount: cached.unreadCount,
        ));
      } else {
        emit(state.copyWith(status: NotificationsStatus.loading));
      }
    }

    try {
      final res = await getNotificationsUseCase(page: 1);
      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: res.notifications,
        pagination: res.pagination,
        unreadCount: res.unreadCount,
        clearError: true,
      ));
    } catch (e) {
      if (state.notifications.isEmpty) {
        emit(state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefreshRequested(
    NotificationsRefreshRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final res = await getNotificationsUseCase(page: 1);
      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: res.notifications,
        pagination: res.pagination,
        unreadCount: res.unreadCount,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMoreRequested(
    NotificationsLoadMoreRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state.isLoadingMore || !state.pagination.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.pagination.currentPage + 1;
      final res = await getNotificationsUseCase(page: nextPage);
      final existingIds = state.notifications.map((n) => n.id).toSet();
      final newItems = res.notifications.where((n) => !existingIds.contains(n.id)).toList();

      emit(state.copyWith(
        notifications: [...state.notifications, ...newItems],
        pagination: res.pagination,
        unreadCount: res.unreadCount,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onMarkReadRequested(
    NotificationMarkReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final updatedList = state.notifications.map((n) {
      if (n.id == event.id && !n.isRead) {
        return n.copyWith(isRead: true, readAt: DateTime.now());
      }
      return n;
    }).toList();

    final newUnread = (state.unreadCount - 1).clamp(0, 999999);
    emit(state.copyWith(notifications: updatedList, unreadCount: newUnread));
    try {
      await markNotificationReadUseCase(event.id);
    } catch (_) {}
  }

  Future<void> _onMarkAllReadRequested(
    NotificationsMarkAllReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final updatedList = state.notifications
        .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
        .toList();
    emit(state.copyWith(notifications: updatedList, unreadCount: 0));
    try {
      await markAllNotificationsReadUseCase();
    } catch (_) {}
  }

  void _onFilterChanged(
    NotificationsFilterChanged event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(activeFilter: event.filter));
  }
}
