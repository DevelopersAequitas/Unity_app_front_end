import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../widgets/event_video_card.dart';

class EventVideosScreen extends StatefulWidget {
  const EventVideosScreen({super.key});

  @override
  State<EventVideosScreen> createState() => _EventVideosScreenState();
}

class _EventVideosScreenState extends State<EventVideosScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      dynamic res;
      try {
        res = await _dio.dio.get(ApiEndpoints.eventVideos);
      } catch (_) {
        try {
          res = await _dio.dio.get('/intro-videos');
        } catch (_) {
          res = await _dio.dio.get(ApiEndpoints.tutorials);
        }
      }
      final data = res?.data;
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        raw = data['data']?['items'] as List? ??
            data['data']?['videos'] as List? ??
            data['items'] as List? ??
            data['data'] as List? ??
            [];
      } else if (data is List) {
        raw = data;
      }
      if (mounted) {
        setState(() {
          _videos = raw.whereType<Map<String, dynamic>>().toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _playVideo(String url) async {
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
          'Event Videos',
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
        onRefresh: _fetchVideos,
        color: AppColor.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
        ),
      );
    }

    if (_errorMessage != null && _videos.isEmpty) {
      return AppErrorView(
        title: 'Unable to Load Videos',
        message: _errorMessage,
        onRetry: _fetchVideos,
        screenName: 'Event Videos',
      );
    }

    if (_videos.isEmpty) {
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
                  color: AppColor.primaryPink.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_circle_outline_rounded, size: 28, color: AppColor.primaryPink),
              ),
              const SizedBox(height: 16),
              Text(
                'No Event Videos Yet',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Recordings and highlight reels will appear here.',
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
      itemCount: _videos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = _videos[index];
        final title = item['title']?.toString() ?? 'Event Video';
        final videoUrl = item['video_url']?.toString() ?? item['url']?.toString() ?? '';
        final thumbUrl = item['thumbnail_url']?.toString() ?? item['cover_url']?.toString() ?? '';

        return EventVideoCard(
          title: title,
          thumbUrl: thumbUrl,
          onPlay: () => _playVideo(videoUrl),
        );
      },
    );
  }
}

