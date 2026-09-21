import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/post_ask_entity.dart';
import '../bloc/post_ask/post_ask_bloc.dart';
import '../bloc/post_ask/post_ask_event.dart';
import '../bloc/post_ask/post_ask_state.dart';
import '../widgets/highlight_text_field.dart';
import '../widgets/post_ask_attachment_picker.dart';

class AskFormScreen extends StatefulWidget {
  const AskFormScreen({super.key});

  @override
  State<AskFormScreen> createState() => _AskFormScreenState();
}

class _AskFormScreenState extends State<AskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _questionController = TextEditingController();

  String? _selectedCategory;
  File? _selectedAttachment;

  static const List<String> _categories = [
    'General Inquiry',
    'Technical Support',
    'Account Issues',
    'Feature Request',
    'Feedback',
    'Business Leads',
    'Partnership Opportunities',
    'Circle Collaboration',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final entity = PostAskEntity(
      subject: _subjectController.text.trim(),
      description: _questionController.text.trim(),
      category: _selectedCategory ?? 'General Inquiry',
      regionLabel: 'All India',
      cityName: '',
    );

    context.read<PostAskBloc>().add(
          SubmitPostAskEvent(entity, attachment: _selectedAttachment),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return BlocListener<PostAskBloc, PostAskState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == PostAskStatus.success ||
              curr.status == PostAskStatus.error),
      listener: (context, state) {
        if (state.status == PostAskStatus.success) {
          AppSnackBar.showSuccess(
            context,
            state.successMessage ?? 'Question Submitted Successfully!',
          );
          Navigator.pop(context, true);
        } else if (state.status == PostAskStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: const AppCommonBar(
          title: 'Collaboration Ask',
          showBack: true,
          showSearch: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main Form Container Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Subject Field
                          HighlightTextField(
                            controller: _subjectController,
                            label: 'Subject *',
                            hint: 'Enter the subject of your query',
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter a subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // 2. Category Dropdown
                          Text(
                            'Category *',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            dropdownColor: surfaceColor,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select category',
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              filled: true,
                              fillColor: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
                              ),
                            ),
                            items: _categories
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) => setState(() => _selectedCategory = val),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // 3. Question Textarea
                          HighlightTextField(
                            controller: _questionController,
                            label: 'Question *',
                            hint: 'Type your detailed question here...',
                            maxLines: 5,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter your question';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // 4. Attachment Picker
                          Text(
                            'Attachment (Optional)',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          BlocBuilder<PostAskBloc, PostAskState>(
                            builder: (context, state) {
                              return PostAskAttachmentPicker(
                                selectedImage: _selectedAttachment,
                                onImageSelected: (file) =>
                                    setState(() => _selectedAttachment = file),
                                isUploading: state.isUploadingAttachment,
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // 5. Submit Button
                          BlocBuilder<PostAskBloc, PostAskState>(
                            builder: (context, state) {
                              final isSubmitting =
                                  state.status == PostAskStatus.submitting;

                              return SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isSubmitting ? null : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Submit Question',
                                          style: AppTypography.bodyMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
