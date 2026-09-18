import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/common_peer_selector_sheet.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/usecases/create_referral_usecase.dart';
import '../bloc/add_referral_bloc.dart';
import '../bloc/add_referral_event.dart';
import '../bloc/add_referral_state.dart';
import '../widgets/add_referral/contact_import_tile.dart';
import '../widgets/add_referral/hot_value_selector.dart';
import '../widgets/add_referral/referral_contact_inputs.dart';
import '../widgets/add_referral/referral_date_picker_field.dart';
import '../widgets/add_referral/referral_prospect_input.dart';
import '../widgets/add_referral/referral_remarks_input.dart';
import '../widgets/add_referral/referral_type_selector.dart';
import '../widgets/add_referral/selected_peer_card.dart';

class AddReferralScreen extends StatelessWidget {
  const AddReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AddReferralBloc(
        createReferralUseCase: ctx.read<CreateReferralUseCase>(),
      ),
      child: const _AddReferralView(),
    );
  }
}

class _AddReferralView extends StatefulWidget {
  const _AddReferralView();

  @override
  State<_AddReferralView> createState() => _AddReferralViewState();
}

class _AddReferralViewState extends State<_AddReferralView> {
  final TextEditingController _referralOfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentPeer = context.read<AddReferralBloc>().state.selectedPeer;
        if (currentPeer == null) _openPeerSelector(context);
      }
    });
  }

  @override
  void dispose() {
    _referralOfController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _openPeerSelector(BuildContext context) async {
    final selected = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer for Referral',
    );
    if (selected != null && context.mounted) {
      context.read<AddReferralBloc>().add(AddReferralPeerSelected(selected));
    }
  }

  Future<void> _pickFromContacts() async {
    final result = await ContactPickerSheet.pickContact(context);
    if (result != null && mounted) {
      if (result.name.isNotEmpty && result.name != 'Unknown') {
        _referralOfController.text = result.name;
        context.read<AddReferralBloc>().add(AddReferralOfChanged(result.name));
      }
      if (result.phone.isNotEmpty) {
        _phoneController.text = result.phone;
        context.read<AddReferralBloc>().add(AddReferralPhoneChanged(result.phone));
      }
      if (result.email != null && result.email!.isNotEmpty) {
        _emailController.text = result.email!;
        context.read<AddReferralBloc>().add(AddReferralEmailChanged(result.email!));
      }
      if (result.address != null && result.address!.isNotEmpty) {
        _addressController.text = result.address!;
        context.read<AddReferralBloc>().add(AddReferralAddressChanged(result.address!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColor.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColor.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Give a Referral',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppColor.lightTextPrimary,
              ),
            ),
            Text(
              'Share a business lead with a peer.',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AddReferralBloc, AddReferralState>(
        listener: (context, state) {
          if (state.status == AddReferralStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          } else if (state.status == AddReferralStatus.success) {
            Navigator.pop(context, {
              'success': true,
              'referral': state.createdReferral,
              'coinsEarned': state.createdReferral?.coinsEarned,
              'impactEarned': state.createdReferral?.impactEarned,
            });
          }
        },
        builder: (context, state) {
          final isSubmitting = state.status == AddReferralStatus.submitting;
          final bloc = context.read<AddReferralBloc>();

          return ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedPeerCard(
                    peer: state.selectedPeer,
                    onTapSelect: () => _openPeerSelector(context),
                    onClear: () => bloc.add(const AddReferralPeerSelected(null)),
                  ),
                  const SizedBox(height: 16),
                  ReferralTypeSelector(
                    selectedType: state.referralType,
                    onTypeChanged: (v) => bloc.add(AddReferralTypeChanged(v)),
                  ),
                  const SizedBox(height: 16),
                  HotValueSelector(
                    hotValue: state.hotValue,
                    onHotValueChanged: (v) => bloc.add(AddReferralHotValueChanged(v)),
                  ),
                  const SizedBox(height: 16),
                  ReferralDatePickerField(
                    referralDate: state.referralDate,
                    onDateSelected: (v) => bloc.add(AddReferralDateChanged(v)),
                  ),
                  const SizedBox(height: 16),
                  ContactImportTile(onTap: _pickFromContacts),
                  const SizedBox(height: 16),
                  ReferralProspectInput(
                    controller: _referralOfController,
                    onChanged: (v) => bloc.add(AddReferralOfChanged(v)),
                  ),
                  const SizedBox(height: 16),
                  ReferralContactInputs(
                    phoneController: _phoneController,
                    emailController: _emailController,
                    addressController: _addressController,
                    onPhoneChanged: (v) => bloc.add(AddReferralPhoneChanged(v)),
                    onEmailChanged: (v) => bloc.add(AddReferralEmailChanged(v)),
                    onAddressChanged: (v) => bloc.add(AddReferralAddressChanged(v)),
                    onPickContact: _pickFromContacts,
                  ),
                  const SizedBox(height: 16),
                  ReferralRemarksInput(
                    controller: _remarksController,
                    onChanged: (v) => bloc.add(AddReferralRemarksChanged(v)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSubmitting || !state.isValid
                          ? null
                          : () => bloc.add(const AddReferralSubmitted()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: AppColor.white,
                        disabledBackgroundColor:
                            AppColor.primaryBlue.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.white,
                              ),
                            )
                          : const Text(
                              'Share Referral',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
