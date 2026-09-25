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
  int _dealsGiven = 0;
  int _dealsReceived = 0;
  int _referralsGiven = 0;
  int _testimonialsGiven = 0;
  int _registeredVisitors = 0;
  int _recommendedPeers = 0;
  int _listedRequirements = 0;
  String _periodText = 'Last 30 Days';

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    setState(() => _isLoading = true);

    try {
      final res = await _dio.dio.get(ApiEndpoints.lastMonthActivity);
      final data = res.data;
      if (data is Map<String, dynamic>) {
        final raw = (data['data'] is Map<String, dynamic>)
            ? data['data'] as Map<String, dynamic>
            : data;
        final activities = raw['activities'] as Map<String, dynamic>? ?? {};
        final period = raw['period'] as Map<String, dynamic>? ?? {};

        int parseCount(String key) {
          final item = activities[key];
          if (item is Map<String, dynamic>) {
            final c = item['count'];
            if (c is num) return c.toInt();
            if (c != null) return int.tryParse(c.toString()) ?? 0;
          } else if (item is num) {
            return item.toInt();
          }
          return 0;
        }

        final p2p = parseCount('p2p_meetings');
        final dealsRec = parseCount('business_deals_received');
        final dealsGiv = parseCount('business_deals_given');
        final refGiv = parseCount('referrals_given');
        final testGiv = parseCount('testimonials_given');
        final vis = parseCount('registered_visitors');
        final recPeers = parseCount('recommended_peers');
        final reqs = parseCount('listed_requirements');

        final sDate = period['start_date']?.toString();
        final eDate = period['end_date']?.toString();
        final totalDays = period['total_days'] ?? 30;
        final pText = (sDate != null &&
                eDate != null &&
                sDate.isNotEmpty &&
                eDate.isNotEmpty)
            ? '$sDate to $eDate'
            : 'Last $totalDays Days';

        if (mounted) {
          setState(() {
            _p2p = p2p;
            _dealsGiven = dealsGiv;
            _dealsReceived = dealsRec;
            _referralsGiven = refGiv;
            _testimonialsGiven = testGiv;
            _registeredVisitors = vis;
            _recommendedPeers = recPeers;
            _listedRequirements = reqs;
            _periodText = pText;
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
          _referralsGiven = p.referralsCount;
          _dealsGiven = p.businessDealsCount;
          _testimonialsGiven = p.testimonialsCount;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  int get _totalActivities =>
      _p2p +
      _dealsGiven +
      _dealsReceived +
      _referralsGiven +
      _testimonialsGiven +
      _listedRequirements +
      _registeredVisitors +
      _recommendedPeers;

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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.lightTextPrimary,
          ),
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
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Top Highlight Card
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
                'TOTAL ACTIVITIES • $_periodText'.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _totalActivities.toString(),
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 42,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Collaborations & community interactions completed',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'ACTIVITY COUNTS BREAKDOWN',
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.lightTextSecondary,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActivityMetricCard(
                label: 'P2P Meetings',
                value: '$_p2p',
                icon: Icons.people_outline_rounded,
                color: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActivityMetricCard(
                label: 'Referrals Given',
                value: '$_referralsGiven',
                icon: Icons.card_giftcard_rounded,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActivityMetricCard(
                label: 'Deals Given',
                value: '$_dealsGiven',
                icon: Icons.handshake_outlined,
                color: const Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActivityMetricCard(
                label: 'Deals Received',
                value: '$_dealsReceived',
                icon: Icons.payments_outlined,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActivityMetricCard(
                label: 'Testimonials Given',
                value: '$_testimonialsGiven',
                icon: Icons.star_outline_rounded,
                color: const Color(0xFFEC4899),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActivityMetricCard(
                label: 'Listed Requirements',
                value: '$_listedRequirements',
                icon: Icons.assignment_outlined,
                color: const Color(0xFF06B6D4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActivityMetricCard(
                label: 'Visitors Registered',
                value: '$_registeredVisitors',
                icon: Icons.person_add_alt_1_outlined,
                color: const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActivityMetricCard(
                label: 'Peers Recommended',
                value: '$_recommendedPeers',
                icon: Icons.thumb_up_alt_outlined,
                color: const Color(0xFF14B8A6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
