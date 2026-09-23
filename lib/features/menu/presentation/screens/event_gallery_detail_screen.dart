import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';


class EventGalleryDetailScreen extends StatefulWidget {
  final String eventId;
  final String title;

  const EventGalleryDetailScreen({
    super.key,
    required this.eventId,
    required this.title,
  });

  @override
  State<EventGalleryDetailScreen> createState() => _EventGalleryDetailScreenState();
}

class _EventGalleryDetailScreenState extends State<EventGalleryDetailScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final res = await _dio.dio.get(ApiEndpoints.eventGalleryDetail(widget.eventId));
      final data = res.data;
      List<dynamic> items = [];
      if (data is Map<String, dynamic>) {
        items = data['data']?['images'] as List? ?? data['images'] as List? ?? [];
      } else if (data is List) {
        items = data;
      }
      final urls = items
          .map((e) => e is Map ? (e['url'] ?? e['image_url'] ?? '').toString() : e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
      if (mounted) {
        setState(() {
          _images = urls;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load album photos.';
          _isLoading = false;
        });
      }
    }
  }

  void _openFullPhoto(int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: _images.length,
            itemBuilder: (_, index) => Center(
              child: Image.network(_images[index], fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          widget.title,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColor.primaryBlue))
          : _errorMessage != null
              ? AppErrorView(
                  title: 'Unable to Load Photos',
                  message: _errorMessage,
                  onRetry: _fetchDetail,
                  screenName: 'Album Photos',
                )
              : _images.isEmpty
                  ? Center(
                      child: Text(
                        'No photos in this album.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        final url = _images[index];
                        return InkWell(
                          onTap: () => _openFullPhoto(index),
                          borderRadius: BorderRadius.circular(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColor.lightSurfaceSubtle,
                                child: const Icon(Icons.broken_image_outlined, color: AppColor.lightTextDisabled),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
