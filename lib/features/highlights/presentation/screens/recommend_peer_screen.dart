import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/peer_recommendation_entity.dart';
import '../bloc/recommend_peer/recommend_peer_bloc.dart';
import '../bloc/recommend_peer/recommend_peer_event.dart';
import '../bloc/recommend_peer/recommend_peer_state.dart';
import '../widgets/certification_info_banner.dart';
import '../widgets/recommend_peer_form_fields.dart';

class RecommendPeerScreen extends StatefulWidget {
  const RecommendPeerScreen({super.key});

  @override
  State<RecommendPeerScreen> createState() => _RecommendPeerScreenState();
}

class _RecommendPeerScreenState extends State<RecommendPeerScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _businessController = TextEditingController();
  final _whyController = TextEditingController();
  String _howWellKnown = 'business_associate';
  bool _isAware = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _businessController.dispose();
    _whyController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to recommend peers.')) {
      return;
    }

    if (_nameController.text.trim().isEmpty || _mobileController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please enter the peer name and contact number.');
      return;
    }

    context.read<RecommendPeerBloc>().add(
          SubmitPeerRecommendationEvent(
            PeerRecommendationEntity(
              peerName: _nameController.text.trim(),
              peerMobile: _mobileController.text.trim(),
              peerEmail: _emailController.text.trim(),
              peerCityCountry: _cityController.text.trim(),
              peerBusiness: _businessController.text.trim(),
              howWellKnown: _howWellKnown,
              isAware: _isAware,
              whyValuable: _whyController.text.trim(),
              note: '',
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Recommend a Peer',
        showBack: Navigator.canPop(context),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocConsumer<RecommendPeerBloc, RecommendPeerState>(
            listener: (context, state) {
              if (state.status == RecommendPeerStatus.success && state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                Navigator.pop(context);
              } else if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final isSubmitting = state.status == RecommendPeerStatus.submitting;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                children: [
                  const CertificationInfoBanner(
                    title: 'Recommend High-Caliber Peers',
                    description: 'Introduce trusted entrepreneurs, business leaders, and executives into the global network.',
                    icon: Icons.person_add_alt_1_rounded,
                  ),
                  const SizedBox(height: 14),
                  RecommendPeerFormFields(
                    nameController: _nameController,
                    mobileController: _mobileController,
                    emailController: _emailController,
                    cityController: _cityController,
                    businessController: _businessController,
                    whyController: _whyController,
                    howWellKnown: _howWellKnown,
                    onHowWellKnownChanged: (val) => val != null ? setState(() => _howWellKnown = val) : null,
                    isAware: _isAware,
                    onIsAwareChanged: (val) => setState(() => _isAware = val),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('Submit Recommendation', style: AppTypography.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
