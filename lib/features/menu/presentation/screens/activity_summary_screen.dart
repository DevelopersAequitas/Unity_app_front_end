import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../widgets/activity_metric_card.dart';

class ActivitySummaryScreen extends StatefulWidget {
  const ActivitySummaryScreen({super.key});

  @override
  State<ActivitySummaryScreen> createState() => _ActivitySummaryScreenState();
}

class _ActivitySummaryScreenState extends State<ActivitySummaryScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  int _p2p = 0;
  int _referrals = 0;
  int _deals = 0;
  int _testimonials = 0;
  int _impactScore = 0;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    setState(() => _isLoading = true);

    try {
      dynamic res;
      try {
        res = await _dio.dio.get(ApiEndpoints.lastMonthActivity);
      } catch (_) {
        try {
          res = await _dio.dio.get(ApiEndpoints.dailySummary);
        } catch (_) {
          res = await _dio.dio.get(ApiEndpoints.profile);
        }
      }

      final data = res?.data;
      if (data is Map<String, dynamic>) {
        final raw = data['data'] as Map<String, dynamic>? ?? data;
        final counts = raw['counts'] as Map<String, dynamic>? ?? {};
        final period = raw['period'] as Map<String, dynamic>? ?? {};
        final user = raw['user'] as Map<String, dynamic>? ?? {};

        final p2pVal = counts['p2p_meetings'] ?? raw['p2p_meetings_count'] ?? user['p2p_meetings_count'] ?? 0;
        final refGiven = counts['referrals_given'] ?? 0;
        final refRecv = counts['referrals_received'] ?? 0;
        final refVal = (refGiven is num && refRecv is num && (refGiven > 0 || refRecv > 0))
            ? (refGiven + refRecv).toInt()
            : (raw['referrals_count'] ?? user['referrals_count'] ?? 0);
        final dealsVal = counts['business_deals'] ?? raw['business_deals_count'] ?? user['business_deals_count'] ?? 0;
        final testVal = counts['testimonials'] ?? raw['testimonials_count'] ?? user['testimonials_count'] ?? 0;
        final impactVal = period['total_lives_impacted_last_30_days'] ??
            raw['impact_score'] ??
            raw['lives_impacted_count'] ??
            user['life_impacted_count'] ??
            0;

        if (mounted) {
          setState(() {
            _p2p = (p2pVal is num) ? p2pVal.toInt() : int.tryParse(p2pVal.toString()) ?? 0;
            _referrals = (refVal is num) ? refVal.toInt() : int.tryParse(refVal.toString()) ?? 0;
            _deals = (dealsVal is num) ? dealsVal.toInt() : int.tryParse(dealsVal.toString()) ?? 0;
            _testimonials = (testVal is num) ? testVal.toInt() : int.tryParse(testVal.toString()) ?? 0;
            _impactScore = (impactVal is num) ? impactVal.toInt() : int.tryParse(impactVal.toString()) ?? 0;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      final profileState = context.read<ProfileBloc>().state;
      if (profileState.profile != null) {
        final p = profileState.profile!;
        setState(() {
          _p2p = p.p2pMeetingsCount;
          _referrals = p.referralsCount;
          _deals = p.businessDealsCount;
          _testimonials = p.testimonialsCount;
          _impactScore = p.lifeImpactedCount;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Activity Summary',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchSummary,
        color: AppColor.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColor.primaryBlue));
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColor.brandGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryPink.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'LIVES IMPACT SCORE',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _impactScore.toString(),
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Calculated from your peer collaboration activities',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'CONTRIBUTION BREAKDOWN',
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.lightTextSecondary,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ActivityMetricCard(label: 'P2P Meetings', value: '$_p2p', icon: Icons.people_outline_rounded, color: AppColor.primaryBlue)),
            const SizedBox(width: 12),
            Expanded(child: ActivityMetricCard(label: 'Referrals Passed', value: '$_referrals', icon: Icons.card_giftcard_rounded, color: AppColor.success)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ActivityMetricCard(label: 'Business Deals', value: '$_deals', icon: Icons.handshake_outlined, color: AppColor.warning)),
            const SizedBox(width: 12),
            Expanded(child: ActivityMetricCard(label: 'Testimonials', value: '$_testimonials', icon: Icons.star_outline_rounded, color: AppColor.primaryPink)),
          ],
        ),
      ],
    );
  }
}
