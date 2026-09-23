import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../widgets/notification_empty_view.dart';
import '../widgets/notification_group_header.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notification_router_helper.dart';
import '../widgets/notification_skeleton.dart';
import '../widgets/notification_type_helper.dart';
import '../widgets/notifications_header_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NotificationsBloc>().add(const NotificationsFetchRequested());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll - 200)) {
      context.read<NotificationsBloc>().add(
        const NotificationsLoadMoreRequested(),
      );
    }
  }

  void _handleNotificationTap(NotificationEntity notification) {
    context.read<NotificationsBloc>().add(
      NotificationMarkReadRequested(notification.id),
    );
    NotificationRouterHelper.handleNotificationTap(context, notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Notifications',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.of(context).pop(),
        // actions: [
        //   BlocBuilder<NotificationsBloc, NotificationsState>(
        //     builder: (context, state) {
        //       final isDark = Theme.of(context).brightness == Brightness.dark;
        //       final iconColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

        //       return PopupMenuButton<String>(
        //         icon: Icon(Icons.more_vert_rounded, size: 22, color: iconColor),
        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //         color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        //         elevation: 4,
        //         tooltip: 'Notification options',
        //         onSelected: (value) {
        //           if (value == 'filter_all') {
        //             context.read<NotificationsBloc>().add(const NotificationsFilterChanged('all'));
        //           } else if (value == 'filter_unread') {
        //             context.read<NotificationsBloc>().add(const NotificationsFilterChanged('unread'));
        //           } else if (value == 'mark_all_read') {
        //             context.read<NotificationsBloc>().add(const NotificationsMarkAllReadRequested());
        //           }
        //         },
        //         itemBuilder: (context) => [
        //           PopupMenuItem<String>(
        //             value: 'filter_all',
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.notifications_none_rounded,
        //                   size: 18,
        //                   color: state.activeFilter == 'all'
        //                       ? AppColor.primaryBlue
        //                       : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
        //                 ),
        //                 const SizedBox(width: 10),
        //                 Expanded(
        //                   child: Text(
        //                     'All Notifications',
        //                     style: AppTypography.bodySmall.copyWith(
        //                       fontWeight: state.activeFilter == 'all' ? FontWeight.w600 : FontWeight.normal,
        //                       color: state.activeFilter == 'all'
        //                           ? AppColor.primaryBlue
        //                           : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
        //                     ),
        //                   ),
        //                 ),
        //                 if (state.activeFilter == 'all')
        //                   const Icon(Icons.check_rounded, size: 16, color: AppColor.primaryBlue),
        //               ],
        //             ),
        //           ),
        //           PopupMenuItem<String>(
        //             value: 'filter_unread',
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.mark_email_unread_outlined,
        //                   size: 18,
        //                   color: state.activeFilter == 'unread'
        //                       ? AppColor.primaryBlue
        //                       : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
        //                 ),
        //                 const SizedBox(width: 10),
        //                 Expanded(
        //                   child: Row(
        //                     children: [
        //                       Text(
        //                         'Unread Only',
        //                         style: AppTypography.bodySmall.copyWith(
        //                           fontWeight: state.activeFilter == 'unread' ? FontWeight.w600 : FontWeight.normal,
        //                           color: state.activeFilter == 'unread'
        //                               ? AppColor.primaryBlue
        //                               : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
        //                         ),
        //                       ),
        //                       if (state.unreadCount > 0) ...[
        //                         const SizedBox(width: 6),
        //                         Container(
        //                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        //                           decoration: BoxDecoration(
        //                             color: AppColor.primaryPink.withValues(alpha: 0.15),
        //                             borderRadius: BorderRadius.circular(10),
        //                           ),
        //                           child: Text(
        //                             '${state.unreadCount}',
        //                             style: AppTypography.labelSmall.copyWith(
        //                               color: AppColor.primaryPink,
        //                               fontSize: 10,
        //                               fontWeight: FontWeight.w600,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ],
        //                   ),
        //                 ),
        //                 if (state.activeFilter == 'unread')
        //                   const Icon(Icons.check_rounded, size: 16, color: AppColor.primaryBlue),
        //               ],
        //             ),
        //           ),
        //           const PopupMenuDivider(),
        //           PopupMenuItem<String>(
        //             value: 'mark_all_read',
        //             enabled: state.unreadCount > 0,
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.done_all_rounded,
        //                   size: 18,
        //                   color: state.unreadCount > 0
        //                       ? AppColor.primaryPink
        //                       : (isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled),
        //                 ),
        //                 const SizedBox(width: 10),
        //                 Text(
        //                   'Mark all as read',
        //                   style: AppTypography.bodySmall.copyWith(
        //                     color: state.unreadCount > 0
        //                         ? (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary)
        //                         : (isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       );
        //     },
        //   ),
        // ],
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context.read<NotificationsBloc>().add(
                    const NotificationsRefreshRequested(),
                  );
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: NotificationsHeaderBar(
                        unreadCount: state.unreadCount,
                        activeFilter: state.activeFilter,
                        onFilterChanged: (filter) {
                          context.read<NotificationsBloc>().add(
                            NotificationsFilterChanged(filter),
                          );
                        },
                        onMarkAllRead: () {
                          context.read<NotificationsBloc>().add(
                            const NotificationsMarkAllReadRequested(),
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 4)),
                    if (state.status == NotificationsStatus.loading &&
                        state.notifications.isEmpty)
                      const SliverToBoxAdapter(child: NotificationSkeleton())
                    else if (state.status == NotificationsStatus.error &&
                        state.notifications.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppErrorView(
                          title: 'Unable to Load Notifications',
                          message: state.errorMessage,
                          onRetry: () => context.read<NotificationsBloc>().add(
                                const NotificationsRefreshRequested(),
                              ),
                          screenName: 'Notifications',
                        ),
                      )
                    else if (state.filteredNotifications.isEmpty)
                      SliverToBoxAdapter(
                        child: NotificationEmptyView(
                          onRefresh: () {
                            context.read<NotificationsBloc>().add(
                              const NotificationsFetchRequested(),
                            );
                          },
                        ),
                      )
                    else
                      ..._buildGroupedNotificationSlivers(
                        state.filteredNotifications,
                      ),
                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 24 + MediaQuery.of(context).padding.bottom,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedNotificationSlivers(
    List<NotificationEntity> notifications,
  ) {
    final Map<String, List<NotificationEntity>> groups = {
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };
    for (final notif in notifications) {
      final date = notif.createdAt ?? notif.sentAt;
      final group = NotificationTypeHelper.formatGroupDate(date);
      groups[group]?.add(notif);
    }

    final slivers = <Widget>[];
    for (final entry in groups.entries) {
      if (entry.value.isEmpty) continue;
      final firstDate = entry.value.first.createdAt ?? entry.value.first.sentAt;
      final headerSubtitle = NotificationTypeHelper.formatHeaderDateString(
        firstDate,
      );

      slivers.add(
        SliverToBoxAdapter(
          child: NotificationGroupHeader(
            title: entry.key,
            dateSubtitle: headerSubtitle,
          ),
        ),
      );
      slivers.add(
        SliverList.builder(
          itemCount: entry.value.length,
          itemBuilder: (context, index) {
            final item = entry.value[index];
            return NotificationItemCard(
              notification: item,
              onTap: () => _handleNotificationTap(item),
            );
          },
        ),
      );
    }
    return slivers;
  }
}
