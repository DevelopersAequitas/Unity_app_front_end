import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../widgets/gallery_album_card.dart';
import 'event_gallery_detail_screen.dart';

class EventGalleryScreen extends StatefulWidget {
  const EventGalleryScreen({super.key});

  @override
  State<EventGalleryScreen> createState() => _EventGalleryScreenState();
}

class _EventGalleryScreenState extends State<EventGalleryScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchGalleries();
  }

  Future<void> _fetchGalleries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      dynamic res;
      try {
        res = await _dio.dio.get(ApiEndpoints.eventGalleries);
      } catch (_) {
        try {
          res = await _dio.dio.get('/events');
        } catch (_) {
          res = await _dio.dio.get('/events/all');
        }
      }
      final data = res?.data;
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        raw = data['data']?['items'] as List? ??
            data['data']?['galleries'] as List? ??
            data['items'] as List? ??
            data['data'] as List? ??
            [];
      } else if (data is List) {
        raw = data;
      }
      if (mounted) {
        setState(() {
          _events = raw.whereType<Map<String, dynamic>>().toList();
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

  void _openDetail(String id, String title) {
    if (id.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EventGalleryDetailScreen(eventId: id, title: title),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Event Gallery',
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
        onRefresh: _fetchGalleries,
        color: AppColor.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
        ),
      );
    }

    if (_errorMessage != null && _events.isEmpty) {
      return AppErrorView(
        title: 'Unable to Load Galleries',
        message: _errorMessage,
        onRetry: _fetchGalleries,
        screenName: 'Event Gallery',
      );
    }

    if (_events.isEmpty) {
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
                child: const Icon(Icons.photo_library_outlined, size: 28, color: AppColor.primaryPink),
              ),
              const SizedBox(height: 16),
              Text(
                'No Galleries Available',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Photo albums and event photos will be posted here.',
                style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final item = _events[index];
        final id = item['id']?.toString() ?? '';
        final title = item['title']?.toString() ?? item['name']?.toString() ?? 'Event';
        final count = item['photos_count']?.toString() ?? item['count']?.toString() ?? '${(item['images'] as List?)?.length ?? 0}';
        final coverUrl = item['cover_url']?.toString() ?? item['cover_image']?.toString() ?? '';

        return GalleryAlbumCard(
          title: title,
          count: count,
          coverUrl: coverUrl,
          onTap: () => _openDetail(id, title),
        );
      },
    );
  }
}

