import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';
import '../widgets/event_card_item.dart';
import '../widgets/event_search_filter_bar.dart';
import '../widgets/featured_event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(const FetchAllEventsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColor.primaryBlue;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Events',
          showBack: Navigator.canPop(context),
          onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
          showSearch: true,
          showChat: false,
          showNotifications: false,
          showProfile: false,
          isSearching: _isSearching,
          searchController: _searchController,
          searchHint: 'Search events by name, circle, location...',
          onSearchTap: () => setState(() => _isSearching = true),
          onSearchClose: () {
            setState(() => _isSearching = false);
            _searchController.clear();
            context.read<EventsBloc>().add(const SearchEventsQueryEvent(''));
          },
          onSearchChanged: (q) => context.read<EventsBloc>().add(SearchEventsQueryEvent(q)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, AppRoutes.myEvents);
                  if (context.mounted) {
                    context.read<EventsBloc>().add(const FetchAllEventsEvent(isRefresh: true));
                  }
                },
                icon: const Icon(Icons.confirmation_number_outlined, size: 14),
                label: Text(
                  'My Events',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                    color: primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(color: primary.withValues(alpha: 0.6)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            final filtered = state.filteredEvents;
            final featured = state.featuredEvent;

            String sectionTitle;
            if (state.searchQuery.isNotEmpty) {
              sectionTitle = 'Search Results';
            } else if (state.activeFilter == 'past') {
              sectionTitle = 'Past Events';
            } else if (state.activeFilter == 'today') {
              sectionTitle = "Today's Events";
            } else if (state.activeFilter == 'upcoming') {
              sectionTitle = 'Upcoming Events';
            } else {
              sectionTitle = 'All Events';
            }

            return RefreshIndicator(
              color: AppColor.primaryBlue,
              onRefresh: () async {
                context.read<EventsBloc>().add(const FetchAllEventsEvent(isRefresh: true));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  // Filter Pills Row
                  EventSearchFilterBar(
                    activeFilter: state.activeFilter,
                    onFilterChanged: (f) => context.read<EventsBloc>().add(ChangeEventFilterTabEvent(f)),
                  ),
                  const SizedBox(height: 10),

                  // Featured Event Card (shown only on 'all' and when not searching)
                  if (featured != null && state.activeFilter == 'all' && state.searchQuery.isEmpty) ...[
                    FeaturedEventCard(
                      event: featured,
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          AppRoutes.eventDetail,
                          arguments: featured,
                        );
                        if (context.mounted) {
                          context.read<EventsBloc>().add(const FetchAllEventsEvent(isRefresh: true));
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Section Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sectionTitle,
                          style: TextStyle(
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        if (filtered.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filtered.length} ${filtered.length == 1 ? 'Event' : 'Events'}',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // List / Loading / Empty State
                  if (state.status == EventsStatus.loading && filtered.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(36),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_busy_outlined,
                            size: 40,
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? 'No events matching "${state.searchQuery}"'
                                : 'No events found in this category',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...filtered.map(
                      (e) => EventCardItem(
                        event: e,
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.eventDetail,
                            arguments: e,
                          );
                          if (context.mounted) {
                            context.read<EventsBloc>().add(const FetchAllEventsEvent(isRefresh: true));
                          }
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
