import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../peers/domain/usecases/get_all_peers_usecase.dart';
import '../../../profile/domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/create_testimonial_usecase.dart';
import '../bloc/add_testimonial_bloc.dart';
import '../bloc/add_testimonial_event.dart';
import '../bloc/add_testimonial_state.dart';
import '../widgets/add_testimonial/peer_selector_sheet.dart';
import '../widgets/add_testimonial/selected_peer_card.dart';
import '../widgets/add_testimonial/testimonial_message_input.dart';
import '../widgets/add_testimonial/testimonial_photo_picker.dart';
// import '../widgets/add_testimonial/testimonial_rating_bar.dart';

class AddTestimonialScreen extends StatelessWidget {
  const AddTestimonialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AddTestimonialBloc(
        createTestimonialUseCase: ctx.read<CreateTestimonialUseCase>(),
        getAllPeersUseCase: ctx.read<GetAllPeersUseCase>(),
        uploadFileUseCase: ctx.read<UploadProfileMediaUseCase>(),
      ),
      child: const _AddTestimonialView(),
    );
  }
}

class _AddTestimonialView extends StatefulWidget {
  const _AddTestimonialView();

  @override
  State<_AddTestimonialView> createState() => _AddTestimonialViewState();
}

class _AddTestimonialViewState extends State<_AddTestimonialView> {
  @override
  void initState() {
    super.initState();
    // Auto-open peer selector sheet upon navigating to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentPeer = context.read<AddTestimonialBloc>().state.selectedPeer;
        if (currentPeer == null) {
          _openPeerSelector(context);
        }
      }
    });
  }

  Future<void> _openPeerSelector(BuildContext context) async {
    final selected = await PeerSelectorSheet.show(context);
    if (selected != null && context.mounted) {
      context.read<AddTestimonialBloc>().add(
            AddTestimonialPeerSelected(selected),
          );
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
            size: 18,
            color: AppColor.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Testimonial',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppColor.lightTextPrimary,
              ),
            ),
            Text(
              'Appreciate a peer. Make an impact.',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AddTestimonialBloc, AddTestimonialState>(
        listener: (context, state) {
          if (state.status == AddTestimonialStatus.requiresPro) {
            AppSnackBar.showInfo(
              context,
              state.errorMessage ?? 'Upgrade to Pro to give testimonials.',
            );
            Navigator.pushNamed(context, AppRoutes.membershipPaywall);
          } else if (state.status == AddTestimonialStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          } else if (state.status == AddTestimonialStatus.success) {
            Navigator.pop(context, {
              'success': true,
              'testimonial': state.createdTestimonial,
              'coinsEarned': state.createdTestimonial?.coinsEarned,
              'impactEarned': state.createdTestimonial?.impactEarned,
            });
          }
        },
        builder: (context, state) {
          final isSubmitting = state.status == AddTestimonialStatus.submitting;

          return ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedPeerCard(
                    peer: state.selectedPeer,
                    onTapSelect: () => _openPeerSelector(context),
                    onClear: () {
                      context.read<AddTestimonialBloc>().add(
                            const AddTestimonialPeerSelected(null),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  TestimonialMessageInput(
                    value: state.message,
                    onChanged: (val) {
                      context.read<AddTestimonialBloc>().add(
                            AddTestimonialMessageChanged(val),
                          );
                    },
                  ),
                  // Rating Bar (Disabled: backend has no rating support)
                  // const SizedBox(height: 16),
                  // TestimonialRatingBar(
                  //   rating: state.rating,
                  //   onRatingChanged: (val) {
                  //     context.read<AddTestimonialBloc>().add(
                  //           AddTestimonialRatingChanged(val),
                  //         );
                  //   },
                  // ),
                  const SizedBox(height: 16),
                  TestimonialPhotoPicker(
                    imageFile: state.selectedImage,
                    onImageChanged: (file) {
                      context.read<AddTestimonialBloc>().add(
                            AddTestimonialImageSelected(file),
                          );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSubmitting || !state.isValid
                          ? null
                          : () {
                              if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to give testimonials.')) {
                                return;
                              }
                              if (!OfflineGuard.check(context, actionName: 'give testimonials')) {
                                return;
                              }
                              context.read<AddTestimonialBloc>().add(
                                    const AddTestimonialSubmitted(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: AppColor.white,
                        disabledBackgroundColor:
                            AppColor.primaryBlue.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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
                              'Give Testimonial',
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
