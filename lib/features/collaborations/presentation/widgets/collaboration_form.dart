import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/collaboration_params.dart';
import '../../domain/entities/collaboration_type.dart';
import '../../domain/entities/industry.dart';
import '../bloc/collaborations_bloc.dart';
import '../bloc/collaborations_event.dart';
import '../bloc/collaborations_state.dart';
import 'business_status_section.dart';
import 'collaboration_type_selector.dart';
import 'industry_picker_field.dart';
import 'opportunity_details_section.dart';
import 'scope_geography_section.dart';

class CollaborationForm extends StatefulWidget {
  const CollaborationForm({super.key});

  @override
  State<CollaborationForm> createState() => _CollaborationFormState();
}

class _CollaborationFormState extends State<CollaborationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countriesController = TextEditingController();

  CollaborationType? _selectedType;
  String? _selectedScope;
  String? _selectedPreferredModel;
  Industry? _selectedIndustry;
  String? _selectedBusinessStage;
  String? _selectedYearsInOperation;
  String? _selectedUrgency;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _countriesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null || _selectedScope == null || _selectedIndustry == null || _selectedBusinessStage == null || _selectedYearsInOperation == null || _selectedUrgency == null) {
      return;
    }

    List<String>? countries;
    if (_selectedScope == 'international') {
      countries = _countriesController.text.trim().split(RegExp(r'[,\s]+')).where((c) => c.trim().isNotEmpty).map((c) => c.trim().toUpperCase()).toList();
    }

    final params = CollaborationParams(
      collaborationTypeId: _selectedType!.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      scope: _selectedScope!,
      industryId: _selectedIndustry!.id,
      businessStage: _selectedBusinessStage!,
      yearsInOperation: _selectedYearsInOperation!,
      urgency: _selectedUrgency!,
      countriesOfInterest: countries,
      preferredModel: _selectedPreferredModel,
    );

    context.read<CollaborationsBloc>().add(SubmitCollaborationEvent(params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollaborationsBloc, CollaborationsState>(
      builder: (context, state) {
        final isSubmitting = state.status == CollaborationsStatus.submitting;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CollaborationTypeSelector(
                  options: state.collaborationTypes,
                  selectedType: _selectedType,
                  onChanged: (val) => setState(() => _selectedType = val),
                ),
                const SizedBox(height: 14),
                OpportunityDetailsSection(titleController: _titleController, descriptionController: _descriptionController),
                const SizedBox(height: 14),
                ScopeGeographySection(
                  selectedScope: _selectedScope,
                  selectedPreferredModel: _selectedPreferredModel,
                  countriesController: _countriesController,
                  onScopeChanged: (val) => setState(() => _selectedScope = val),
                  onModelChanged: (val) => setState(() => _selectedPreferredModel = val),
                ),
                const SizedBox(height: 14),
                IndustryPickerField(
                  industries: state.industries,
                  selectedIndustry: _selectedIndustry,
                  onIndustrySelected: (ind) => setState(() => _selectedIndustry = ind),
                ),
                const SizedBox(height: 14),
                BusinessStatusSection(
                  selectedBusinessStage: _selectedBusinessStage,
                  selectedYearsInOperation: _selectedYearsInOperation,
                  selectedUrgency: _selectedUrgency,
                  onStageChanged: (val) => setState(() => _selectedBusinessStage = val),
                  onYearsChanged: (val) => setState(() => _selectedYearsInOperation = val),
                  onUrgencyChanged: (val) => setState(() => _selectedUrgency = val),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Submit Collaboration Opportunity', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
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
