import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import '../../domain/usecases/get_my_join_requests_usecase.dart';

class JoinRequestStatusScreen extends StatefulWidget {
  final String requestId;
  final String circleName;

  const JoinRequestStatusScreen({
    super.key,
    required this.requestId,
    required this.circleName,
  });

  @override
  State<JoinRequestStatusScreen> createState() => _JoinRequestStatusScreenState();
}

class _JoinRequestStatusScreenState extends State<JoinRequestStatusScreen> {
  CircleJoinRequestEntity? _request;
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
    _pollingTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      if (mounted && _request != null && !_request!.isApproved && !_request!.isRejected) {
        _fetchStatus(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStatus({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }

    try {
      final useCase = context.read<GetMyJoinRequestsUseCase>();
      final requests = await useCase();

      if (!mounted) return;

      final found = requests.firstWhere(
        (r) => r.id == widget.requestId || r.circleName.toLowerCase() == widget.circleName.toLowerCase(),
        orElse: () => CircleJoinRequestEntity(
          id: widget.requestId,
          circleId: '',
          circleName: widget.circleName,
          reasonForJoining: '',
          status: 'pending',
          statusLabel: 'Pending Approval',
          displayStatus: 'Pending',
          paymentStatus: 'unpaid',
          requestedAt: DateTime.now(),
          cdApprovalStatus: 'pending',
          idApprovalStatus: 'pending',
        ),
      );

      setState(() {
        _isLoading = false;
        _request = found;
      });
    } catch (_) {
      if (!mounted) return;
      if (!silent) setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePayment(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Join ${widget.circleName}',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: _isLoading && _request == null
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primaryBlue,
                  ),
                )
              : RefreshIndicator(
                  color: AppColor.primaryBlue,
                  onRefresh: () => _fetchStatus(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusHeader(isDark, cardBg, borderColor, primaryText),
                        const SizedBox(height: 16),
                        _buildTimeline(isDark, cardBg, borderColor, primaryText),
                        if (_request != null && _request!.paymentUrl != null && !_request!.isApproved) ...[
                          const SizedBox(height: 16),
                          _buildPaymentSection(cardBg, borderColor, primaryText),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(bool isDark, Color cardBg, Color borderColor, Color primaryText) {
    final req = _request;
    final isApproved = req?.isApproved ?? false;
    final isRejected = req?.isRejected ?? false;

    final title = isApproved
        ? 'Membership Approved'
        : isRejected
            ? 'Request Rejected'
            : 'Pending Approval';
    final subtitle = isApproved
        ? 'Welcome to ${widget.circleName}! 🎉'
        : isRejected
            ? (req?.rejectionReason ?? 'Your request did not meet circle criteria.')
            : 'Your request has been submitted and is currently being reviewed.';
    final icon = isApproved
        ? Icons.check_circle_rounded
        : isRejected
            ? Icons.cancel_rounded
            : Icons.hourglass_top_rounded;
    final iconColor = isApproved
        ? Colors.green
        : isRejected
            ? AppColor.primaryPink
            : AppColor.primaryBlue;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 11,
                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(bool isDark, Color cardBg, Color borderColor, Color primaryText) {
    final req = _request;
    final cdApproved = req?.cdApprovalStatus == 'approved';
    final cdRejected = req?.cdApprovalStatus == 'rejected';
    final cdPending = req?.cdApprovalStatus == 'pending';

    final idApproved = req?.idApprovalStatus == 'approved';
    final idRejected = req?.idApprovalStatus == 'rejected';
    final idPending = req?.idApprovalStatus == 'pending';

    final isPaid = req?.paymentStatus == 'paid';
    final isApproved = req?.isApproved ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Progress',
            style: AppTypography.labelSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 16),
          const _TimelineStep(
            title: 'Request Submitted',
            subtitle: 'Application sent successfully',
            status: 'completed',
            icon: Icons.send_rounded,
          ),
          _TimelineStep(
            title: 'Circle Director Approval',
            subtitle: cdApproved ? 'Approved by Circle Director' : cdRejected ? 'Rejected' : cdPending ? 'Under review' : 'Waiting',
            status: cdApproved ? 'completed' : cdRejected ? 'rejected' : cdPending ? 'in_progress' : 'inactive',
            icon: Icons.assignment_ind_rounded,
          ),
          _TimelineStep(
            title: 'Industry Director Approval',
            subtitle: idApproved ? 'Approved by Industry Director' : idRejected ? 'Rejected' : idPending ? 'Under review' : 'Waiting',
            status: idApproved ? 'completed' : idRejected ? 'rejected' : idPending ? 'in_progress' : 'inactive',
            icon: Icons.business_rounded,
          ),
          _TimelineStep(
            title: 'Circle Fee Payment',
            subtitle: isPaid ? 'Payment successful' : 'Fee payment verification',
            status: isPaid ? 'completed' : (cdApproved && idApproved && !isPaid) ? 'in_progress' : 'inactive',
            icon: Icons.payment_rounded,
          ),
          _TimelineStep(
            title: 'Membership Active',
            subtitle: isApproved ? 'Welcome to the circle!' : 'Final activation step',
            status: isApproved ? 'completed' : 'inactive',
            icon: Icons.check_circle_rounded,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(Color cardBg, Color borderColor, Color primaryText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete Circle Fee Payment',
            style: AppTypography.labelSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handlePayment(_request!.paymentUrl!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Pay Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDone = status == 'completed';
    final isProgress = status == 'in_progress';
    final isRejected = status == 'rejected';

    final color = isDone
        ? Colors.green
        : isRejected
            ? AppColor.primaryPink
            : isProgress
                ? AppColor.primaryBlue
                : (isDark ? AppColor.darkTextSecondary.withValues(alpha: 0.4) : AppColor.lightTextSecondary.withValues(alpha: 0.4));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.2),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 28,
                color: color.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 10.5,
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
              ),
              if (!isLast) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
