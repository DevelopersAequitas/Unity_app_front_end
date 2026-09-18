import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class AddImpactBottomSheet extends StatefulWidget {
  final Function(String title, String description, String category, int points) onSubmit;
  final bool isSubmitting;

  const AddImpactBottomSheet({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<AddImpactBottomSheet> createState() => _AddImpactBottomSheetState();
}

class _AddImpactBottomSheetState extends State<AddImpactBottomSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Collaboration';
  int _points = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;
    widget.onSubmit(_titleController.text.trim(), _descController.text.trim(), _selectedCategory, _points);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Record Life Impact', style: AppTypography.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Action Title (e.g. Provided Mentorship)',
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Story / Details (e.g. Guided student founder...)',
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: const [DropdownMenuItem(value: 'Collaboration', child: Text('Collaboration')), DropdownMenuItem(value: 'Mentorship', child: Text('Mentorship')), DropdownMenuItem(value: 'Community', child: Text('Community'))],
                  onChanged: (val) => val != null ? setState(() => _selectedCategory = val) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _points,
                  decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: const [DropdownMenuItem(value: 1, child: Text('+1 Life')), DropdownMenuItem(value: 5, child: Text('+5 Lives')), DropdownMenuItem(value: 10, child: Text('+10 Lives'))],
                  onChanged: (val) => val != null ? setState(() => _points = val) : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: widget.isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
              child: widget.isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Submit Life Impact'),
            ),
          ),
        ],
      ),
    );
  }
}
