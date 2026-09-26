import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/common_peer_selector_sheet.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../../domain/entities/ask_flow_entity.dart';
import '../../domain/entities/ask_type_entity.dart';
import '../bloc/ask_response/ask_response_bloc.dart';
import '../bloc/ask_response/ask_response_event.dart';

class AskHelpOptionsBottomSheet extends StatelessWidget {
  final AskItemEntity item;
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;

  const AskHelpOptionsBottomSheet({
    super.key,
    required this.item,
    required this.peer,
    required this.submission,
  });

  static Future<void> show(
    BuildContext context, {
    required AskItemEntity item,
    AskMatchPeerEntity? peer,
    AskSubmissionEntity? submission,
  }) {
    final effectivePeer = peer ?? _buildFallbackPeer(item);
    final effectiveSubmission = submission ?? _buildFallbackSubmission(item);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AskHelpOptionsBottomSheet(
        item: item,
        peer: effectivePeer,
        submission: effectiveSubmission,
      ),
    );
  }

  static AskMatchPeerEntity _buildFallbackPeer(AskItemEntity item) {
    final raw = item.rawData;
    final creator = raw['creator'] is Map
        ? raw['creator'] as Map<String, dynamic>
        : (raw['user'] is Map ? raw['user'] as Map<String, dynamic> : null);
    final creatorId = creator?['id']?.toString() ??
        raw['creator_id']?.toString() ??
        raw['user_id']?.toString() ??
        '';
    final creatorName = creator?['name']?.toString() ??
        creator?['display_name']?.toString() ??
        raw['creator_name']?.toString() ??
        raw['author_name']?.toString() ??
        'Peer';
    final creatorDesignation = creator?['designation']?.toString() ??
        creator?['company_name']?.toString() ??
        raw['creator_designation']?.toString() ??
        '';
    final creatorCity = creator?['city']?.toString() ??
        creator?['location']?.toString() ??
        raw['creator_city']?.toString() ??
        '';
    final typeCode = raw['type_code']?.toString() ??
        raw['type']?.toString() ??
        item.typeName.toLowerCase().replaceAll(' ', '_');

    final type = AskTypeEntity(
      id: typeCode,
      flowId: item.flowCode,
      code: typeCode,
      name: item.typeName.isNotEmpty ? item.typeName : 'Partner',
    );

    return AskMatchPeerEntity(
      id: creatorId,
      name: creatorName.isNotEmpty ? creatorName : 'Peer',
      businessType: creatorDesignation,
      location: creatorCity,
      typeLabel: type.name,
      isTypeMatched: true,
      capitalLabel: '',
      isCapitalMatched: true,
      stageLabel: '',
      isStageMatched: true,
      peer: PeerEntity(
        id: creatorId,
        displayName: creatorName,
        companyName: creatorDesignation,
      ),
    );
  }

  static AskSubmissionEntity _buildFallbackSubmission(AskItemEntity item) {
    final flow = AskFlowEntity(
      id: item.flowCode,
      code: item.flowCode,
      name: item.flowName.isNotEmpty ? item.flowName : 'Collaboration',
      description: '',
    );
    final type = AskTypeEntity(
      id: item.typeName.toLowerCase().replaceAll(' ', '_'),
      flowId: flow.id,
      code: item.typeName.toLowerCase().replaceAll(' ', '_'),
      name: item.typeName.isNotEmpty ? item.typeName : 'General',
    );
    return AskSubmissionEntity(
      flow: flow,
      type: type,
      goal: item.title,
    );
  }

  void _onHelpDirectly(BuildContext context) {
    Navigator.of(context).pop();
    final flowCode = item.flowCode.toLowerCase().trim();
    final isHelp = flowCode == 'help' || flowCode == 'advice';

    Navigator.of(context).pushNamed(
      isHelp ? AppRoutes.askHelpResponse : AppRoutes.askExpressInterest,
      arguments: {
        'peer': peer,
        'submission': submission,
        'askId': item.id,
      },
    );
  }

  void _onKnowSomeone(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(
      AppRoutes.askReferralContact,
      arguments: {
        'askId': item.id,
        'peer': peer,
        'submission': submission,
      },
    );
  }

  Future<void> _onIntroducePeer(BuildContext context) async {
    Navigator.of(context).pop();

    final selectedPeer = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer to Introduce',
    );

    if (selectedPeer != null && context.mounted) {
      _showPeerIntroDialog(context, selectedPeer);
    }
  }

  void _showPeerIntroDialog(BuildContext context, PeerEntity selectedPeer) {
    final noteController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Introduce Peer',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You are recommending this peer for the ask',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Peer profile tile
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColor.darkSurfaceSubtle
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          AppAvatar(
                            imageUrl: selectedPeer.profilePhotoUrl,
                            name: selectedPeer.displayName,
                            size: 44,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedPeer.displayName,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                if (selectedPeer.companyName != null &&
                                    selectedPeer.companyName!.isNotEmpty)
                                  Text(
                                    selectedPeer.companyName!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Note input
                    Text(
                      'Why are they a great fit? (Optional)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: noteController,
                      maxLines: 2,
                      style: TextStyle(fontSize: 13.5, color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Add a brief endorsement note...',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColor.brandGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            final note = noteController.text.trim();
                            context.read<AskResponseBloc>().add(
                                  AskResponseSubmitRequested(
                                    askId: item.id,
                                    responseType: 'can_introduce_peer',
                                    message: note.isNotEmpty
                                        ? note
                                        : 'Introduced peer: ${selectedPeer.displayName}',
                                    timeline: 'immediate',
                                    extraData: {
                                      'introduced_user_id': selectedPeer.id,
                                      'introduced_peer_name':
                                          selectedPeer.displayName,
                                      if (note.isNotEmpty) 'note': note,
                                    },
                                  ),
                                );
                            Navigator.of(modalCtx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Introduced ${selectedPeer.displayName} successfully!',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                backgroundColor: AppColor.primaryBlue,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Introduce Peer',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I Can Help',
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Choose how you would like to assist this ask',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.5,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Option 1: I can help directly
            _buildOptionCard(
              context: context,
              icon: Icons.volunteer_activism_outlined,
              iconGradient: AppColor.brandGradient,
              title: 'I can help directly',
              subtitle: 'Offer your direct skills, product, or partnership',
              badgeText: 'Direct',
              badgeColor: AppColor.primaryBlue,
              isDark: isDark,
              onTap: () => _onHelpDirectly(context),
            ),
            const SizedBox(height: 10),

            // Option 2: I know someone
            _buildOptionCard(
              context: context,
              icon: Icons.contacts_rounded,
              iconGradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              title: 'I know someone',
              subtitle: 'Refer a contact or pick from your phone book',
              badgeText: 'Referral',
              badgeColor: const Color(0xFF0284C7),
              isDark: isDark,
              onTap: () => _onKnowSomeone(context),
            ),
            const SizedBox(height: 10),

            // Option 3: I can introduce a peer
            _buildOptionCard(
              context: context,
              icon: Icons.diversity_3_rounded,
              iconGradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              title: 'I can introduce a peer',
              subtitle: 'Recommend an active member from the Peers Unity network',
              badgeText: 'Community',
              badgeColor: const Color(0xFF6366F1),
              isDark: isDark,
              onTap: () => _onIntroducePeer(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required Gradient iconGradient,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final cardBg = isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.9),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: iconGradient,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 22, color: Colors.white),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.5, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
