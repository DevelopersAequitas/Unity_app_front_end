import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../bloc/ask_submission/ask_submission_bloc.dart';
import '../bloc/ask_submission/ask_submission_event.dart';
import '../bloc/ask_submission/ask_submission_state.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import '../bloc/peers_feed/peers_feed_bloc.dart';
import '../bloc/peers_feed/peers_feed_event.dart';
import '../widgets/ask_preview_card.dart';
import '../widgets/ask_step_header.dart';

class AskStep3PreviewScreen extends StatefulWidget {
  final AskSubmissionEntity submission;

  const AskStep3PreviewScreen({
    super.key,
    required this.submission,
  });

  @override
  State<AskStep3PreviewScreen> createState() => _AskStep3PreviewScreenState();
}

class _AskStep3PreviewScreenState extends State<AskStep3PreviewScreen> {
  String _visibility = 'district';
  bool _postToTimeline = true;

  @override
  void initState() {
    super.initState();
    _visibility = widget.submission.visibility;
    _postToTimeline = widget.submission.postToTimeline;
  }

  void _onPost() {
    final finalSubmission = widget.submission.copyWith(
      visibility: _visibility,
      postToTimeline: _postToTimeline,
    );
    context.read<AskSubmissionBloc>().add(AskPublishRequested(finalSubmission));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final finalSubmission = widget.submission.copyWith(
      visibility: _visibility,
      postToTimeline: _postToTimeline,
    );

    return BlocConsumer<AskSubmissionBloc, AskSubmissionState>(
      listener: (context, state) {
        if (state.status == AskSubmissionStatus.success) {
          // Instantly refresh Home timeline feed, Peers Feed, and My Asks
          try {
            context.read<HomeBloc>().add(const HomeFeedRefreshRequested());
          } catch (_) {}
          try {
            context.read<PeersFeedBloc>().add(const PeersFeedFetchRequested(isRefresh: true));
          } catch (_) {}
          try {
            context.read<MyAsksBloc>().add(const MyAsksFetchRequested(refresh: true));
          } catch (_) {}

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your ask has been posted successfully!'),
              backgroundColor: AppColor.primaryBlue,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state.status == AskSubmissionStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unable to publish request'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AskSubmissionStatus.loading;
        final isReferral = widget.submission.flow.code.toLowerCase() == 'referral';
        final headerTitle = isReferral ? 'Preview your Ask' : 'Preview your request';
        final postBtnLabel = isReferral ? 'Post my Ask' : 'Post my request';

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: AppCommonBar(
            title: widget.submission.flow.name,
            showBack: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                AskStepHeader(
                  title: headerTitle,
                  subtitle: 'This is how peers will see it',
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AskPreviewCard(submission: finalSubmission),
                        const SizedBox(height: 14),
                        Text(
                          'Who can see this?',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildVisibilityPill('global', 'All Peers Global', isDark),
                            _buildVisibilityPill('district', 'My District', isDark),
                            _buildVisibilityPill('circle', 'My Circle', isDark),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                              width: 0.8,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => setState(() => _postToTimeline = !_postToTimeline),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _postToTimeline,
                                    activeColor: AppColor.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _postToTimeline = val ?? true;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Post to Timeline',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: titleColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Publish this request to the global feed so peers can discover and help.',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Action Buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                        width: 0.9,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isLoading ? null : AppColor.brandGradient,
                            color: isLoading ? (isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle) : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _onPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    postBtnLabel,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: titleColor,
                            side: BorderSide(color: borderColor, width: 0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisibilityPill(String value, String label, bool isDark) {
    final isSelected = _visibility == value;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => setState(() => _visibility = value),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColor.brandGradient : null,
            color: isSelected ? null : (isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurface),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
                    color: borderColor,
                    width: 0.8,
                  ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : titleColor,
            ),
          ),
        ),
      ),
    );
  }
}
