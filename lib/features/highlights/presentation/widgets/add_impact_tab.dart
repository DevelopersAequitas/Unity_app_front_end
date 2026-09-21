import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/common_peer_selector_sheet.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/submit_life_impact_params.dart';
import '../bloc/life_impact/life_impact_state.dart';
import 'highlight_text_field.dart';

class AddImpactTab extends StatefulWidget {
  final LifeImpactState state;
  final ValueChanged<SubmitLifeImpactParams> onSubmit;

  const AddImpactTab({
    super.key,
    required this.state,
    required this.onSubmit,
  });

  @override
  State<AddImpactTab> createState() => _AddImpactTabState();
}

class _AddImpactTabState extends State<AddImpactTab> {
  final _formKey = GlobalKey<FormState>();
  PeerEntity? _selectedPeer;
  String? _selectedAction;
  DateTime _selectedDate = DateTime.now();
  int _lifeImpacted = 1;
  final _storyController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _storyController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickPeer() async {
    final peer = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer for Life Impact',
      selectedPeerId: _selectedPeer?.id,
    );
    if (peer != null && mounted) {
      setState(() => _selectedPeer = peer);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (_selectedPeer == null) {
      AppSnackBar.showError(context, 'Please select the peer you impacted.');
      return;
    }
    if (_selectedAction == null || _selectedAction!.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please select a life impact action.');
      return;
    }

    // Decode "key|||label" — submit only the key to the API
    final actionKey = _selectedAction!.contains('|||')
        ? _selectedAction!.split('|||').first.trim()
        : _selectedAction!.trim();

    final dateStr = AppDateFormatter.toUtcDateString(_selectedDate);

    final params = SubmitLifeImpactParams(
      impactedPeerId: _selectedPeer!.id,
      action: actionKey,
      date: dateStr,
      lifeImpacted: _lifeImpacted,
      storyToShare: _storyController.text.trim(),
      additionalRemarks: _remarksController.text.trim(),
    );

    widget.onSubmit(params);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = AppDateFormatter.format(_selectedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeerSelector(isDark),
            const SizedBox(height: 10),
            _buildDateSelector(isDark, dateStr),
            const SizedBox(height: 10),
            _buildActionDropdown(isDark),
            const SizedBox(height: 10),
            _buildPointsSelector(isDark),
            const SizedBox(height: 10),
            HighlightTextField(
              controller: _storyController,
              label: 'Story to Share',
              hint: 'e.g. Helped close a new client deal together.',
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            HighlightTextField(
              controller: _remarksController,
              label: 'Additional Remarks',
              hint: 'e.g. Great teamwork and follow-up.',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeerSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Impacted Peer *',
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _pickPeer,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                if (_selectedPeer != null) ...[
                  AppAvatar(
                    imageUrl: _selectedPeer!.profilePhotoUrl,
                    name: _selectedPeer!.displayName,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedPeer!.displayName,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_selectedPeer!.companyName?.isNotEmpty == true)
                          Text(
                            _selectedPeer!.companyName!,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.person_search_rounded, size: 20, color: AppColor.primaryBlue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tap to choose peer to impact',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColor.primaryBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(bool isDark, String dateStr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date *',
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                    fontSize: 13,
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionDropdown(bool isDark) {
    final actions = widget.state.actions;

    // Helper to get display label from "key|||label" or plain string
    String labelOf(String entry) =>
        entry.contains('|||') ? entry.split('|||').last.trim() : entry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Life Impact Action *',
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              width: 0.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              // Match by full entry string
              value: actions.contains(_selectedAction) ? _selectedAction : null,
              hint: Text(
                'Select Impact Action',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColor.primaryBlue),
              dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
              items: actions.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry,
                  child: Text(
                    // Show the human-readable label part
                    labelOf(entry),
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedAction = val),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPointsSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Life Impacted Score *',
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_lifeImpacted ${_lifeImpacted == 1 ? "Life" : "Lives"} Transformed',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                    color: _lifeImpacted > 1 ? AppColor.primaryBlue : AppColor.lightTextDisabled,
                    onPressed: _lifeImpacted > 1
                        ? () => setState(() => _lifeImpacted--)
                        : null,
                  ),
                  Text(
                    '$_lifeImpacted',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: AppColor.primaryBlue),
                    onPressed: () => setState(() => _lifeImpacted++),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColor.brandGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryBlue.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.state.isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: widget.state.isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  'Record Life Impact',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }
}