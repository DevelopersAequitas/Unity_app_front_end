import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../domain/entities/post_ask_entity.dart';
import '../bloc/post_ask/post_ask_bloc.dart';
import '../bloc/post_ask/post_ask_event.dart';
import '../bloc/post_ask/post_ask_state.dart';
import '../widgets/highlight_segmented_tab_bar.dart';
import '../widgets/my_asks_list_view.dart';
import '../widgets/post_ask_attachment_picker.dart';
import '../widgets/post_ask_form_fields.dart';

class PostAskScreen extends StatefulWidget {
  final int initialTabIndex;
  const PostAskScreen({super.key, this.initialTabIndex = 0});

  @override
  State<PostAskScreen> createState() => _PostAskScreenState();
}

class _PostAskScreenState extends State<PostAskScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();

  String? _selectedCategory;
  String _selectedRegion = 'All India';
  File? _selectedAttachment;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
    context.read<PostAskBloc>().add(const FetchMyAsksEvent());
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState.profile == null) {
      context.read<ProfileBloc>().add(const ProfileFetchRequested());
      return;
    }
    final p = profileState.profile!;
    if (_cityController.text.isEmpty) {
      _cityController.text = p.city?.name ?? p.businessCity ?? p.state ?? '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final entity = PostAskEntity(
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory ?? 'General Inquiry',
      regionLabel: _selectedRegion,
      cityName: _cityController.text.trim(),
    );

    context.read<PostAskBloc>().add(SubmitPostAskEvent(entity, attachment: _selectedAttachment));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.profile != null) _prefillFromProfile();
          },
        ),
        BlocListener<PostAskBloc, PostAskState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              (curr.status == PostAskStatus.success || curr.status == PostAskStatus.error),
          listener: (context, state) {
            if (state.status == PostAskStatus.success && state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _formKey.currentState?.reset();
              _subjectController.clear();
              _descriptionController.clear();
              setState(() => _selectedAttachment = null);
              _tabController.animateTo(1);
            } else if (state.status == PostAskStatus.error && state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const AppCommonBar(title: 'Post an Ask'),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: HighlightSegmentedTabBar(
                    controller: _tabController,
                    tabTitles: const ['Post an Ask', 'My Asks'],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFormTab(),
                      const MyAsksListView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormTab() {
    return BlocBuilder<PostAskBloc, PostAskState>(
      builder: (context, state) {
        final isSubmitting = state.status == PostAskStatus.submitting;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostAskFormFields(
                  subjectController: _subjectController,
                  descriptionController: _descriptionController,
                  cityController: _cityController,
                  selectedCategory: _selectedCategory,
                  selectedRegion: _selectedRegion,
                  onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                  onRegionChanged: (v) => setState(() => _selectedRegion = v ?? 'All India'),
                ),
                const SizedBox(height: 16),
                PostAskAttachmentPicker(
                  selectedImage: _selectedAttachment,
                  onImageSelected: (file) => setState(() => _selectedAttachment = file),
                  isUploading: state.isUploadingAttachment,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'Submit Ask',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
