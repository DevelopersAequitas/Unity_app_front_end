import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class CircularDetailScreen extends StatefulWidget {
  final String circularId;
  final String? initialTitle;

  const CircularDetailScreen({
    super.key,
    required this.circularId,
    this.initialTitle,
  });

  @override
  State<CircularDetailScreen> createState() => _CircularDetailScreenState();
}

class _CircularDetailScreenState extends State<CircularDetailScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _detail;

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
      final res = await _dio.dio.get(ApiEndpoints.circularDetail(widget.circularId));
      final data = res.data;
      Map<String, dynamic>? item;
      if (data is Map<String, dynamic>) {
        item = data['data'] as Map<String, dynamic>? ?? data;
      }
      if (mounted) {
        setState(() {
          _detail = item;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load circular details.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _detail?['title']?.toString() ?? widget.initialTitle ?? 'Circular Detail';
    final content = _detail?['content']?.toString() ?? _detail?['description']?.toString() ?? '';
    final createdAt = _detail?['created_at']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Notice Details',
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
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.lightTextTertiary),
                        const SizedBox(height: 8),
                        Text(_errorMessage!, style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary)),
                        const SizedBox(height: 12),
                        OutlinedButton(onPressed: _fetchDetail, child: const Text('Try Again')),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.lightTextPrimary,
                          ),
                        ),
                        if (createdAt.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Published on $createdAt',
                            style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextDisabled),
                          ),
                        ],
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: AppColor.lightBorder),
                        const SizedBox(height: 16),
                        Text(
                          content.isNotEmpty ? content : 'No detailed description available.',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColor.lightTextPrimary,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
