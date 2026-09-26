import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/asks/domain/entities/ask_flow_entity.dart';
import 'package:unity_app/features/asks/domain/entities/ask_match_peer_entity.dart';
import 'package:unity_app/features/asks/domain/entities/ask_submission_entity.dart';
import 'package:unity_app/features/asks/domain/entities/ask_type_entity.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../../domain/entities/ask_response_item_entity.dart';
import '../bloc/ask_responses/ask_responses_bloc.dart';
import '../bloc/ask_responses/ask_responses_event.dart';
import '../bloc/ask_responses/ask_responses_state.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import '../widgets/referral_status_bottom_sheet.dart';

class AskResponsesListScreen extends StatefulWidget {
  final String askId;
  final String? askTitle;
  final String? flowName;
  final AskItemEntity? askItem;

  const AskResponsesListScreen({
    super.key,
    required this.askId,
    this.askTitle,
    this.flowName,
    this.askItem,
  });

  @override
  State<AskResponsesListScreen> createState() => _AskResponsesListScreenState();
}

class _AskResponsesListScreenState extends State<AskResponsesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AskResponsesBloc>().add(AskResponsesFetchRequested(widget.askId));
  }

  void _onChatWithPeer({
    required String peerId,
    required String peerName,
    String? peerAvatar,
    String? initialMessage,
  }) {
    if (peerId.isEmpty) return;
    Navigator.of(context).pushNamed(
      AppRoutes.directChat,
      arguments: {
        'peer_id': peerId,
        'peer_name': peerName,
        'peer_avatar': peerAvatar,
        'initial_message': initialMessage,
      },
    );
  }

  void _onViewPeerProfile(String? peerId) {
    if (peerId == null || peerId.isEmpty) return;
    Navigator.of(context).pushNamed(
      AppRoutes.peerProfile,
      arguments: peerId,
    );
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      AppSnackBar.showError(context, 'Unable to open phone dialer');
    }
  }

  Future<void> _openWhatsApp(String? phone, String? contactName) async {
    if (phone == null || phone.trim().isEmpty) return;
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final askTitle = widget.askTitle ?? widget.askItem?.title ?? 'our collaboration';
    final text = Uri.encodeComponent(
      'Hi${contactName != null ? " $contactName" : ""}, I received your contact on Peers Unity regarding the ask: "$askTitle". Would love to connect!',
    );
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$text');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      AppSnackBar.showError(context, 'Unable to open WhatsApp');
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.showSuccess(context, '$label copied to clipboard');
  }

  void _openReferralStatusBottomSheet(AskItemEntity item) {
    if (item.isReferralFinalStatus) {
      AppSnackBar.showInfo(
        context,
        'This referral is finalized as "${item.statusLabel}".',
      );
      return;
    }
    ReferralStatusBottomSheet.showForAskItem(
      context,
      item: item,
      onSelectStatus: (status) {
        context.read<MyAsksBloc>().add(
              UpdateAskStatusRequested(
                askId: item.id,
                status: status.name.toLowerCase().replaceAll(' ', '_'),
                statusId: status.id,
                outcomeStatus: status.name,
              ),
            );
        AppSnackBar.showSuccess(
          context,
          'Referral status updated to "${status.name}"',
        );
        setState(() {});
      },
    );
  }

  void _onMarkFulfilledWithResponder({
    required AskResponseItemEntity response,
    required String beneficiaryName,
    String? peerId,
    String? peerAvatar,
    String? peerCompany,
  }) {
    final flowCode = (widget.flowName ?? widget.askItem?.flowCode ?? 'collaboration').toLowerCase().trim();
    final isHelp = flowCode == 'help' || flowCode == 'advice' || flowCode == 'get_help';
    final isReferral = flowCode == 'referral' || flowCode == 'introduction' || flowCode == 'intro';

    final flow = AskFlowEntity(
      id: widget.askItem?.flowCode ?? flowCode,
      code: flowCode,
      name: widget.flowName ?? widget.askItem?.flowName ?? (isHelp ? 'Get Help' : (isReferral ? 'Ask for an Introduction' : 'Find a Collaborator')),
      description: '',
    );

    final type = AskTypeEntity(
      id: widget.askItem?.typeName ?? 'General',
      flowId: flow.id,
      code: widget.askItem?.typeName.toLowerCase().replaceAll(' ', '_') ?? 'partner',
      name: widget.askItem?.typeName ?? (isHelp ? 'Advice' : (isReferral ? 'Referral' : 'Partner')),
    );

    final effectivePeer = AskMatchPeerEntity(
      id: peerId ?? response.responder?.id ?? '',
      name: beneficiaryName,
      businessType: peerCompany ?? response.responder?.companyName ?? '',
      location: response.responder?.city ?? '',
      typeLabel: type.name,
      isTypeMatched: true,
      capitalLabel: '',
      isCapitalMatched: true,
      stageLabel: '',
      isStageMatched: true,
      peer: PeerEntity(
        id: peerId ?? response.responder?.id ?? '',
        displayName: beneficiaryName,
        companyName: peerCompany ?? response.responder?.companyName,
        profilePhotoUrl: peerAvatar ?? response.responder?.profilePhotoUrl,
      ),
    );

    final effectiveSubmission = AskSubmissionEntity(
      flow: flow,
      type: type,
      goal: widget.askTitle ?? widget.askItem?.title ?? 'Ask',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Select Fulfillment Action',
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: titleColor),
            ),
            const SizedBox(height: 4),
            Text(
              'With $beneficiaryName for this ask',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.askCollaborationRoom,
                  arguments: {
                    'peer': effectivePeer,
                    'submission': effectiveSubmission,
                    'isPoster': true,
                  },
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColor.badgeBlueBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.timeline_rounded, color: AppColor.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Open Collaboration Progress Room',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Track milestone stages & progress bar together',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(ctx).pop();
                final route = isHelp
                    ? AppRoutes.askHelpOutcome
                    : (isReferral
                        ? AppRoutes.askReferralOutcome
                        : AppRoutes.askCollaborationOutcome);
                Navigator.of(context).pushNamed(
                  route,
                  arguments: {
                    'peer': effectivePeer,
                    'submission': effectiveSubmission,
                  },
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D3328) : const Color(0xFFE6F4F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0E7A68).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E7A68).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.monetization_on_outlined, color: Color(0xFF0E7A68), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Record Business Deal & Outcome Now',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Directly log business unlocked & mark fulfilled',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final displayTitle = widget.askTitle ?? widget.askItem?.title ?? 'Ask Details';
    final displayFlow = widget.flowName ?? widget.askItem?.flowName ?? 'Collaboration';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppCommonBar(
        title: 'Responses & Interests',
        showBack: true,
      ),
      body: SafeArea(
        child: BlocBuilder<AskResponsesBloc, AskResponsesState>(
          builder: (context, state) {
            final responses = state.filteredResponses;

            return RefreshIndicator(
              color: AppColor.primaryBlue,
              onRefresh: () async {
                context.read<AskResponsesBloc>().add(
                      AskResponsesFetchRequested(widget.askId),
                    );
              },
              child: CustomScrollView(
                slivers: [
                  // Top Ask Summary Banner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColor.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                            width: 0.9,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 3.5),
                                  decoration: BoxDecoration(
                                    color: AppColor.badgeBlueBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    displayFlow,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primaryBlue,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${state.responses.length} response${state.responses.length == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.askItem != null &&
                                (widget.askItem!.flowCode == 'referral' ||
                                    widget.askItem!.flowName.toLowerCase().contains('referral') ||
                                    (widget.flowName?.toLowerCase().contains('referral') ?? false))) ...[
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: widget.askItem!.isReferralFinalStatus
                                    ? () {
                                        AppSnackBar.showInfo(
                                          context,
                                          'This referral is finalized as "${widget.askItem!.statusLabel}".',
                                        );
                                      }
                                    : () {
                                        ReferralStatusBottomSheet.showForAskItem(
                                          context,
                                          item: widget.askItem!,
                                          onSelectStatus: (selected) {
                                            context.read<MyAsksBloc>().add(
                                                  UpdateAskStatusRequested(
                                                    askId: widget.askItem!.id,
                                                    status: selected.name
                                                        .toLowerCase()
                                                        .replaceAll(' ', '_'),
                                                    statusId: selected.id,
                                                  ),
                                                );
                                            AppSnackBar.showSuccess(
                                              context,
                                              'Status updated to "${selected.name}"',
                                            );
                                          },
                                        );
                                      },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColor.darkSurfaceSubtle
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColor.darkBorder
                                          : AppColor.lightBorder,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        widget.askItem!.isReferralFinalStatus
                                            ? Icons.check_circle_outline_rounded
                                            : Icons.swap_horizontal_circle_outlined,
                                        size: 14,
                                        color: AppColor.primaryBlue,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Referral Status: ${widget.askItem!.statusLabel.isNotEmpty ? widget.askItem!.statusLabel : 'Open'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.primaryBlue,
                                        ),
                                      ),
                                      if (!widget.askItem!.isReferralFinalStatus) ...[
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.edit_outlined,
                                          size: 13,
                                          color: AppColor.primaryBlue,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              displayTitle,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Filter Pills (All, Direct Help, Referrals, Intros)
                  if (state.responses.isNotEmpty)
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Row(
                          children: [
                            _buildFilterPill(
                              label: 'All (${state.responses.length})',
                              code: 'all',
                              activeFilter: state.activeFilter,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 8),
                            if (state.directHelpCount > 0) ...[
                              _buildFilterPill(
                                label: 'Direct Help (${state.directHelpCount})',
                                code: 'direct_help',
                                activeFilter: state.activeFilter,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (state.referralCount > 0) ...[
                              _buildFilterPill(
                                label: 'Referrals (${state.referralCount})',
                                code: 'referral',
                                activeFilter: state.activeFilter,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (state.introCount > 0) ...[
                              _buildFilterPill(
                                label: 'Peer Intros (${state.introCount})',
                                code: 'intro',
                                activeFilter: state.activeFilter,
                                isDark: isDark,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  // Body Content
                  if (state.status == AskResponsesStatus.loading && state.responses.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  else if (state.status == AskResponsesStatus.error && state.responses.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppErrorView(
                        title: 'Unable to Load Responses',
                        message: state.errorMessage ?? 'Please check your connection and try again.',
                        onRetry: () => context
                            .read<AskResponsesBloc>()
                            .add(AskResponsesFetchRequested(widget.askId)),
                      ),
                    )
                  else if (responses.isEmpty)
                    if (widget.askItem != null &&
                        (widget.askItem!.referralOf.isNotEmpty ||
                            widget.askItem!.phone.isNotEmpty ||
                            widget.askItem!.toUserName.isNotEmpty ||
                            widget.askItem!.offeringInReturn.isNotEmpty ||
                            widget.askItem!.authorName.isNotEmpty))
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                        sliver: SliverToBoxAdapter(
                          child: _buildReferralLeadCardFromAskItem(
                            widget.askItem!,
                            isDark,
                            isDark ? AppColor.darkSurface : Colors.white,
                            isDark ? AppColor.darkBorder : AppColor.lightBorder,
                            titleColor,
                            bodyColor,
                            displayTitle,
                          ),
                        ),
                      )
                    else
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColor.darkSurfaceSubtle
                                        : const Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.handshake_outlined,
                                    size: 30,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'No responses yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: titleColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'When peers express interest, refer contacts, or introduce fellow peers to your ask, they will appear here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: subColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                      sliver: SliverList.builder(
                        itemCount: responses.length,
                        itemBuilder: (context, index) {
                          final item = responses[index];
                          return _buildResponseCard(item, isDark, displayTitle);
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

  Widget _buildFilterPill({
    required String label,
    required String code,
    required String activeFilter,
    required bool isDark,
  }) {
    final isSelected = activeFilter == code;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<AskResponsesBloc>().add(AskResponsesFilterChanged(code));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColor.brandGradient : null,
            color: isSelected
                ? null
                : (isDark ? AppColor.darkSurface : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    width: 0.8,
                  ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF334155)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReferralLeadCardFromAskItem(
    AskItemEntity item,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
    Color bodyColor,
    String askTitle,
  ) {
    final contactName = item.referralOf.isNotEmpty ? item.referralOf : item.title;
    final contactPhone = item.phone;
    final contactEmail = item.email;
    final contactAddress = item.address;
    final offering = item.offeringInReturn;
    final remarks = (item.rawData['remarks'] ?? '').toString();
    final authorName = item.authorName;
    final toUserName = item.toUserName;
    final hotValue = item.hotValue;
    final statusLabel = item.statusLabel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Given By / To + Status / Hot Value
          Row(
            children: [
              if (item.authorAvatar != null || authorName.isNotEmpty) ...[
                AppAvatar(
                  imageUrl: item.authorAvatar,
                  name: authorName.isNotEmpty ? authorName : 'Peer',
                  size: 34,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName.isNotEmpty ? authorName : 'Peer',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.authorCompany.isNotEmpty)
                        Text(
                          item.authorCompany,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Text(
                    'Referral Lead',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (hotValue > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA580C).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥 ', style: TextStyle(fontSize: 10)),
                      Text(
                        'Hot: $hotValue',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
              ],
              InkWell(
                onTap: item.isReferralFinalStatus ? null : () => _openReferralStatusBottomSheet(item),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF33200A) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        statusLabel,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        item.isReferralFinalStatus
                            ? Icons.check_circle_outline_rounded
                            : Icons.arrow_drop_down,
                        size: 14,
                        color: const Color(0xFFD97706),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Contact Details Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColor.badgeBlueBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_pin_rounded,
                        size: 20,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contactName,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                          ),
                          if (toUserName.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Referred to: $toUserName',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (contactPhone.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(
                        contactPhone,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: bodyColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _copyToClipboard(contactPhone, 'Phone number'),
                        child: const Icon(Icons.copy_rounded, size: 13, color: AppColor.primaryBlue),
                      ),
                    ],
                  ),
                ],
                if (contactEmail.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          contactEmail,
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                        ),
                      ),
                      InkWell(
                        onTap: () => _copyToClipboard(contactEmail, 'Email'),
                        child: const Icon(Icons.copy_rounded, size: 13, color: AppColor.primaryBlue),
                      ),
                    ],
                  ),
                ],
                if (contactAddress.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          contactAddress,
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ],
                if (offering.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 10, thickness: 0.6),
                  Text(
                    'Offering in return: $offering',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    ),
                  ),
                ],
                if (remarks.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Remarks: $remarks',
                    style: TextStyle(fontSize: 12, color: bodyColor, height: 1.3),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Actions Row
          Row(
            children: [
              if (contactPhone.isNotEmpty) ...[
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.phone_rounded,
                    label: 'Call',
                    onTap: () => _makeCall(contactPhone),
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.chat_outlined,
                    label: 'WhatsApp',
                    onTap: () => _openWhatsApp(contactPhone, contactName),
                    isPrimary: false,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (!item.isReferralFinalStatus)
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit_note_rounded,
                    label: 'Update Status',
                    onTap: () => _openReferralStatusBottomSheet(item),
                    isPrimary: false,
                    isSuccess: true,
                    isDark: isDark,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard(
    AskResponseItemEntity item,
    bool isDark,
    String askTitle,
  ) {
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    if (item.isContactReferral) {
      return _buildContactReferralCard(item, isDark, cardBg, borderColor, titleColor, bodyColor, askTitle);
    } else if (item.isPeerIntro) {
      return _buildPeerIntroCard(item, isDark, cardBg, borderColor, titleColor, bodyColor, askTitle);
    } else {
      return _buildDirectHelpCard(item, isDark, cardBg, borderColor, titleColor, bodyColor, askTitle);
    }
  }

  // 1. Direct Help Card
  Widget _buildDirectHelpCard(
    AskResponseItemEntity item,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
    Color bodyColor,
    String askTitle,
  ) {
    final responder = item.responder;
    final name = responder?.displayName ?? 'Peer';
    final company = responder?.companyName ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _onViewPeerProfile(responder?.id),
                child: AppAvatar(
                  imageUrl: responder?.profilePhotoUrl,
                  name: name,
                  size: 42,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onViewPeerProfile(responder?.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      if (company.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: AppColor.badgeBlueBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Direct Help',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          if (item.message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What they bring:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(fontSize: 13, color: bodyColor, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
          if (item.timeline.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 5),
                Text(
                  'Can start: ${item.timeline}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildActionButton(
                  icon: Icons.chat_outlined,
                  label: 'Message',
                  onTap: () => _onChatWithPeer(
                    peerId: responder?.id ?? '',
                    peerName: name,
                    peerAvatar: responder?.profilePhotoUrl,
                    initialMessage:
                        'Hi $name, thanks for offering to help with my ask: "$askTitle". Let\'s connect!',
                  ),
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: _buildActionButton(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () => _onViewPeerProfile(responder?.id),
                  isPrimary: false,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 3,
                child: _buildActionButton(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Fulfill',
                  onTap: () => _onMarkFulfilledWithResponder(
                    response: item,
                    beneficiaryName: name,
                    peerId: responder?.id,
                  ),
                  isPrimary: false,
                  isSuccess: true,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Contact Referral Card ("I Know Someone")
  Widget _buildContactReferralCard(
    AskResponseItemEntity item,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
    Color bodyColor,
    String askTitle,
  ) {
    final referrer = item.responder;
    final referrerName = referrer?.displayName ?? 'Peer';
    final contactName = item.contactName ?? 'Referred Contact';
    final contactPhone = item.contactPhone ?? '';
    final contactEmail = item.contactEmail;
    final contactCompany = item.contactCompany;
    final contactDesignation = item.contactDesignation;
    final contactAltPhone = item.contactAlternatePhone;
    final note = item.contactNote ?? item.message;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Referrer & Badge
          Row(
            children: [
              GestureDetector(
                onTap: () => _onViewPeerProfile(referrer?.id),
                child: AppAvatar(
                  imageUrl: referrer?.profilePhotoUrl,
                  name: referrerName,
                  size: 34,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onViewPeerProfile(referrer?.id),
                  child: RichText(
                    text: TextSpan(
                      text: 'Referred by ',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      children: [
                        TextSpan(
                          text: referrerName,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF33200A) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Contact Referral',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Contact Highlight Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: AppColor.badgeBlueBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 18,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contactName,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                          ),
                          if ((contactDesignation != null && contactDesignation.isNotEmpty) ||
                              (contactCompany != null && contactCompany.isNotEmpty)) ...[
                            const SizedBox(height: 2),
                            Text(
                              [
                                if (contactDesignation != null && contactDesignation.isNotEmpty)
                                  contactDesignation,
                                if (contactCompany != null && contactCompany.isNotEmpty)
                                  contactCompany,
                              ].join(' • '),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (contactPhone.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(
                        contactPhone,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: bodyColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _copyToClipboard(contactPhone, 'Phone number'),
                        child: const Icon(Icons.copy_rounded, size: 13, color: AppColor.primaryBlue),
                      ),
                    ],
                  ),
                ],
                if (contactAltPhone != null && contactAltPhone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone_android_rounded, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text(
                        contactAltPhone,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: bodyColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _copyToClipboard(contactAltPhone, 'Alternate phone'),
                        child: const Icon(Icons.copy_rounded, size: 13, color: AppColor.primaryBlue),
                      ),
                    ],
                  ),
                ],
                if (contactEmail != null && contactEmail.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          contactEmail,
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ],
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 12, thickness: 0.6),
                  Text(
                    'Why recommended:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    note,
                    style: TextStyle(fontSize: 12.5, color: bodyColor, height: 1.35),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Action Buttons
          Row(
            children: [
              if (contactPhone.isNotEmpty) ...[
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.phone_rounded,
                    label: 'Call',
                    onTap: () => _makeCall(contactPhone),
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.chat_outlined,
                    label: 'WhatsApp',
                    onTap: () => _openWhatsApp(contactPhone, contactName),
                    isPrimary: false,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: _buildActionButton(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Fulfill',
                  onTap: () => _onMarkFulfilledWithResponder(
                    response: item,
                    beneficiaryName: contactName,
                    peerId: referrer?.id,
                  ),
                  isPrimary: false,
                  isSuccess: true,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Peer Introduction Card ("I can introduce a peer")
  Widget _buildPeerIntroCard(
    AskResponseItemEntity item,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
    Color bodyColor,
    String askTitle,
  ) {
    final introducer = item.responder;
    final introducerName = introducer?.displayName ?? 'Peer';
    final introducedPeer = item.introducedPeer;
    final introducedId = item.introducedPeerId ?? introducedPeer?.id ?? '';
    final introducedName = item.introducedPeerName ?? introducedPeer?.displayName ?? 'Introduced Peer';
    final introducedCompany = item.introducedPeerCompany ?? introducedPeer?.companyName ?? '';
    final introducedAvatar = item.introducedPeerAvatar ?? introducedPeer?.profilePhotoUrl;
    final note = item.introductionNote ?? item.message;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introducer banner
          Row(
            children: [
              GestureDetector(
                onTap: () => _onViewPeerProfile(introducer?.id),
                child: AppAvatar(
                  imageUrl: introducer?.profilePhotoUrl,
                  name: introducerName,
                  size: 34,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onViewPeerProfile(introducer?.id),
                  child: RichText(
                    text: TextSpan(
                      text: 'Introduced by ',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      children: [
                        TextSpan(
                          text: introducerName,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF28183E) : const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Peer Intro',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9333EA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Introduced Peer Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _onViewPeerProfile(introducedId),
                      child: AppAvatar(
                        imageUrl: introducedAvatar,
                        name: introducedName,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onViewPeerProfile(introducedId),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              introducedName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                            if (introducedCompany.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                introducedCompany,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 12, thickness: 0.6),
                  Text(
                    'Introduction note:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    note,
                    style: TextStyle(fontSize: 12.5, color: bodyColor, height: 1.35),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildActionButton(
                  icon: Icons.chat_outlined,
                  label: 'Chat',
                  onTap: () => _onChatWithPeer(
                    peerId: introducedId,
                    peerName: introducedName,
                    peerAvatar: introducedAvatar,
                    initialMessage:
                        'Hi $introducedName, $introducerName introduced us regarding my ask: "$askTitle". Excited to connect!',
                  ),
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: _buildActionButton(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () => _onViewPeerProfile(introducedId),
                  isPrimary: false,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 3,
                child: _buildActionButton(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Fulfill',
                  onTap: () => _onMarkFulfilledWithResponder(
                    response: item,
                    beneficiaryName: introducedName,
                    peerId: introducedId,
                  ),
                  isPrimary: false,
                  isSuccess: true,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    bool isSuccess = false,
    bool isDark = false,
  }) {
    if (isPrimary) {
      return Container(
        height: 36,
        decoration: BoxDecoration(
          gradient: AppColor.brandGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isSuccess) {
      return Container(
        height: 36,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D3328) : const Color(0xFFE6F4F1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF0E7A68).withValues(alpha: 0.3),
          ),
        ),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            foregroundColor: const Color(0xFF0E7A68),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF0E7A68)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E7A68),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          foregroundColor: isDark ? Colors.white : const Color(0xFF334155),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
