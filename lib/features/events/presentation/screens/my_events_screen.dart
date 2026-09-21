import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/my_events_bloc.dart';
import '../bloc/my_events_event.dart';
import '../bloc/my_events_state.dart';
import '../widgets/my_event_card_item.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyEventsBloc>().add(const FetchMyEventsEvent());
  }

  Future<void> _handlePayment(String? url) async {
    if (url != null && url.trim().isNotEmpty) {
      final uri = Uri.parse(url.trim());
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (_) {
        try {
          await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        } catch (e) {
          if (mounted) {
            AppSnackBar.showError(context, 'Unable to open payment link: $e');
          }
        }
      }
    }
  }

  static const _tabs = [
    {'id': 'registered', 'label': 'Registered'},
    {'id': 'attending', 'label': 'Attending'},
    {'id': 'past', 'label': 'Past'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColor.primaryBlue : AppColor.primaryBlue;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const AppCommonBar(
          title: 'My Events',
          showBack: true,
          showSearch: false,
          showChat: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: BlocBuilder<MyEventsBloc, MyEventsState>(
          builder: (context, state) {
            final items = state.filteredItems;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<MyEventsBloc>().add(const FetchMyEventsEvent(isRefresh: true));
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Tab Pills Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tabs.map((t) {
                        final isSelected = state.activeTab == t['id'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => context.read<MyEventsBloc>().add(ChangeMyEventsTabEvent(t['id']!)),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? primary : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected ? primary : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                                ),
                              ),
                              child: Text(
                                t['label']!,
                                style: AppTypography.labelSmall.copyWith(
                                  color: isSelected ? Colors.white : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List
                  if (state.status == MyEventsStatus.loading && items.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (items.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.confirmation_number_outlined, size: 48, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                          const SizedBox(height: 8),
                          Text(
                            'No events found in this category',
                            style: AppTypography.bodyLarge.copyWith(
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...items.map(
                      (item) => MyEventCardItem(
                        item: item,
                        onTap: () {},
                        onViewQr: () {
                          if (item.isPendingPayment) {
                            _handlePayment(item.checkoutUrl ?? item.paymentUrl);
                          } else {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.eventQrTicket,
                              arguments: item,
                            );
                          }
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Discover More Events Card
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.explore_outlined, size: 24, color: primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discover more events',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Explore upcoming events and grow your network.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 18, color: primary),
                        ],
                      ),
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
