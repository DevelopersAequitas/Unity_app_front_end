import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _tutorials = [];

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
  }

  Future<void> _fetchTutorials() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final res = await _dio.dio.get(ApiEndpoints.tutorials);
      final data = res.data;
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        raw = data['data']?['items'] as List? ?? data['items'] as List? ?? [];
      } else if (data is List) {
        raw = data;
      }
      if (mounted) {
        setState(() {
          _tutorials = raw.whereType<Map<String, dynamic>>().toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load tutorials.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openTutorial(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Tutorials & Guides',
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
        onRefresh: _fetchTutorials,
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
        itemBuilder: (context, index) => Container(
          height: 76,
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
        ),
      );
    }

    if (_errorMessage != null && _tutorials.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.lightTextTertiary),
              const SizedBox(height: 8),
              Text(_errorMessage!, style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary)),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: _fetchTutorials, child: const Text('Try Again')),
            ],
          ),
        ),
      );
    }

    if (_tutorials.isEmpty) {
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
                child: const Icon(Icons.school_outlined, size: 28, color: AppColor.primaryBlue),
              ),
              const SizedBox(height: 16),
              Text(
                'No Tutorials Available',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Helpful guides on maximizing your Unity network will be published here.',
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
      itemCount: _tutorials.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {

        final item = _tutorials[index];
        final title = item['title']?.toString() ?? 'Tutorial';
        final duration = item['duration']?.toString() ?? '';
        final url = item['url']?.toString() ?? item['video_url']?.toString() ?? '';

        return InkWell(
          onTap: () => _openTutorial(url),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_circle_outline_rounded, color: AppColor.primaryBlue, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (duration.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          duration,
                          style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new_rounded, size: 16, color: AppColor.lightTextDisabled),
              ],
            ),
          ),
        );
      },
    );
  }
}
