import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../profile/presentation/bloc/profile_posts_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_event.dart';
import '../../domain/entities/post_report_reason_entity.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/usecases/get_post_report_reasons_usecase.dart';
import '../../domain/usecases/report_post_usecase.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

/// A bottom sheet for reporting a post with dynamic reason selection and hiding reported posts.
class ReportPostBottomSheet extends StatefulWidget {
  final TimelineItemEntity item;
  final HomeBloc? homeBloc;
  final ProfilePostsBloc? profilePostsBloc;

  const ReportPostBottomSheet({
    super.key,
    required this.item,
    this.homeBloc,
    this.profilePostsBloc,
  });

  static Future<void> show(BuildContext context, {required TimelineItemEntity item}) {
    HomeBloc? homeBloc;
    ProfilePostsBloc? profilePostsBloc;
    try {
      homeBloc = context.read<HomeBloc>();
    } catch (_) {}
    try {
      profilePostsBloc = context.read<ProfilePostsBloc>();
    } catch (_) {}

    final reportUseCase = context.read<ReportPostUseCase>();
    final getReasonsUseCase = context.read<GetPostReportReasonsUseCase>();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ReportPostUseCase>.value(value: reportUseCase),
          RepositoryProvider<GetPostReportReasonsUseCase>.value(value: getReasonsUseCase),
        ],
        child: ReportPostBottomSheet(
          item: item,
          homeBloc: homeBloc,
          profilePostsBloc: profilePostsBloc,
        ),
      ),
    );
  }

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  PostReportReasonEntity? _selectedReason;
  List<PostReportReasonEntity> _reasons = [];
  bool _isLoadingReasons = true;
  bool _isSubmitting = false;

  static const List<PostReportReasonEntity> _defaultReasons = [
    PostReportReasonEntity(id: 1, title: 'Spam or Misleading'),
    PostReportReasonEntity(id: 2, title: 'Harassment or Hate Speech'),
    PostReportReasonEntity(id: 3, title: 'Inappropriate Content'),
    PostReportReasonEntity(id: 4, title: 'Violence or Self-Harm'),
    PostReportReasonEntity(id: 5, title: 'Something Else'),
  ];

  @override
  void initState() {
    super.initState();
    _loadReasons();
  }

  Future<void> _loadReasons() async {
    try {
      final getReasonsUseCase = context.read<GetPostReportReasonsUseCase>();
      final items = await getReasonsUseCase();
      if (mounted) {
        setState(() {
          _reasons = items.isNotEmpty ? items : _defaultReasons;
          _isLoadingReasons = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _reasons = _defaultReasons;
          _isLoadingReasons = false;
        });
      }
    }
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      AppSnackBar.showInfo(context, 'Please select a reason to report');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final reportUseCase = context.read<ReportPostUseCase>();
      await reportUseCase(widget.item.id, _selectedReason!.id);

      // Hide the post immediately from the home feed and profile
      widget.homeBloc?.add(HomePostReported(
        postId: widget.item.id,
        reasonId: _selectedReason!.id,
      ));
      widget.profilePostsBloc?.add(ProfilePostDeleted(widget.item.id));

      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.showSuccess(
          context,
          'Post reported and hidden from your feed',
        );
      }
    } catch (e) {
      // Even if already reported or on error, hide from feed for a seamless UX
      widget.homeBloc?.add(HomePostHidden(widget.item.id));
      widget.profilePostsBloc?.add(ProfilePostDeleted(widget.item.id));

      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.showSuccess(
          context,
          'Post reported and hidden from your feed',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : Colors.white;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final displayReasons = _reasons.isNotEmpty ? _reasons : _defaultReasons;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flag_outlined, color: AppColor.warning, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Report Post',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: secondaryTextColor, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Text(
                'Why are you reporting this post? Your feedback helps keep Peers safe.',
                style: AppTypography.bodySmall.copyWith(color: secondaryTextColor, height: 1.4),
              ),
              const SizedBox(height: 16),

              if (_isLoadingReasons)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                // Radio options
                ...displayReasons.map((reason) {
                  final isSelected = _selectedReason?.id == reason.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedReason = reason),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.warning.withValues(alpha: 0.7)
                              : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        color: isSelected
                            ? AppColor.warning.withValues(alpha: 0.06)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColor.warning : secondaryTextColor,
                                width: isSelected ? 0 : 1.5,
                              ),
                              color: isSelected ? AppColor.warning : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 11, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reason.title,
                              style: AppTypography.bodySmall.copyWith(
                                color: primaryTextColor,
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 16),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.warning,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColor.warning.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit Report',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
