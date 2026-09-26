import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../bloc/ask_matches/ask_matches_bloc.dart';
import '../bloc/ask_matches/ask_matches_event.dart';
import '../bloc/ask_matches/ask_matches_state.dart';
import '../widgets/ask_match_peer_card.dart';
import '../widgets/ask_step_header.dart';
import '../widgets/ask_step1_skeleton.dart';

class AskMatchesScreen extends StatefulWidget {
  final String askId;
  final AskSubmissionEntity? submission;
  final String? flowTitle;

  const AskMatchesScreen({
    super.key,
    required this.askId,
    this.submission,
    this.flowTitle,
  });

  @override
  State<AskMatchesScreen> createState() => _AskMatchesScreenState();
}

class _AskMatchesScreenState extends State<AskMatchesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AskMatchesBloc>().add(AskMatchesFetchRequested(widget.askId));
  }

  void _onStartConversation(AskMatchPeerEntity peer) {
    final goal = widget.submission?.effectiveGoal ?? widget.flowTitle ?? 'my request';
    final firstName = peer.peer.firstName;
    final name = (firstName != null && firstName.isNotEmpty)
        ? firstName
        : (peer.peer.displayName.isNotEmpty
            ? peer.peer.displayName.split(' ').first
            : 'there');
    final defaultMsg = "Hi $name, I saw we matched on Peers Unity for \"$goal\". I'd love to connect and discuss!";

    Navigator.of(context).pushNamed(
      AppRoutes.directChat,
      arguments: {
        'peer_id': peer.peer.id,
        'peer_name': peer.peer.displayName,
        'peer_avatar': peer.peer.profilePhotoUrl,
        'initial_message': defaultMsg,
      },
    );
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onBack();
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        appBar: AppCommonBar(
          title: widget.submission?.flow.name ?? widget.flowTitle ?? 'Matched Peers',
          showBack: true,
          onBackTap: _onBack,
        ),
      body: SafeArea(
        child: BlocBuilder<AskMatchesBloc, AskMatchesState>(
          builder: (context, state) {
            final matches = state.matches;
            final count = matches.length;
            final headerTitle = state.status == AskMatchesStatus.loading && matches.isEmpty
                ? 'Finding matching peers...'
                : '$count ${count == 1 ? "Peer" : "Peers"} match your request';

            return Column(
              children: [
                AskStepHeader(
                  title: headerTitle,
                  subtitle: 'Fit is checked against what you bring and need',
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status == AskMatchesStatus.loading && matches.isEmpty) {
                        return const AskStep1Skeleton();
                      }

                      if (state.status == AskMatchesStatus.error && matches.isEmpty) {
                        return AppErrorView(
                          title: 'Unable to Load Matches',
                          message: state.errorMessage ?? 'Please check your connection and try again.',
                          onRetry: () => context
                              .read<AskMatchesBloc>()
                              .add(AskMatchesFetchRequested(widget.askId)),
                        );
                      }

                      if (matches.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'No matching peers found at the moment.\nWe will notify you when peers match your ask.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final peer = matches[index];
                          return AskMatchPeerCard(
                            peer: peer,
                            onStartConversation: () => _onStartConversation(peer),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
}
