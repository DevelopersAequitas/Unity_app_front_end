import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import 'circular_detail_screen.dart';

class CircularsScreen extends StatefulWidget {
  const CircularsScreen({super.key});

  @override
  State<CircularsScreen> createState() => _CircularsScreenState();
}

class _CircularsScreenState extends State<CircularsScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchCirculars();
  }

  Future<void> _fetchCirculars() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final res = await _dio.dio.get(ApiEndpoints.circulars);
      final data = res.data;
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        raw = data['data']?['items'] as List? ?? data['items'] as List? ?? [];
      } else if (data is List) {
        raw = data;
      }
      if (mounted) {
        setState(() {
          _items = raw.whereType<Map<String, dynamic>>().toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load announcements. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Circulars & Notices',
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
        onRefresh: _fetchCirculars,
        color: AppColor.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildShimmerCard(),
      );
    }

    if (_errorMessage != null && _items.isEmpty) {
      return AppErrorView(
        title: 'Unable to Load Circulars',
        message: _errorMessage,
        onRetry: _fetchCirculars,
        screenName: 'Circulars & Notices',
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_outlined, size: 28, color: AppColor.primaryBlue),
              ),
              const SizedBox(height: 16),
              Text(
                'No Circulars Available',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Official notices and circular updates will appear here.',
                style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {

        final item = _items[index];
        final id = item['id']?.toString() ?? '';
        final title = item['title']?.toString() ?? 'Notice';
        final summary = item['summary']?.toString() ?? item['description']?.toString() ?? '';
        final priority = item['priority']?.toString().toLowerCase() ?? '';
        final isUrgent = priority == 'urgent' || priority == 'high';

        return InkWell(
          onTap: () {
            if (id.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CircularDetailScreen(circularId: id, initialTitle: title),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isUrgent ? AppColor.error.withValues(alpha: 0.3) : AppColor.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColor.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'URGENT',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColor.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColor.lightTextDisabled),
                  ],
                ),
                if (summary.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 140, height: 16, color: AppColor.lightSurfaceSubtle),
          const SizedBox(height: 12),
          Container(width: double.infinity, height: 12, color: AppColor.lightSurfaceSubtle),
        ],
      ),
    );
  }
}
