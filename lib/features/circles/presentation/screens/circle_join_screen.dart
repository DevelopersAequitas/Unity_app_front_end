import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/usecases/get_category_subcategories_usecase.dart';
import '../../domain/usecases/submit_circle_join_usecase.dart';

class CircleJoinScreen extends StatefulWidget {
  final String circleId;
  final String? defaultSectorName;
  final String? defaultSectorId;

  const CircleJoinScreen({
    super.key,
    required this.circleId,
    this.defaultSectorName,
    this.defaultSectorId,
  });

  @override
  State<CircleJoinScreen> createState() => _CircleJoinScreenState();
}

class _CircleJoinScreenState extends State<CircleJoinScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();
  List<CircleCategoryEntity> _subcategories = [];
  CircleCategoryEntity? _selectedSubcategory;
  bool _isOtherSelected = false;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchSubcategories();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _fetchSubcategories() async {
    if (widget.defaultSectorId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final useCase = context.read<GetCategorySubcategoriesUseCase>();
      final cats = await useCase(widget.defaultSectorId.toString());

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _subcategories = cats;
        if (cats.isNotEmpty) _selectedSubcategory = cats.first;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmit() async {
    final reasonText = _reasonController.text.trim();
    if (reasonText.isEmpty) {
      AppSnackBar.showError(context, 'Please enter why you want to join this circle');
      return;
    }

    setState(() => _isSubmitting = true);

    String finalReason = reasonText;
    if (_isOtherSelected && _customCategoryController.text.trim().isNotEmpty) {
      finalReason = 'Custom Category: ${_customCategoryController.text.trim()}\n$reasonText';
    }

    try {
      final useCase = context.read<SubmitCircleJoinUseCase>();
      final req = await useCase(
        circleId: widget.circleId,
        reason: finalReason,
        categoryId: widget.defaultSectorId,
        level4CategoryId: _isOtherSelected ? null : _selectedSubcategory?.id,
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      AppSnackBar.showSuccess(context, 'Join request submitted successfully');
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.joinRequestStatus,
        arguments: {
          'requestId': req.id,
          'circleName': req.circleName.isNotEmpty ? req.circleName : (widget.defaultSectorName ?? 'Circle'),
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      AppSnackBar.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Join Circle',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Banner
                      if (widget.defaultSectorName != null) ...[
                        Text('Circle Category', style: TextStyle(fontSize: 11.5, color: secondaryText)),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            widget.defaultSectorName!,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: primaryText),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Subcategories (level 4)
                      if (_subcategories.isNotEmpty) ...[
                        Text('Select your specialization / role', style: TextStyle(fontSize: 11.5, color: secondaryText)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._subcategories.map((cat) {
                              final isSelected = !_isOtherSelected && _selectedSubcategory?.id == cat.id;
                              return ChoiceChip(
                                label: Text(cat.name, style: TextStyle(fontSize: 11.5, color: isSelected ? Colors.white : primaryText)),
                                selected: isSelected,
                                selectedColor: AppColor.primaryBlue,
                                backgroundColor: cardBg,
                                side: BorderSide(color: isSelected ? AppColor.primaryBlue : borderColor),
                                onSelected: (_) => setState(() {
                                  _isOtherSelected = false;
                                  _selectedSubcategory = cat;
                                }),
                              );
                            }),
                            ChoiceChip(
                              label: Text('Other', style: TextStyle(fontSize: 11.5, color: _isOtherSelected ? Colors.white : primaryText)),
                              selected: _isOtherSelected,
                              selectedColor: AppColor.primaryBlue,
                              backgroundColor: cardBg,
                              side: BorderSide(color: _isOtherSelected ? AppColor.primaryBlue : borderColor),
                              onSelected: (_) => setState(() => _isOtherSelected = true),
                            ),
                          ],
                        ),
                        if (_isOtherSelected) ...[
                          const SizedBox(height: 12),
                          TextField(
                            controller: _customCategoryController,
                            style: TextStyle(fontSize: 13, color: primaryText),
                            decoration: InputDecoration(
                              hintText: 'Enter your specialization name',
                              hintStyle: TextStyle(fontSize: 12, color: secondaryText),
                              filled: true,
                              fillColor: cardBg,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderColor)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                      ],

                      // Reason
                      Text('Why do you want to join?', style: TextStyle(fontSize: 11.5, color: secondaryText)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _reasonController,
                        maxLines: 4,
                        style: TextStyle(fontSize: 13, color: primaryText),
                        decoration: InputDecoration(
                          hintText: 'Tell us why you\'d like to join and how you plan to contribute...',
                          hintStyle: TextStyle(fontSize: 12, color: secondaryText),
                          filled: true,
                          fillColor: cardBg,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.2)),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Submit Request', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
