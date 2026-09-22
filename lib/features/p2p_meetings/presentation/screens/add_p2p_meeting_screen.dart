import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unity_app/core/constants/app_colors.dart';
import 'package:unity_app/core/utils/paywall_gate_helper.dart';
import 'package:unity_app/core/widgets/app_common_bar.dart';
import 'package:unity_app/core/widgets/common_peer_selector_sheet.dart';
import 'package:unity_app/features/p2p_meetings/domain/usecases/log_p2p_meeting_usecase.dart';
import 'package:unity_app/features/p2p_meetings/domain/usecases/upload_activity_creative_usecase.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/add_p2p_meeting_bloc.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/add_p2p_meeting_event.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/add_p2p_meeting_state.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/add_p2p_meeting/meeting_date_picker_field.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/add_p2p_meeting/meeting_photo_picker.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/add_p2p_meeting/meeting_remarks_input.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/add_p2p_meeting/p2p_creative_preview_section.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/add_p2p_meeting/selected_peer_card.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_meeting_location_field.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_success_sheet.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';
import 'package:unity_app/features/profile/domain/usecases/upload_file_usecase.dart';
import 'package:unity_app/features/profile/presentation/bloc/profile_bloc.dart';

class AddP2pMeetingScreen extends StatelessWidget {
  final PeerEntity? initialPeer;
  final DateTime? initialDate;
  final String? initialPlace;

  const AddP2pMeetingScreen({
    super.key,
    this.initialPeer,
    this.initialDate,
    this.initialPlace,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AddP2pMeetingBloc(
        logP2pMeetingUseCase: ctx.read<LogP2pMeetingUseCase>(),
        uploadActivityCreativeUseCase: ctx
            .read<UploadActivityCreativeUseCase>(),
        uploadFileUseCase: ctx.read<UploadProfileMediaUseCase>(),
      ),
      child: _AddP2pMeetingView(
        initialPeer: initialPeer,
        initialDate: initialDate,
        initialPlace: initialPlace,
      ),
    );
  }
}

class _AddP2pMeetingView extends StatefulWidget {
  final PeerEntity? initialPeer;
  final DateTime? initialDate;
  final String? initialPlace;

  const _AddP2pMeetingView({
    this.initialPeer,
    this.initialDate,
    this.initialPlace,
  });

  @override
  State<_AddP2pMeetingView> createState() => _AddP2pMeetingViewState();
}

class _AddP2pMeetingViewState extends State<_AddP2pMeetingView> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _cardKey = GlobalKey();
  final _placeController = TextEditingController();
  final _remarksController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    if (widget.initialPlace != null && widget.initialPlace!.isNotEmpty) {
      _placeController.text = widget.initialPlace!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.initialPeer != null) {
          context.read<AddP2pMeetingBloc>().add(
            AddP2pMeetingPeerSelected(widget.initialPeer),
          );
        } else {
          final currentPeer = context
              .read<AddP2pMeetingBloc>()
              .state
              .selectedPeer;
          if (currentPeer == null) _openPeerSelector(context);
        }
        if (widget.initialPlace != null && widget.initialPlace!.isNotEmpty) {
          context.read<AddP2pMeetingBloc>().add(
            AddP2pMeetingPlaceChanged(widget.initialPlace!),
          );
        }
        _updateDateInBloc(_selectedDate);
      }
    });
  }

  @override
  void dispose() {
    _placeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _updateDateInBloc(DateTime d) {
    _selectedDate = d;
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    context.read<AddP2pMeetingBloc>().add(
      AddP2pMeetingDateChanged('$y-$m-$day'),
    );
  }

  Future<void> _openPeerSelector(BuildContext context) async {
    final selected = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer for 1-to-1 Meeting',
    );
    if (selected != null && context.mounted) {
      context.read<AddP2pMeetingBloc>().add(
        AddP2pMeetingPeerSelected(selected),
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
        final fileName =
            'P2P_Meeting_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File('${directory.path}/$fileName');
        await imageFile.writeAsBytes(buffer);
        return imageFile;
      }
    } catch (e) {
      debugPrint('Error capturing creative card: $e');
    }
    return null;
  }

  Future<void> _submit(BuildContext context, AddP2pMeetingState state) async {
    if (state.selectedPeer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a peer member')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to log and schedule P2P meetings.')) {
      return;
    }

    final bloc = context.read<AddP2pMeetingBloc>();
    bloc.add(AddP2pMeetingPlaceChanged(_placeController.text.trim()));
    bloc.add(AddP2pMeetingRemarksChanged(_remarksController.text.trim()));

    final File? capturedCreative = await _captureCardAsImage();
    bloc.add(AddP2pMeetingSubmitted(creativeImage: capturedCreative));
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

    return BlocConsumer<AddP2pMeetingBloc, AddP2pMeetingState>(
      listener: (context, state) {
        if (state.status == AddP2pMeetingStatus.success) {
          P2pSuccessSheet.show(
            context,
            coinsEarned: state.createdMeeting?.coinsEarned ?? 3000,
            impactEarned: state.createdMeeting?.impactEarned ?? 1,
            onDone: () {
              Navigator.pop(context); // Close celebration sheet
              Navigator.pop(context, true); // Close AddP2pMeetingScreen
            },
          );
        } else if (state.status == AddP2pMeetingStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == AddP2pMeetingStatus.submitting;
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppCommonBar(
            title: 'P2P Meetings',
            showBack: true,
            showSearch: false,
            showNotifications: false,
            showProfile: false,
            showChat: false,
            onBackTap: () => Navigator.pop(context),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SelectedPeerCard(
                  selectedPeer: state.selectedPeer,
                  onTap: () => _openPeerSelector(context),
                ),
                const SizedBox(height: 16),
                MeetingDatePickerField(
                  selectedDate: _selectedDate,
                  onDateSelected: (d) {
                    setState(() => _updateDateInBloc(d));
                  },
                ),
                const SizedBox(height: 16),
                P2pMeetingLocationField(
                  controller: _placeController,
                  initialType:
                      widget.initialPlace != null &&
                          (widget.initialPlace!.toLowerCase().contains(
                                'meet',
                              ) ||
                              widget.initialPlace!.toLowerCase().contains(
                                'zoom',
                              ) ||
                              widget.initialPlace!.toLowerCase().contains(
                                'teams',
                              ) ||
                              widget.initialPlace!.toLowerCase().contains(
                                'http',
                              ))
                      ? 'Virtual'
                      : 'In-Person',
                ),
                const SizedBox(height: 16),
                MeetingRemarksInput(controller: _remarksController),
                const SizedBox(height: 16),
                MeetingPhotoPicker(
                  selectedImage: state.photoFile,
                  onImageChanged: (f) => context.read<AddP2pMeetingBloc>().add(
                    AddP2pMeetingPhotoSelected(f),
                  ),
                ),
                if (state.selectedPeer != null) ...[
                  const SizedBox(height: 20),
                  P2pCreativePreviewSection(
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
                    templateBackgroundUrl: state.templateBackgroundUrl,
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => _submit(context, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                        : const Text(
                            'Save Completed Meeting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
