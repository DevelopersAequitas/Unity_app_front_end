import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/common_peer_selector_sheet.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/domain/usecases/upload_file_usecase.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/usecases/create_business_deal_usecase.dart';
import '../../domain/usecases/upload_business_deal_creative_usecase.dart';
import '../bloc/add_business_deal_bloc.dart';
import '../bloc/add_business_deal_event.dart';
import '../bloc/add_business_deal_state.dart';
import '../widgets/add_business_deal/business_deal_amount_input.dart';
import '../widgets/add_business_deal/business_deal_creative_preview_section.dart';
import '../widgets/add_business_deal/business_type_selector.dart';
import '../widgets/add_business_deal/deal_comment_input.dart';
import '../widgets/add_business_deal/deal_date_picker_field.dart';
import '../widgets/add_business_deal/selected_peer_card.dart';

class AddBusinessDealScreen extends StatelessWidget {
  const AddBusinessDealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AddBusinessDealBloc(
        createBusinessDealUseCase: ctx.read<CreateBusinessDealUseCase>(),
        uploadActivityCreativeUseCase:
            ctx.read<UploadBusinessDealCreativeUseCase>(),
        uploadFileUseCase: ctx.read<UploadProfileMediaUseCase>(),
      ),
      child: const _AddBusinessDealView(),
    );
  }
}

class _AddBusinessDealView extends StatefulWidget {
  const _AddBusinessDealView();

  @override
  State<_AddBusinessDealView> createState() => _AddBusinessDealViewState();
}

class _AddBusinessDealViewState extends State<_AddBusinessDealView> {
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentPeer =
            context.read<AddBusinessDealBloc>().state.selectedPeer;
        if (currentPeer == null) {
          _openPeerSelector(context);
        }
      }
    });
  }

  Future<void> _openPeerSelector(BuildContext context) async {
    final selected = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer for Deal',
    );
    if (selected != null && context.mounted) {
      context.read<AddBusinessDealBloc>().add(
            AddBusinessDealPeerSelected(selected),
          );
    }
  }

  Future<File?> _captureCardAsImage() async {
    try {
      final RenderRepaintBoundary? boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      await Future.delayed(const Duration(milliseconds: 100));
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final directory = await getTemporaryDirectory();
        final fileName = 'BD_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File('${directory.path}/$fileName');
        await imageFile.writeAsBytes(buffer);
        return imageFile;
      }
    } catch (e) {
      debugPrint('Error capturing creative card: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    final myName = profile?.displayName ?? 'You';
    final myCity =
        profile?.city?.name ??
        profile?.city?.formattedLocation ??
        profile?.businessCity;
    final myCompanyName = profile?.companyName;
    final myCategory =
        profile?.businessCategory ??
        profile?.mainBusinessCategory ??
        (profile?.categories.isNotEmpty == true
            ? profile!.categories.first.level1
            : null);
    final myAvatarUrl = profile?.profilePhotoUrl;

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
              'Add Business Deal',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppColor.lightTextPrimary,
              ),
            ),
            Text(
              'Record business done with a peer.',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AddBusinessDealBloc, AddBusinessDealState>(
        listener: (context, state) {
          if (state.status == AddBusinessDealStatus.requiresPro) {
            AppSnackBar.showInfo(
              context,
              state.errorMessage ??
                  'Upgrade to Pro to record business deals with peers.',
            );
            Navigator.pushNamed(context, AppRoutes.membershipPaywall);
          } else if (state.status == AddBusinessDealStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          } else if (state.status == AddBusinessDealStatus.success) {
            Navigator.pop(context, {
              'success': true,
              'deal': state.createdDeal,
              'coinsEarned': state.createdDeal?.coinsEarned,
              'impactEarned': state.createdDeal?.impactEarned,
            });
          }
        },
        builder: (context, state) {
          final isSubmitting =
              state.status == AddBusinessDealStatus.submitting;

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
                      context.read<AddBusinessDealBloc>().add(
                            const AddBusinessDealPeerSelected(null),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  BusinessDealAmountInput(
                    initialValue: state.amount,
                    onChanged: (val) {
                      context.read<AddBusinessDealBloc>().add(
                            AddBusinessDealAmountChanged(val),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  BusinessTypeSelector(
                    selectedType: state.businessType,
                    onChanged: (val) {
                      context.read<AddBusinessDealBloc>().add(
                            AddBusinessDealTypeChanged(val),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  DealDatePickerField(
                    dealDate: state.dealDate,
                    onDateSelected: (val) {
                      context.read<AddBusinessDealBloc>().add(
                            AddBusinessDealDateChanged(val),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  DealCommentInput(
                    value: state.comment,
                    onChanged: (val) {
                      context.read<AddBusinessDealBloc>().add(
                            AddBusinessDealCommentChanged(val),
                          );
                    },
                  ),

                  // ── Creative Preview (shows once a peer is selected) ──
                  if (state.selectedPeer != null) ...[
                    const SizedBox(height: 20),
                    BusinessDealCreativePreviewSection(
                      cardKey: _cardKey,
                      myName: myName,
                      myCity: myCity,
                      myCompanyName: myCompanyName,
                      myCategory: myCategory,
                      myAvatarUrl: myAvatarUrl,
                      peerName: state.selectedPeer!.displayName,
                      peerCity: state.selectedPeer!.city,
                      peerCompanyName: state.selectedPeer!.companyName,
                      peerCategory: state.selectedPeer!.category,
                      peerAvatarUrl: state.selectedPeer!.profilePhotoUrl,
                      templateBackgroundUrl: null, // pass from config if needed
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSubmitting || !state.isValid
                          ? null
                          : () async {
                              final File? creativeFile =
                                  await _captureCardAsImage();
                              if (context.mounted) {
                                context.read<AddBusinessDealBloc>().add(
                                      AddBusinessDealSubmitted(
                                        creativeImage: creativeFile,
                                      ),
                                    );
                              }
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
                              'Record Business Deal',
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
