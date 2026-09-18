import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/business_deals_remote_datasource.dart';
import '../../domain/entities/create_business_deal_params.dart';
import '../../domain/usecases/create_business_deal_usecase.dart';
import '../../domain/usecases/upload_business_deal_creative_usecase.dart';
import '../../../profile/domain/usecases/upload_file_usecase.dart';
import 'add_business_deal_event.dart';
import 'add_business_deal_state.dart';

class AddBusinessDealBloc
    extends Bloc<AddBusinessDealEvent, AddBusinessDealState> {
  final CreateBusinessDealUseCase createBusinessDealUseCase;
  final UploadBusinessDealCreativeUseCase? uploadActivityCreativeUseCase;
  final UploadProfileMediaUseCase? uploadFileUseCase;

  AddBusinessDealBloc({
    required this.createBusinessDealUseCase,
    this.uploadActivityCreativeUseCase,
    this.uploadFileUseCase,
  }) : super(AddBusinessDealState()) {
    on<AddBusinessDealPeerSelected>(_onSelectPeer);
    on<AddBusinessDealAmountChanged>(_onAmountChanged);
    on<AddBusinessDealTypeChanged>(_onTypeChanged);
    on<AddBusinessDealDateChanged>(_onDateChanged);
    on<AddBusinessDealCommentChanged>(_onCommentChanged);
    on<AddBusinessDealReferralIdChanged>(_onReferralIdChanged);
    on<AddBusinessDealSubmitted>(_onSubmit);
    on<AddBusinessDealReset>(_onReset);
  }

  void _onSelectPeer(
    AddBusinessDealPeerSelected event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(state.copyWith(
      selectedPeer: event.peer,
      clearPeer: event.peer == null,
    ));
  }

  void _onAmountChanged(
    AddBusinessDealAmountChanged event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onTypeChanged(
    AddBusinessDealTypeChanged event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(state.copyWith(businessType: event.businessType));
  }

  void _onDateChanged(
    AddBusinessDealDateChanged event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(state.copyWith(dealDate: event.dealDate));
  }

  void _onCommentChanged(
    AddBusinessDealCommentChanged event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(state.copyWith(comment: event.comment));
  }

  void _onReferralIdChanged(
    AddBusinessDealReferralIdChanged event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(state.copyWith(
      referralId: event.referralId,
      clearReferralId: event.referralId == null,
    ));
  }

  Future<void> _onSubmit(
    AddBusinessDealSubmitted event,
    Emitter<AddBusinessDealState> emit,
  ) async {
    if (!state.isValid) {
      String errorMessage = 'Please fill all required fields.';
      if (state.selectedPeer == null) {
        errorMessage = 'Please select a peer.';
      } else if (state.parsedAmount <= 0) {
        errorMessage = 'Please enter a valid deal amount.';
      } else if (state.dealDate.isEmpty) {
        errorMessage = 'Please select a deal date.';
      }

      emit(state.copyWith(
        status: AddBusinessDealStatus.failure,
        errorMessage: errorMessage,
      ));
      return;
    }

    emit(state.copyWith(status: AddBusinessDealStatus.submitting));

    try {
      final File? creative = event.creativeImage;

      // ── Step 1: Upload creative as timeline post media (if no user photo) ──
      final mediaFileIds = <String>[];
      if (uploadFileUseCase != null && creative != null) {
        try {
          final uploadRes = await uploadFileUseCase!(creative);
          if (uploadRes.isNotEmpty) {
            mediaFileIds.add(uploadRes);
          }
        } catch (e) {
          debugPrint('⚠️ Error uploading creative card as media: $e');
        }
      }

      // ── Step 2: Create the business deal record ──
      final params = CreateBusinessDealParams(
        toUserId: state.selectedPeer!.id,
        dealDate: state.dealDate,
        dealAmount: state.parsedAmount,
        businessType: state.businessType,
        comment: state.comment.trim().isNotEmpty ? state.comment.trim() : null,
        referralId: state.referralId,
        mediaFileIds: mediaFileIds.isNotEmpty ? mediaFileIds : null,
      );

      final created = await createBusinessDealUseCase(params);

      // ── Step 3: Register creative in /activity-creatives (fire-and-forget) ──
      if (creative != null && uploadActivityCreativeUseCase != null) {
        try {
          await uploadActivityCreativeUseCase!(
            activityId: created.id,
            postId: created.postId ?? created.id,
            creativeImage: creative,
          );
        } catch (e) {
          debugPrint('⚠️ Error uploading business deal creative: $e');
        }
      }

      emit(state.copyWith(
        status: AddBusinessDealStatus.success,
        createdDeal: created,
      ));
    } on ProMembershipRequiredException catch (e) {
      emit(state.copyWith(
        status: AddBusinessDealStatus.requiresPro,
        errorMessage: e.message,
      ));
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('pro') || msg.contains('membership')) {
        emit(state.copyWith(
          status: AddBusinessDealStatus.requiresPro,
          errorMessage: 'Upgrade to Pro to record business deals with peers.',
        ));
      } else {
        emit(state.copyWith(
          status: AddBusinessDealStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  void _onReset(
    AddBusinessDealReset event,
    Emitter<AddBusinessDealState> emit,
  ) {
    emit(AddBusinessDealState());
  }
}
