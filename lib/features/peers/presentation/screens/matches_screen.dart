import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/matches_bloc.dart';
import '../bloc/matches_event.dart';
import '../bloc/matches_state.dart';
import '../widgets/match_action_buttons.dart';
import '../widgets/match_discovery_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final CardSwiperController _controller = CardSwiperController();
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MatchesBloc>();
    if (bloc.state.status == MatchesStatus.initial) {
      bloc.add(const MatchesFetchRequested());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppCommonBar(
        title: 'Discovery',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.pop(context),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocConsumer<MatchesBloc, MatchesState>(
            listenWhen: (prev, curr) =>
                curr.errorMessage != null &&
                prev.errorMessage != curr.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              if (state.status == MatchesStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primaryBlue,
                  ),
                );
              }

              final matches = state.matches;

              return (matches.isEmpty || _isFinished)
                  ? _buildCompletedState()
                  : SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          Expanded(
                            child: CardSwiper(
                              controller: _controller,
                              cardsCount: matches.length,
                              numberOfCardsDisplayed:
                                  matches.length > 2 ? 3 : matches.length,
                              backCardOffset: const Offset(0, 14),
                              scale: 0.94,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              allowedSwipeDirection:
                                  const AllowedSwipeDirection.symmetric(
                                horizontal: true,
                              ),
                              cardBuilder:
                                  (context, index, percentX, percentY) {
                                return MatchDiscoveryCard(
                                  match: matches[index],
                                );
                              },
                              onSwipe:
                                  (previousIndex, currentIndex, direction) {
                                final match = matches[previousIndex];
                                if (direction == CardSwiperDirection.right) {
                                  context.read<MatchesBloc>().add(
                                        MatchConnectRequested(match.id),
                                      );
                                  AppSnackBar.showSuccess(
                                    context,
                                    'Connected with ${match.displayName}',
                                  );
                                } else if (direction ==
                                    CardSwiperDirection.left) {
                                  context.read<MatchesBloc>().add(
                                        MatchPassRequested(match.id),
                                      );
                                }
                                return true;
                              },
                              onEnd: () {
                                setState(() => _isFinished = true);
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          MatchActionButtons(
                            onPass: () =>
                                _controller.swipe(CardSwiperDirection.left),
                            onConnect: () =>
                                _controller.swipe(CardSwiperDirection.right),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.badgeBlueBg,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 40,
              color: AppColor.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You are all caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Check back later for new curated peer recommendations.',
            style: TextStyle(fontSize: 13, color: AppColor.lightTextSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() => _isFinished = false);
              context.read<MatchesBloc>().add(const MatchesFetchRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Refresh Matches'),
          ),
        ],
      ),
    );
  }
}
